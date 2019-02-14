//
//  NetworkManager.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/20/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift
import SwifterSwift
import Kingfisher
import PromiseKit
import Alamofire

class NetworkManager
{
    let databaseManager = DatabaseManager()
    
    let today = Date()
    
    let shortDateFormatter = DateFormatter()
    let fullDateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let dateStringFormatter = DateFormatter()
    
    let userId = "6faa8a21-d219-433a-914b-fcd2d4:MYSPORTSFEEDS"
    
    //  Create a new Realm database
    let realm = try! Realm()
    
     // MARK: Save methods
    func saveRosters()
    {
        let playerList = List<NHLPlayer>()
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/players.json?rosterstatus=assigned-to-roster")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")
        
        autoreleasepool
        {
            //  Get the JSON data with closure
            session.dataTask(with: request)
            {
                (data, response, err) in
                
                if err == nil
                {
                    do
                    {
                        let rosterPlayers = try JSONDecoder().decode(RosterPlayers.self, from: data!)
                        
                        DispatchQueue.main.async
                        {
                           print("Populating team roster data...")
                            
                            for playerInfo in rosterPlayers.playerInfoList
                            {
                                let nhlPlayer = NHLPlayer()
                                
                                nhlPlayer.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                nhlPlayer.id = playerInfo.player.id
                                nhlPlayer.firstName = playerInfo.player.firstName
                                nhlPlayer.lastName = playerInfo.player.lastName
                                nhlPlayer.age = String(playerInfo.player.age ?? 0)
                                nhlPlayer.birthDate = playerInfo.player.birthDate ?? ""
                                nhlPlayer.birthCity = playerInfo.player.birthCity ?? ""
                                nhlPlayer.birthCountry = playerInfo.player.birthCountry ?? ""
                                nhlPlayer.height = playerInfo.player.height ?? ""
                                nhlPlayer.weight = String(playerInfo.player.weight ?? 0)
                                nhlPlayer.jerseyNumber = String(playerInfo.player.jerseyNumber ?? 0)
                                nhlPlayer.imageURL = playerInfo.player.officialImageSource?.absoluteString ?? ""
                                nhlPlayer.position = playerInfo.player.position ?? ""
                                nhlPlayer.shoots = playerInfo.player.handednessInfo?.shoots ?? ""
                                nhlPlayer.teamId = playerInfo.currentTeamInfo?.id ?? 0
                                nhlPlayer.teamAbbreviation = playerInfo.currentTeamInfo?.abbreviation ?? ""
                                
                                playerList.append(nhlPlayer)
                            }
                            
                            do
                            {
                                print("Saving roster data...")
                                
                                try self.realm.write
                                {
                                    self.realm.add(playerList, update: true)
                                    
                                    print("Roster players have successfully been added to the database!!")
                                }
                            }
                            catch
                            {
                                print("Error saving roster players to the database: \(error)")
                            }
                            
                            print(Realm.Configuration.defaultConfiguration.fileURL!)
                            
                            self.savePlayerStats()
                            self.savePlayerInjuries()
                        }
                    }
                    catch
                    {
                        print("Error decoding JSON in saveRosters method...")
                    }
                }
                else
                {
                    print("Error retrieving data in saveRosters method...\(err.debugDescription)")
                }
            }.resume()
        }
    }
    
    func downloadScoringSummary(forGameId gameId: Int) throws ->  Promise<ScoringSummary>
    {
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/games/\(gameId)/boxscore.json?teamstats=none&playerstats=none")
        var request = URLRequest(url: url!)

        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")

        return firstly
        {
            URLSession.shared.dataTask(.promise, with: url!)
        }.compactMap
        {
            return try JSONDecoder().decode(ScoringSummary.self, from: $0.data)
        }
    }
    
    func saveScoringSummary(forGameId gameId: Int)
    {
        let nhlScoringSummary = NHLScoringSummary()
        
        var maxValue = 0
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/games/\(gameId)/boxscore.json?teamstats=none&playerstats=none")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")
        
        autoreleasepool
        {
            //  Get the JSON data with closure
            session.dataTask(with: request)
            {
                (data, response, err) in
                
                if err == nil
                {
                    do
                    {
                        let scoringSummary = try JSONDecoder().decode(ScoringSummary.self, from: data!)
                        
                        DispatchQueue.main.async
                        {
                            print("Populating scoring summary data...")
                            
                            nhlScoringSummary.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                            nhlScoringSummary.id = gameId
                            nhlScoringSummary.gameId = gameId
                            nhlScoringSummary.playedStatus = scoringSummary.game.playedStatus
                            nhlScoringSummary.homeTeamAbbreviation = scoringSummary.game.homeTeam.abbreviation
                            nhlScoringSummary.awayTeamAbbreviation = scoringSummary.game.awayTeam.abbreviation
                            nhlScoringSummary.homeScoreTotal = scoringSummary.scoringInfo.homeScoreTotal
                            nhlScoringSummary.awayScoreTotal = scoringSummary.scoringInfo.awayScoreTotal
                            nhlScoringSummary.numberOfPeriods = scoringSummary.scoringInfo.periodList.count
                            
                            do
                            {
                                print("Saving scoring summary...")
                                
                                try self.realm.write
                                {
                                    //  Save it to realm
                                    self.realm.add(nhlScoringSummary, update: true)
                                }
                            }
                            catch
                            {
                                print("Error saving period scoring data to the database: \(error)")
                            }
                            
                            do
                            {
                                try self.realm.write
                                {
                                    let realmNHLPeriodScoringSummary = self.realm.object(ofType: NHLScoringSummary.self, forPrimaryKey: nhlScoringSummary.id)
                                    
                                    maxValue = self.realm.objects(NHLPeriodScoringData.self).max(ofProperty: "id") as Int? ?? 0
                                    
                                    print("Scoring summary for \(gameId) has successfully been added to the database!!")
                            
                                    for periodScoringData in scoringSummary.scoringInfo.periodList
                                    {
                                        for scoringPlay in periodScoringData.scoringPlays
                                        {
                                            //print("Saving period scoring data...")
                                            
                                            let nhlPeriodScoringData = NHLPeriodScoringData()
                                            
                                            nhlPeriodScoringData.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                            nhlPeriodScoringData.id = maxValue + 1
                                            nhlPeriodScoringData.gameId = gameId
                                            nhlPeriodScoringData.periodNumber = periodScoringData.periodNumber
                                            nhlPeriodScoringData.teamAbbreviation = scoringPlay.team.abbreviation
                                            nhlPeriodScoringData.periodSecondsElapsed = scoringPlay.periodSecondsElapsed
                                            nhlPeriodScoringData.playDescription = scoringPlay.playDescription
                                            
                                            //print("Period scoring data for \(gameId) has successfully been added to the database!!")
                                            
                                            maxValue += 1
                                            
                                            //print("Saving  and linking period scoring data...")
                                            
                                            //  Save it to realm
                                            self.realm.create(NHLPeriodScoringData.self, value: nhlPeriodScoringData, update: true)
                                            
                                            //  Get the playerStatistics reference from the database
                                            if let realmNHLPeriodScoringData = self.realm.object(ofType: NHLPeriodScoringData.self, forPrimaryKey: nhlPeriodScoringData.id)
                                            {
                                                realmNHLPeriodScoringSummary?.periodScoringList.append(realmNHLPeriodScoringData)
                                            }
                                        }
                                    }
                                    
                                    print("Period scoring data for \(gameId) has successfully been added to the database!!")
                                }
                            }
                            catch
                            {
                                print("Error saving period scoring data to the database: \(error)")
                            }
                            
                            print(Realm.Configuration.defaultConfiguration.fileURL!)
                        }
                    }
                    catch
                    {
                        print("Error decoding JSON in saveScoringSummary method...")
                    }
                }
                else
                {
                    print("Error retrieving data in saveScoringSummary method...\(err!.localizedDescription)")
                }
            }.resume()
        }
    }
    
    func saveSchedule()
    {
        let scheduledGames = List<NHLSchedule>()
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/games.json")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")
        
        autoreleasepool
        {
            //  Get the JSON data with closure
            session.dataTask(with: request)
            {
                (data, response, err) in
                
                if err == nil
                {
                    do
                    {
                        let seasonSchedule = try JSONDecoder().decode(SeasonSchedule.self, from: data!)
                        
                        let lastUpdatedOn = seasonSchedule.lastUpdatedOn
                        
                        print("Value of lastUpdatedOn is \(seasonSchedule.lastUpdatedOn)")
                        
                        print("Size of game list is \(seasonSchedule.gameList.count)")
                        
                        DispatchQueue.main.async
                        {
                            print("Populating game data...")
                            
                            for scheduledGame in seasonSchedule.gameList
                            {
                                let nhlSchedule = NHLSchedule()
        
                                let startTime = scheduledGame.scheduleInfo.startTime
        
                                nhlSchedule.id = scheduledGame.scheduleInfo.id
                                nhlSchedule.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                nhlSchedule.lastUpdatedOn = "\(TimeAndDateUtils.getDate(lastUpdatedOn)) at \(TimeAndDateUtils.getTime(lastUpdatedOn))"
                                nhlSchedule.date = TimeAndDateUtils.getDate(startTime)
                                nhlSchedule.time = TimeAndDateUtils.getTime(startTime)
                                nhlSchedule.homeTeam = scheduledGame.scheduleInfo.homeTeamInfo.abbreviation
                                nhlSchedule.awayTeam = scheduledGame.scheduleInfo.awayTeamInfo.abbreviation
                                nhlSchedule.homeScoreTotal = scheduledGame.scoreInfo.homeScoreTotal ?? 0
                                nhlSchedule.awayScoreTotal = scheduledGame.scoreInfo.awayScoreTotal ?? 0
                                nhlSchedule.homeShotsTotal = scheduledGame.scoreInfo.homeShotsTotal ?? 0
                                nhlSchedule.awayShotsTotal = scheduledGame.scoreInfo.awayShotsTotal ?? 0
                                nhlSchedule.playedStatus = scheduledGame.scheduleInfo.playedStatus
                                nhlSchedule.scheduleStatus = scheduledGame.scheduleInfo.scheduleStatus
                                nhlSchedule.numberOfPeriods = scheduledGame.scoreInfo.periodList?.count ?? 0
                                nhlSchedule.currentPeriod = scheduledGame.scoreInfo.currentPeriod ?? 0
                                nhlSchedule.currentTimeRemaining = scheduledGame.scoreInfo.currentPeriodSecondsRemaining ?? 0
        
                                scheduledGames.append(nhlSchedule)
                            }
                        
                            do
                            {
                                print("Saving game data...")
                                
                                try self.realm.write
                                {
                                    self.realm.add(scheduledGames)

                                    print("Scheduled games have successfully been added to the database!!")
                                }
                            }
                            catch
                            {
                                print("Error saving scheduled games to the database: \(error)")
                            }
                            
                            print(Realm.Configuration.defaultConfiguration.fileURL!)
                        }
                    }
                    catch
                    {
                        print("Error decoding JSON data in saveSchedule method...")
                    }
                }
                else
                {
                    print("Error retrieving data in saveSchedule method...\(err.debugDescription)")
                }
            }.resume()
        }
    }
    
    func updateScheduleForDate(_ date :Date)
    {
        shortDateFormatter.dateFormat = "yyyyMMdd"
        
        let scheduleDate = shortDateFormatter.string(from: date)
        
        let scheduledGames = List<NHLSchedule>()
        
        var seasonSchedule: SeasonSchedule?
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/date/\(scheduleDate)/games.json")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")
        
        autoreleasepool
        {
            //  Get the JSON data with closure
            session.dataTask(with: request)
            {
                (data, response, err) in
                
                if err == nil
                {
                    do
                    {
                        seasonSchedule = try JSONDecoder().decode(SeasonSchedule.self, from: data!)
                        
                        let lastUpdatedOn = seasonSchedule!.lastUpdatedOn
                        
                        DispatchQueue.main.async
                        {
                            for scheduledGame in seasonSchedule!.gameList
                            {
                                let nhlSchedule = NHLSchedule()
                                
                                let startTime = scheduledGame.scheduleInfo.startTime
                                
                                nhlSchedule.id = scheduledGame.scheduleInfo.id
                                nhlSchedule.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                nhlSchedule.lastUpdatedOn = "\(TimeAndDateUtils.getDate(lastUpdatedOn)) at \(TimeAndDateUtils.getTime(lastUpdatedOn))"
                                nhlSchedule.date = TimeAndDateUtils.getDate(startTime)
                                nhlSchedule.time = TimeAndDateUtils.getTime(startTime)
                                nhlSchedule.homeTeam = scheduledGame.scheduleInfo.homeTeamInfo.abbreviation
                                nhlSchedule.awayTeam = scheduledGame.scheduleInfo.awayTeamInfo.abbreviation
                                nhlSchedule.homeScoreTotal = scheduledGame.scoreInfo.homeScoreTotal ?? 0
                                nhlSchedule.awayScoreTotal = scheduledGame.scoreInfo.awayScoreTotal ?? 0
                                nhlSchedule.homeShotsTotal = scheduledGame.scoreInfo.homeShotsTotal ?? 0
                                nhlSchedule.awayShotsTotal = scheduledGame.scoreInfo.awayShotsTotal ?? 0
                                nhlSchedule.playedStatus = scheduledGame.scheduleInfo.playedStatus
                                nhlSchedule.scheduleStatus = scheduledGame.scheduleInfo.scheduleStatus
                                nhlSchedule.numberOfPeriods = scheduledGame.scoreInfo.periodList?.count ?? 0
                                nhlSchedule.currentPeriod = scheduledGame.scoreInfo.currentPeriod ?? 0
                                nhlSchedule.currentTimeRemaining = scheduledGame.scoreInfo.currentPeriodSecondsRemaining ?? 0
                                
                                scheduledGames.append(nhlSchedule)
                            }
                            
                            do
                            {
                                try self.realm.write
                                {
                                    self.realm.add(scheduledGames, update: true)
                                    
                                    print("Scheduled games for \(scheduleDate) have successfully been updated in the database!!")
                                }
                            }
                            catch
                            {
                                print("Error updating scheduled games to the database: \(error)")
                            }
                            
                            print(Realm.Configuration.defaultConfiguration.fileURL!)
                        }
                    }
                    catch
                    {
                        print("Error decoding JSON data in updateScheduleForDate method...")
                    }
                }
                else
                {
                    print("Error retrieving data in updateScheduleForDate method...\(err.debugDescription)")
                }
            }.resume()
        }
    }
    
    func saveStandings()
    {
        let teamStandingsList = List<TeamStandings>()
        let teamStatisticsList = List<TeamStatistics>()
        let teamList = List<NHLTeam>()
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/standings.json")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")
        
        autoreleasepool
        {
            //  Get the JSON data with closure
            session.dataTask(with: request)
            {
                (data, response, err) in
                
                if err == nil
                {
                    do
                    {
                        let nhlStandings = try JSONDecoder().decode(NHLStandings.self, from: data!)
                        
                        print("Value of lastUpdatedOn is \(nhlStandings.lastUpdatedOn)")
                        
                        DispatchQueue.main.async
                        {
                            for teamStandingsData in nhlStandings.teamList
                            {
                                let teamStandings = TeamStandings()
                                let teamStatistics = TeamStatistics()
                                let nhlTeam = NHLTeam()
                                
                                //  Populate the Team Standings table
                                teamStandings.id = teamStandingsData.teamInformation.id
                                teamStandings.abbreviation = teamStandingsData.teamInformation.abbreviation
                                teamStandings.division = teamStandingsData.divisionRankInfo.divisionName
                                teamStandings.divisionRank = teamStandingsData.divisionRankInfo.rank
                                teamStandings.conference = teamStandingsData.conferenceRankInfo.conferenceName
                                teamStandings.conferenceRank = teamStandingsData.conferenceRankInfo.rank
                                teamStandings.gamesPlayed = teamStandingsData.teamStats.gamesPlayed
                                teamStandings.wins = teamStandingsData.teamStats.standingsInfo.wins
                                teamStandings.losses = teamStandingsData.teamStats.standingsInfo.losses
                                teamStandings.overtimeLosses = teamStandingsData.teamStats.standingsInfo.overtimeLosses
                                teamStandings.points = teamStandingsData.teamStats.standingsInfo.points
                                teamStandings.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                
                                //  Populate the Team Statistics table
                                teamStatistics.id = teamStandingsData.teamInformation.id
                                teamStatistics.abbreviation = teamStandingsData.teamInformation.abbreviation
                                teamStatistics.gamesPlayed = teamStandingsData.teamStats.gamesPlayed
                                teamStatistics.wins = teamStandingsData.teamStats.standingsInfo.wins
                                teamStatistics.losses = teamStandingsData.teamStats.standingsInfo.losses
                                teamStatistics.overtimeLosses = teamStandingsData.teamStats.standingsInfo.overtimeLosses
                                teamStatistics.points = teamStandingsData.teamStats.standingsInfo.points
                                teamStatistics.powerplays = teamStandingsData.teamStats.powerplayInfo.powerplays
                                teamStatistics.powerplayGoals = teamStandingsData.teamStats.powerplayInfo.powerplayGoals
                                teamStatistics.powerplayPercent = teamStandingsData.teamStats.powerplayInfo.powerplayPercent
                                teamStatistics.penaltyKills = teamStandingsData.teamStats.powerplayInfo.penaltyKills
                                teamStatistics.penaltyKillGoalsAllowed = teamStandingsData.teamStats.powerplayInfo.penaltyKillGoalsAllowed
                                teamStatistics.penaltyKillPercent = teamStandingsData.teamStats.powerplayInfo.penaltyKillPercent
                                teamStatistics.goalsFor = teamStandingsData.teamStats.miscellaneousInfo.goalsFor
                                teamStatistics.goalsAgainst = teamStandingsData.teamStats.miscellaneousInfo.goalsAgainst
                                teamStatistics.shots = teamStandingsData.teamStats.miscellaneousInfo.shots
                                teamStatistics.penalties = teamStandingsData.teamStats.miscellaneousInfo.penalties
                                teamStatistics.penaltyMinutes = teamStandingsData.teamStats.miscellaneousInfo.penaltyMinutes
                                teamStatistics.hits = teamStandingsData.teamStats.miscellaneousInfo.hits
                                teamStatistics.faceoffWins = teamStandingsData.teamStats.faceoffInfo.faceoffWins
                                teamStatistics.faceoffLosses = teamStandingsData.teamStats.faceoffInfo.faceoffLosses
                                teamStatistics.faceoffPercent = teamStandingsData.teamStats.faceoffInfo.faceoffPercent
                                teamStatistics.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                
                                //  Populate the NHLTeam table
                                nhlTeam.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                nhlTeam.id = teamStandingsData.teamInformation.id
                                nhlTeam.abbreviation = teamStandingsData.teamInformation.abbreviation
                                nhlTeam.city = teamStandingsData.teamInformation.city
                                nhlTeam.name = teamStandingsData.teamInformation.name
                                nhlTeam.division = teamStandingsData.divisionRankInfo.divisionName
                                nhlTeam.conference = teamStandingsData.conferenceRankInfo.conferenceName
                                
                                teamStandingsList.append(teamStandings)
                                teamStatisticsList.append(teamStatistics)
                                teamList.append(nhlTeam)
                            }
                            
                            print("Saving standings information...")
                            
                            do
                            {
                                try self.realm.write
                                {
                                    self.realm.add(teamList, update: true)
                                }
                            }
                            catch
                            {
                                print("Error saving teams to the database: \(error)")
                            }
                            
                            do
                            {
                                try self.realm.write
                                {
                                    self.realm.add(teamStatisticsList, update: true)
                                }
                            }
                            catch
                            {
                                print("Error saving team statistics to the database: \(error)")
                            }
                            
                            do
                            {
                                try self.realm.write
                                {
                                    self.realm.add(teamStandingsList, update: true)
                                }
                            }
                            catch
                            {
                                print("Error saving team standings to the database: \(error)")
                            }
                            
                            print("Standings information successfully saved to the database!")
                            
                            print(Realm.Configuration.defaultConfiguration.fileURL!)
                        }
                    }
                    catch
                    {
                        print("Error retrieving data...\(err.debugDescription)")
                    }
                }
            }.resume()
        }
    }
    
    
    
    func savePlayerStats()
    {
        let playerResultList: Results<NHLPlayer> = databaseManager.retrieveAllPlayers()
        
        var playerDictionary = [Int:NHLPlayer]()
        
        //  Create a dictionary with id as the key
        for player in playerResultList
        {
            playerDictionary[player.id] = player
        }
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/player_stats_totals.json")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")
        
        autoreleasepool
        {
            //  Get the JSON data with closure
            session.dataTask(with: request)
            {
                (data, response, err) in
                
                if err == nil
                {
                    do
                    {
                        let playerStats = try JSONDecoder().decode(PlayerStats.self, from: data!)
                        
                        let lastUpdatedOn = playerStats.lastUpdatedOn
                        
                        print("Value of lastUpdatedOn is \(lastUpdatedOn ?? "What the hell happened????")")
                        
                        print("Size of playerStatsTotal list is \(playerStats.playerStatsTotals?.count ?? 0)")
                        
                        print("Populating player stat data...")
                        
                        if let playerStatsTotalList = playerStats.playerStatsTotals
                        {
                            DispatchQueue.main.async
                            {
                                try! self.realm.write
                                {
                                    for playerStatsTotal in playerStatsTotalList
                                    {
                                        let playerStatistics = PlayerStatistics()
                                        let playerId = playerStatsTotal.player?.id!
                                        let nhlPlayer = playerDictionary[playerId!]
                                        
                                        playerStatistics.id = playerId!
                                        playerStatistics.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                        playerStatistics.gamesPlayed = playerStatsTotal.playerStats?.gamesPlayed ?? 0
                                        playerStatistics.goals = playerStatsTotal.playerStats?.scoringData?.goals ?? 0
                                        playerStatistics.assists = playerStatsTotal.playerStats?.scoringData?.assists ?? 0
                                        playerStatistics.points = playerStatsTotal.playerStats?.scoringData?.points ?? 0
                                        playerStatistics.hatTricks = playerStatsTotal.playerStats?.scoringData?.hatTricks ?? 0
                                        playerStatistics.powerplayGoals = playerStatsTotal.playerStats?.scoringData?.powerplayGoals ?? 0
                                        playerStatistics.powerplayAssists = playerStatsTotal.playerStats?.scoringData?.powerplayAssists ?? 0
                                        playerStatistics.powerplayPoints = playerStatsTotal.playerStats?.scoringData?.powerplayPoints ?? 0
                                        playerStatistics.shortHandedGoals = playerStatsTotal.playerStats?.scoringData?.shorthandedGoals ?? 0
                                        playerStatistics.shortHandedAssists = playerStatsTotal.playerStats?.scoringData?.shorthandedAssists ?? 0
                                        playerStatistics.shortHandedPoints = playerStatsTotal.playerStats?.scoringData?.shorthandedPoints ?? 0
                                        playerStatistics.gameWinningGoals = playerStatsTotal.playerStats?.scoringData?.gameWinningGoals ?? 0
                                        playerStatistics.gameTyingGoals = playerStatsTotal.playerStats?.scoringData?.gameTyingGoals ?? 0
                                        playerStatistics.plusMinus = playerStatsTotal.playerStats?.skatingData?.plusMinus ?? 0
                                        playerStatistics.shots = playerStatsTotal.playerStats?.skatingData?.shots ?? 0
                                        playerStatistics.shotPercentage = playerStatsTotal.playerStats?.skatingData?.shotPercentage ?? 0.0
                                        playerStatistics.blockedShots = playerStatsTotal.playerStats?.skatingData?.blockedShots ?? 0
                                        playerStatistics.hits = playerStatsTotal.playerStats?.skatingData?.hits ?? 0
                                        playerStatistics.faceoffs = playerStatsTotal.playerStats?.skatingData?.faceoffs ?? 0
                                        playerStatistics.faceoffWins = playerStatsTotal.playerStats?.skatingData?.faceoffWins ?? 0
                                        playerStatistics.faceoffLosses = playerStatsTotal.playerStats?.skatingData?.faceoffLosses ?? 0
                                        playerStatistics.faceoffPercent = playerStatsTotal.playerStats?.skatingData?.faceoffPercent ?? 0.0
                                        playerStatistics.penalties = playerStatsTotal.playerStats?.penaltyData?.penalties ?? 0
                                        playerStatistics.penaltyMinutes = playerStatsTotal.playerStats?.penaltyData?.penaltyMinutes ?? 0
                                        playerStatistics.wins = playerStatsTotal.playerStats?.goaltendingData?.wins ?? 0
                                        playerStatistics.losses = playerStatsTotal.playerStats?.goaltendingData?.losses ?? 0
                                        playerStatistics.overtimeWins = playerStatsTotal.playerStats?.goaltendingData?.overtimeWins ?? 0
                                        playerStatistics.overtimeLosses = playerStatsTotal.playerStats?.goaltendingData?.overtimeLosses ?? 0
                                        playerStatistics.goalsAgainst = playerStatsTotal.playerStats?.goaltendingData?.goalsAgainst ?? 0
                                        playerStatistics.shotsAgainst = playerStatsTotal.playerStats?.goaltendingData?.shotsAgainst ?? 0
                                        playerStatistics.saves = playerStatsTotal.playerStats?.goaltendingData?.saves ?? 0
                                        playerStatistics.goalsAgainstAverage = playerStatsTotal.playerStats?.goaltendingData?.goalsAgainstAverage ?? 0.0
                                        playerStatistics.savePercentage = playerStatsTotal.playerStats?.goaltendingData?.savePercentage ?? 0.0
                                        playerStatistics.shutouts = playerStatsTotal.playerStats?.goaltendingData?.shutouts ?? 0
                                        playerStatistics.gamesStarted = playerStatsTotal.playerStats?.goaltendingData?.gamesStarted ?? 0
                                        playerStatistics.creditForGame = playerStatsTotal.playerStats?.goaltendingData?.creditForGame ?? 0
                                        playerStatistics.minutesPlayed = playerStatsTotal.playerStats?.goaltendingData?.minutesPlayed ?? 0
                                        
                                        //  Save it to realm
                                        self.realm.create(PlayerStatistics.self, value: playerStatistics, update: true)
                                        
                                        //  Get the playerStatistics reference from the database
                                        if let realmPlayerStatistics = self.realm.object(ofType: PlayerStatistics.self, forPrimaryKey: playerId)
                                        {
                                            nhlPlayer?.playerStatisticsList.append(realmPlayerStatistics)
                                        }
                                    }
                                }
                            }
                            
                            print(Realm.Configuration.defaultConfiguration.fileURL!)
                            
                            print("Player stat data successfully populated!") 
                        }
                    }
                    catch
                    {
                        print("Error decoding JSON data in savePlayerStats method...")
                    }
                }
                else
                {
                    print("Error retrieving data in savePlayerStats method...\(err.debugDescription)")
                }
            }.resume()
        }
    }
    
    func savePlayerInjuries()
    {
        let playerResultList: Results<NHLPlayer> = databaseManager.retrieveAllPlayers()

        var playerDictionary = [Int:NHLPlayer]()

        //  Create a dictionary with id as the key
        for player in playerResultList
        {
            playerDictionary[player.id] = player
        }

        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/injuries.json")
        let session = URLSession.shared
        var request = URLRequest(url: url!)

        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")

        autoreleasepool
        {
            //  Get the JSON data with closure
            session.dataTask(with: request)
            {
                (data, response, err) in

                if err == nil
                {
                    do
                    {
                        let players = try JSONDecoder().decode(PlayerInjuries.self, from: data!)

                        let lastUpdatedOn = players.lastUpdatedOn

                        print("Value of lastUpdatedOn is \(lastUpdatedOn)")

                        print("Size of playerInfoList list is \(players.playerInfoList.count )")

                        print("Populating player injury data...")

                        DispatchQueue.main.async
                        {
                            try! self.realm.write
                            {
                                //  Delete any records in the injury table
                                self.realm.delete(self.realm.objects(NHLPlayerInjury.self))
                                
                                for playerInfo in players.playerInfoList
                                {
                                    let playerInjury = NHLPlayerInjury()
                                    let playerId = playerInfo.id
                                    let nhlPlayer = playerDictionary[playerId]

                                    playerInjury.id = playerId
                                    playerInjury.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                    playerInjury.teamId = playerInfo.currentTeamInfo?.id ?? 0
                                    playerInjury.teamAbbreviation = playerInfo.currentTeamInfo?.abbreviation ?? ""
                                    playerInjury.firstName = playerInfo.firstName
                                    playerInjury.lastName = playerInfo.lastName
                                    playerInjury.position = playerInfo.position ?? ""
                                    playerInjury.jerseyNumber = String(playerInfo.jerseyNumber ?? 0)
                                    playerInjury.injuryDescription = playerInfo.currentInjuryInfo?.description ?? ""
                                    playerInjury.playingProbablity = playerInfo.currentInjuryInfo?.playingProbability ?? ""

                                    //  Save it to realm
                                    self.realm.create(NHLPlayerInjury.self, value: playerInjury, update: true)

                                    //  Get the playerInjury reference from the database and save it to the player
                                    if let realmPlayerInjury = self.realm.object(ofType: NHLPlayerInjury.self, forPrimaryKey: playerId)
                                    {
                                        nhlPlayer?.playerInjuries.append(realmPlayerInjury)
                                    }
                                }
                            }
                        }

                        print(Realm.Configuration.defaultConfiguration.fileURL!)

                        print("Player injury data successfully populated!")
                    }
                    catch
                    {
                        print("Error decoding JSON data in savePlayerInjuries method...")
                    }
                }
                else
                {
                    print("Error retrieving data in savePlayerInjuries method...\(err.debugDescription)")
                }
            }.resume()
        }
    }
    
    func saveGameLogs()
    {
        let teamString = "ANA,ARI,BOS,BUF,CGY,CAR,CHI,COL,CBJ,DAL,DET,EDM,FLO,LAK,MIN,MTL,NSH,NJD,NYI,NYR,OTT,PHI,PIT,SJS,STL,TBL,TOR,VAN,VGK,WSH,WPJ"
        
        var gameLogDictionary = [Int:NHLGameLog]()
        
        var gameLogList = [NHLGameLog]()
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/team_gamelogs.json?team=\(teamString)")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")
        
        autoreleasepool
        {
            //  Get the JSON data with closure
            session.dataTask(with: request)
            {
                (data, response, err) in
                
                if err == nil
                {
                    do
                    {
                        let gameLog = try JSONDecoder().decode(GameLog.self, from: data!)
                        
                        let lastUpdatedOn = gameLog.lastUpdatedOn
                        
                        print("Value of lastUpdatedOn is \(lastUpdatedOn )")
                        
                        print("Size of gameLogDataList list is \(gameLog.gameLogDataList.count )")
                        
                        print("Populating game log data...")
                        
                        DispatchQueue.main.async
                        {
                            try! self.realm.write
                            {
                                for gameLogData in gameLog.gameLogDataList
                                {
                                    var nhlGameLog: NHLGameLog
                                
                                    var found = false
                                
                                    let gameId = gameLogData.game.id
                                    let teamAbbreviation = gameLogData.team.abbreviation
                                
                                    //  If game id is found in the dictionary, update that object,
                                    //  otherwise, create a new one to be inserted
                                    if gameLogDictionary.keys.contains(gameId)
                                    {
                                        found = true
                                        
                                        nhlGameLog = gameLogDictionary[gameId]!
                                    }
                                    else
                                    {
                                        nhlGameLog = NHLGameLog()
                                        nhlGameLog.id = gameId
                                    }
                                
                                    let timeString = gameLogData.game.startTime
                                
                                    nhlGameLog.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                    nhlGameLog.lastUpdatedOn = lastUpdatedOn
                                    nhlGameLog.date = TimeAndDateUtils.getDate(timeString)
                                    nhlGameLog.time = TimeAndDateUtils.getTime(timeString)
                                    nhlGameLog.playedStatus = PlayedStatusEnum.completed.rawValue
                                
                                    //  If the game log is the home team, update the home team information,
                                    //  otherwise, update the away team information
                                    if gameLogData.game.homeTeamAbbreviation == teamAbbreviation
                                    {
                                        nhlGameLog.homeTeamId = gameLogData.team.id
                                        nhlGameLog.homeTeamAbbreviation = gameLogData.game.homeTeamAbbreviation
                                        nhlGameLog.homeWins = gameLogData.stats.standings.wins
                                        nhlGameLog.homeLosses = gameLogData.stats.standings.losses
                                        nhlGameLog.homeOvertimeWins = gameLogData.stats.standings.overtimeWins
                                        nhlGameLog.homeOvertimeLosses = gameLogData.stats.standings.overtimeLosses
                                        nhlGameLog.homePoints = gameLogData.stats.standings.points
                                        nhlGameLog.homeFaceoffWins = gameLogData.stats.faceoffs.faceoffWins
                                        nhlGameLog.homeFaceoffLosses = gameLogData.stats.faceoffs.faceoffLosses
                                        nhlGameLog.homeFaceoffPercent = gameLogData.stats.faceoffs.faceoffPercent
                                        nhlGameLog.homePowerplays = gameLogData.stats.powerplay.powerplays
                                        nhlGameLog.homePowerplayGoals = gameLogData.stats.powerplay.powerplayGoals
                                        nhlGameLog.homePowerplayPercent = gameLogData.stats.powerplay.powerplayPercent
                                        nhlGameLog.homePenaltyKills = gameLogData.stats.powerplay.penaltyKills
                                        nhlGameLog.homePenaltyKillGoalsAllowed = gameLogData.stats.powerplay.penaltyKillGoalsAllowed
                                        nhlGameLog.homePenaltyKillPercent = gameLogData.stats.powerplay.penaltyKillPercent
                                        nhlGameLog.homeGoalsFor = gameLogData.stats.miscellaneous.goalsFor
                                        nhlGameLog.homeGoalsAgainst = gameLogData.stats.miscellaneous.goalsAgainst
                                        nhlGameLog.homeShots = gameLogData.stats.miscellaneous.shots
                                        nhlGameLog.homePenalties = gameLogData.stats.miscellaneous.penalties
                                        nhlGameLog.homePenaltyMinutes = gameLogData.stats.miscellaneous.penaltyMinutes
                                        nhlGameLog.homeHits = gameLogData.stats.miscellaneous.hits
                                    }
                                    else if gameLogData.game.awayTeamAbbreviation == teamAbbreviation
                                    {
                                        nhlGameLog.awayTeamId = gameLogData.team.id
                                        nhlGameLog.awayTeamAbbreviation = gameLogData.game.awayTeamAbbreviation
                                        nhlGameLog.awayWins = gameLogData.stats.standings.wins
                                        nhlGameLog.awayLosses = gameLogData.stats.standings.losses
                                        nhlGameLog.awayOvertimeWins = gameLogData.stats.standings.overtimeWins
                                        nhlGameLog.awayOvertimeLosses = gameLogData.stats.standings.overtimeLosses
                                        nhlGameLog.awayPoints = gameLogData.stats.standings.points
                                        nhlGameLog.awayFaceoffWins = gameLogData.stats.faceoffs.faceoffWins
                                        nhlGameLog.awayFaceoffLosses = gameLogData.stats.faceoffs.faceoffLosses
                                        nhlGameLog.awayFaceoffPercent = gameLogData.stats.faceoffs.faceoffPercent
                                        nhlGameLog.awayPowerplays = gameLogData.stats.powerplay.powerplays
                                        nhlGameLog.awayPowerplayGoals = gameLogData.stats.powerplay.powerplayGoals
                                        nhlGameLog.awayPowerplayPercent = gameLogData.stats.powerplay.powerplayPercent
                                        nhlGameLog.awayPenaltyKills = gameLogData.stats.powerplay.penaltyKills
                                        nhlGameLog.awayPenaltyKillGoalsAllowed = gameLogData.stats.powerplay.penaltyKillGoalsAllowed
                                        nhlGameLog.awayPenaltyKillPercent = gameLogData.stats.powerplay.penaltyKillPercent
                                        nhlGameLog.awayGoalsFor = gameLogData.stats.miscellaneous.goalsFor
                                        nhlGameLog.awayGoalsAgainst = gameLogData.stats.miscellaneous.goalsAgainst
                                        nhlGameLog.awayShots = gameLogData.stats.miscellaneous.shots
                                        nhlGameLog.awayPenalties = gameLogData.stats.miscellaneous.penalties
                                        nhlGameLog.awayPenaltyMinutes = gameLogData.stats.miscellaneous.penaltyMinutes
                                        nhlGameLog.awayHits = gameLogData.stats.miscellaneous.hits
                                    }
                                
                                    //  If object was not found, add the created object to the dictionary
                                    if !found
                                    {
                                        gameLogDictionary[gameId] = nhlGameLog
                                    }
                                
                                    //  Add the game log to the gameLogList
                                    gameLogList.append(nhlGameLog)
                                }
                                
                                //  Save the entire gameLogList to the database
                                self.realm.add(gameLogList, update: true)
                                
                                print("Game log data successfully populated for all teams!")
                            }
                        }
                        
                        print(Realm.Configuration.defaultConfiguration.fileURL!)
                    }
                    catch
                    {
                        print("Error decoding JSON data in saveGameLogs method for all teams...")
                    }
                }
                else
                {
                    print("Error retrieving data in saveGameLogs method...\(err.debugDescription)")
                }
            }.resume()
        }
    }
    
     // MARK: Update methods
    func updateSchedule()
    {
        let teamString = "ANA,ARI,BOS,BUF,CGY,CAR,CHI,COL,CBJ,DAL,DET,EDM,FLO,LAK,MIN,MTL,NSH,NJD,NYI,NYR,OTT,PHI,PIT,SJS,STL,TBL,TOR,VAN,VGK,WSH,WPJ"
        
        print("Last date played value is \(databaseManager.getLatestDatePlayed())")
        
        guard let dateCreated = TimeAndDateUtils.getDate(fromString: databaseManager.getLatestDatePlayed(), dateFormat: "EEEE, MMM dd, yyyy") else { return }
        
        let fromDate = dateCreated.adding(.day, value: 1)
        
        if(fromDate >= Date())
        {
            return
        }
        
        let dateRange = TimeAndDateUtils.createUpdateDateStringInWebServiceFormat(from: fromDate)
        
        print("URL string is: https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/games.json?team=\(teamString)&date=\(dateRange)")
        
        let scheduledGames = List<NHLSchedule>()
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/games.json?team=\(teamString)&date=\(dateRange)")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")
        
        autoreleasepool
        {
            //  Get the JSON data with closure
            session.dataTask(with: request)
            {
                (data, response, err) in
                
                if err == nil
                {
                    do
                    {
                        let seasonSchedule = try JSONDecoder().decode(SeasonSchedule.self, from: data!)
                        
                        let lastUpdatedOn = seasonSchedule.lastUpdatedOn
                        
                        print("Value of lastUpdatedOn is \(seasonSchedule.lastUpdatedOn)")
                        
                        print("Size of game list is \(seasonSchedule.gameList.count)")
                        
                        DispatchQueue.main.async
                        {
                            print("Populating game data...")
                            
                            for scheduledGame in seasonSchedule.gameList
                            {
                                let nhlSchedule = NHLSchedule()
                                
                                let startTime = scheduledGame.scheduleInfo.startTime
                                
                                nhlSchedule.id = scheduledGame.scheduleInfo.id
                                nhlSchedule.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                nhlSchedule.lastUpdatedOn = "\(TimeAndDateUtils.getDate(lastUpdatedOn)) at \(TimeAndDateUtils.getTime(lastUpdatedOn))"
                                nhlSchedule.date = TimeAndDateUtils.getDate(startTime)
                                nhlSchedule.time = TimeAndDateUtils.getTime(startTime)
                                nhlSchedule.homeTeam = scheduledGame.scheduleInfo.homeTeamInfo.abbreviation
                                nhlSchedule.awayTeam = scheduledGame.scheduleInfo.awayTeamInfo.abbreviation
                                nhlSchedule.homeScoreTotal = scheduledGame.scoreInfo.homeScoreTotal ?? 0
                                nhlSchedule.awayScoreTotal = scheduledGame.scoreInfo.awayScoreTotal ?? 0
                                nhlSchedule.homeShotsTotal = scheduledGame.scoreInfo.homeShotsTotal ?? 0
                                nhlSchedule.awayShotsTotal = scheduledGame.scoreInfo.awayShotsTotal ?? 0
                                nhlSchedule.playedStatus = scheduledGame.scheduleInfo.playedStatus
                                nhlSchedule.scheduleStatus = scheduledGame.scheduleInfo.scheduleStatus
                                nhlSchedule.numberOfPeriods = scheduledGame.scoreInfo.periodList?.count ?? 0
                                nhlSchedule.currentPeriod = scheduledGame.scoreInfo.currentPeriod ?? 0
                                nhlSchedule.currentTimeRemaining = scheduledGame.scoreInfo.currentPeriodSecondsRemaining ?? 0
                                
                                scheduledGames.append(nhlSchedule)
                            }
                            
                            do
                            {
                                print("Updating game data...")
                                
                                try self.realm.write
                                {
                                    self.realm.add(scheduledGames, update: true)
                                    
                                    print("Scheduled games have successfully been updated in the database!!")
                                }
                            }
                            catch
                            {
                                print("Error updating scheduled games in the database: \(error)")
                            }
                            
                            print(Realm.Configuration.defaultConfiguration.fileURL!)
                        }
                    }
                    catch
                    {
                        print("Error decoding JSON data in reloadSchedule method...")
                    }
                }
                else
                {
                    print("Error retrieving data in reloadSchedule method...\(err.debugDescription)")
                }
            }.resume()
        }
    }
    
    func updateGameLogs()
    {
        let teamString = "ANA,ARI,BOS,BUF,CGY,CAR,CHI,COL,CBJ,DAL,DET,EDM,FLO,LAK,MIN,MTL,NSH,NJD,NYI,NYR,OTT,PHI,PIT,SJS,STL,TBL,TOR,VAN,VGK,WSH,WPJ"
        
        print("Last date played value is \(databaseManager.getLatestDatePlayed())")
        
        guard let dateCreated = TimeAndDateUtils.getDate(fromString: databaseManager.getLatestDatePlayed(), dateFormat: "EEEE, MMM dd, yyyy") else { return }
        
        let fromDate = dateCreated.adding(.day, value: 1)
        
        if(fromDate >= Date())
        {
            return
        }
        
        let dateRange = TimeAndDateUtils.createUpdateDateStringInWebServiceFormat(from: fromDate)
        
        var gameLogDictionary = [Int:NHLGameLog]()
        
        var gameLogList = [NHLGameLog]()
        
        print("URL string is: https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/team_gamelogs.json?team=\(teamString)&date=\(dateRange)")
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/team_gamelogs.json?team=\(teamString)&date=\(dateRange)")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + userId.toBase64()!, forHTTPHeaderField: "Authorization")
        
        autoreleasepool
        {
            //  Get the JSON data with closure
            session.dataTask(with: request)
            {
                (data, response, err) in
                
                if err == nil
                {
                    do
                    {
                        let gameLog = try JSONDecoder().decode(GameLog.self, from: data!)
                        
                        let lastUpdatedOn = gameLog.lastUpdatedOn
                        
                        print("Value of lastUpdatedOn is \(lastUpdatedOn )")
                        
                        print("Size of gameLogDataList list is \(gameLog.gameLogDataList.count )")
                        
                        print("Reloading game log data...")
                        
                        DispatchQueue.main.async
                        {
                            try! self.realm.write
                            {
                                for gameLogData in gameLog.gameLogDataList
                                {
                                    var nhlGameLog: NHLGameLog
                                    
                                    var found = false
                                    
                                    let gameId = gameLogData.game.id
                                    let teamAbbreviation = gameLogData.team.abbreviation
                                    
                                    //  If game id is found in the dictionary, update that object,
                                    //  otherwise, create a new one to be inserted
                                    if gameLogDictionary.keys.contains(gameId)
                                    {
                                        found = true
                                        
                                        nhlGameLog = gameLogDictionary[gameId]!
                                    }
                                    else
                                    {
                                        nhlGameLog = NHLGameLog()
                                        nhlGameLog.id = gameId
                                    }
                                    
                                    let timeString = gameLogData.game.startTime
                                    
                                    nhlGameLog.dateCreated = TimeAndDateUtils.getCurrentDateAsString()
                                    nhlGameLog.lastUpdatedOn = lastUpdatedOn
                                    nhlGameLog.date = TimeAndDateUtils.getDate(timeString)
                                    nhlGameLog.time = TimeAndDateUtils.getTime(timeString)
                                    nhlGameLog.playedStatus = PlayedStatusEnum.completed.rawValue
                                    
                                    //  If the game log is the home team, update the home team information,
                                    //  otherwise, update the away team information
                                    if gameLogData.game.homeTeamAbbreviation == teamAbbreviation
                                    {
                                        nhlGameLog.homeTeamId = gameLogData.team.id
                                        nhlGameLog.homeTeamAbbreviation = gameLogData.game.homeTeamAbbreviation
                                        nhlGameLog.homeWins = gameLogData.stats.standings.wins
                                        nhlGameLog.homeLosses = gameLogData.stats.standings.losses
                                        nhlGameLog.homeOvertimeWins = gameLogData.stats.standings.overtimeWins
                                        nhlGameLog.homeOvertimeLosses = gameLogData.stats.standings.overtimeLosses
                                        nhlGameLog.homePoints = gameLogData.stats.standings.points
                                        nhlGameLog.homeFaceoffWins = gameLogData.stats.faceoffs.faceoffWins
                                        nhlGameLog.homeFaceoffLosses = gameLogData.stats.faceoffs.faceoffLosses
                                        nhlGameLog.homeFaceoffPercent = gameLogData.stats.faceoffs.faceoffPercent
                                        nhlGameLog.homePowerplays = gameLogData.stats.powerplay.powerplays
                                        nhlGameLog.homePowerplayGoals = gameLogData.stats.powerplay.powerplayGoals
                                        nhlGameLog.homePowerplayPercent = gameLogData.stats.powerplay.powerplayPercent
                                        nhlGameLog.homePenaltyKills = gameLogData.stats.powerplay.penaltyKills
                                        nhlGameLog.homePenaltyKillGoalsAllowed = gameLogData.stats.powerplay.penaltyKillGoalsAllowed
                                        nhlGameLog.homePenaltyKillPercent = gameLogData.stats.powerplay.penaltyKillPercent
                                        nhlGameLog.homeGoalsFor = gameLogData.stats.miscellaneous.goalsFor
                                        nhlGameLog.homeGoalsAgainst = gameLogData.stats.miscellaneous.goalsAgainst
                                        nhlGameLog.homeShots = gameLogData.stats.miscellaneous.shots
                                        nhlGameLog.homePenalties = gameLogData.stats.miscellaneous.penalties
                                        nhlGameLog.homePenaltyMinutes = gameLogData.stats.miscellaneous.penaltyMinutes
                                        nhlGameLog.homeHits = gameLogData.stats.miscellaneous.hits
                                    }
                                    else if gameLogData.game.awayTeamAbbreviation == teamAbbreviation
                                    {
                                        nhlGameLog.awayTeamId = gameLogData.team.id
                                        nhlGameLog.awayTeamAbbreviation = gameLogData.game.awayTeamAbbreviation
                                        nhlGameLog.awayWins = gameLogData.stats.standings.wins
                                        nhlGameLog.awayLosses = gameLogData.stats.standings.losses
                                        nhlGameLog.awayOvertimeWins = gameLogData.stats.standings.overtimeWins
                                        nhlGameLog.awayOvertimeLosses = gameLogData.stats.standings.overtimeLosses
                                        nhlGameLog.awayPoints = gameLogData.stats.standings.points
                                        nhlGameLog.awayFaceoffWins = gameLogData.stats.faceoffs.faceoffWins
                                        nhlGameLog.awayFaceoffLosses = gameLogData.stats.faceoffs.faceoffLosses
                                        nhlGameLog.awayFaceoffPercent = gameLogData.stats.faceoffs.faceoffPercent
                                        nhlGameLog.awayPowerplays = gameLogData.stats.powerplay.powerplays
                                        nhlGameLog.awayPowerplayGoals = gameLogData.stats.powerplay.powerplayGoals
                                        nhlGameLog.awayPowerplayPercent = gameLogData.stats.powerplay.powerplayPercent
                                        nhlGameLog.awayPenaltyKills = gameLogData.stats.powerplay.penaltyKills
                                        nhlGameLog.awayPenaltyKillGoalsAllowed = gameLogData.stats.powerplay.penaltyKillGoalsAllowed
                                        nhlGameLog.awayPenaltyKillPercent = gameLogData.stats.powerplay.penaltyKillPercent
                                        nhlGameLog.awayGoalsFor = gameLogData.stats.miscellaneous.goalsFor
                                        nhlGameLog.awayGoalsAgainst = gameLogData.stats.miscellaneous.goalsAgainst
                                        nhlGameLog.awayShots = gameLogData.stats.miscellaneous.shots
                                        nhlGameLog.awayPenalties = gameLogData.stats.miscellaneous.penalties
                                        nhlGameLog.awayPenaltyMinutes = gameLogData.stats.miscellaneous.penaltyMinutes
                                        nhlGameLog.awayHits = gameLogData.stats.miscellaneous.hits
                                    }
                                    
                                    //  If object was not found, add the created object to the dictionary
                                    if !found
                                    {
                                        gameLogDictionary[gameId] = nhlGameLog
                                    }
                                    
                                    //  Add the game log to the gameLogList
                                    gameLogList.append(nhlGameLog)
                                }
                                
                                //  Save the entire gameLogList to the database
                                self.realm.add(gameLogList, update: true)
                                
                                print("Game log data successfully reloaded for all teams!")
                            }
                        }
                        
                        print(Realm.Configuration.defaultConfiguration.fileURL!)
                    }
                    catch
                    {
                        print("Error decoding JSON data in reloadGameLogs method for all teams...")
                    }
                }
                else
                {
                    print("Error retrieving data in reloadGameLogs method...\(err.debugDescription)")
                }
            }.resume()
        }
    }
}



