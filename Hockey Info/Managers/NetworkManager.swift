//
//  NetworkManager.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/20/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift
import SwiftyJSON
import SwifterSwift
import Alamofire
import Kingfisher
import SVProgressHUD

class NetworkManager
{
    let today = Date()
    
    let shortDateFormatter = DateFormatter()
    let fullDateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let dateStringFormatter = DateFormatter()
    
    let userId = "6faa8a21-d219-433a-914b-fcd2d4:MYSPORTSFEEDS"
    
    //  Create a new Realm database
    let realm = try! Realm()
    
    //  Create the saveRosters method
    func saveRosters()
    {
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        
        let dateString = fullDateFormatter.string(from: today)
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
                                
                                nhlPlayer.dateCreated = dateString
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
                                    self.realm.add(playerList)
                                    
                                    print("Roster players have successfully been added to the database!!")
                                }
                            }
                            catch
                            {
                                print("Error saving roster players to the database: \(error)")
                            }
                            
                            print(Realm.Configuration.defaultConfiguration.fileURL!)
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
    
    //  Create the updateRostersForDate method
    func updateRostersForDate(_ date: Date)
    {
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        shortDateFormatter.dateFormat = "yyyyMMdd"
        
        let dateString = fullDateFormatter.string(from: date)
        let scheduleDate = shortDateFormatter.string(from: date)
        
        let playerList = List<NHLPlayer>()
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/players.json?rosterstatus=assigned-to-roster?date=\(scheduleDate)")
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
                            for playerInfo in rosterPlayers.playerInfoList
                            {
                                let nhlPlayer = NHLPlayer()
                                
                                nhlPlayer.dateCreated = dateString
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
                                try self.realm.write
                                {
                                    self.realm.add(playerList, update: true)
                                    
                                    print("Roster players have successfully been updated in the database!!")
                                }
                            }
                            catch
                            {
                                print("Error updating roster players to the database: \(error)")
                            }
                            
                            print(Realm.Configuration.defaultConfiguration.fileURL!)
                        }
                    }
                    catch
                    {
                        print("Error decoding JSON in updateRostersForDate method...")
                    }
                }
                else
                {
                    print("Error retrieving data in updateRostersForDate method...\(err.debugDescription)")
                }
            }.resume()
        }
    }
    
    //  Create the saveSchedule method
    func saveSchedule()
    {
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        
        let dateString = fullDateFormatter.string(from: today)
        
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
                                nhlSchedule.dateCreated = dateString
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
    
    //  Create the updateScheduleForDate method
    func updateScheduleForDate(_ date :Date)
    {
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        shortDateFormatter.dateFormat = "yyyyMMdd"
        
        let dateString = fullDateFormatter.string(from: date)
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
                                nhlSchedule.dateCreated = dateString
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
    

    
    //  Create the updateStandingsForDate method
    func updateStandingsForDate(_ date :Date)
    {
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        shortDateFormatter.dateFormat = "yyyyMMdd"
        
        let dateString = fullDateFormatter.string(from: date)
        let scheduleDate = shortDateFormatter.string(from: date)
        
        let teamStandingsList = List<TeamStandings>()
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/standings.json?date=\(scheduleDate)")
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
                        
                        DispatchQueue.main.async
                        {
                            for teamStandingsData in nhlStandings.teamList
                            {
                                let teamStandings = TeamStandings()
                                
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
                                teamStandings.dateCreated = dateString
                                
                                teamStandingsList.append(teamStandings)
                            }
                            
                            do
                            {
                                try self.realm.write
                                {
                                    self.realm.add(teamStandingsList, update: true)
                                    
                                    print("Team standings have successfully been updated in the database for \(scheduleDate)!!")
                                }
                            }
                            catch
                            {
                                print("Error updating team standings to the database: \(error)")
                            }
                            
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
    
    //  Create the saveStandings method
    func saveStandings()
    {
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        
        let dateString = fullDateFormatter.string(from: today)
        
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
                                    teamStandings.dateCreated = dateString
                                    
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
                                    teamStatistics.dateCreated = dateString
                                    
                                    //  Populate the NHLTeam table
                                    nhlTeam.dateCreated = dateString
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
                                        self.realm.add(teamList)
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
                                        self.realm.add(teamStatisticsList)
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
                                        self.realm.add(teamStandingsList)
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
    
    //  Create the updateStatsForDate method
    func updateStatsForDate(_ date :Date)
    {
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        shortDateFormatter.dateFormat = "yyyyMMdd"
        
        let dateString = fullDateFormatter.string(from: date)
        let scheduleDate = shortDateFormatter.string(from: date)
        
        let teamStatisticsList = List<TeamStatistics>()
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/standings.json?date=\(scheduleDate)")
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
                        
                        DispatchQueue.main.async
                            {
                                for teamStandingsData in nhlStandings.teamList
                                {
                                    let teamStatistics = TeamStatistics()
                                    
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
                                    teamStatistics.dateCreated = dateString
                                    
                                    teamStatisticsList.append(teamStatistics)
                                }
                                
                                do
                                {
                                    try self.realm.write
                                    {
                                        self.realm.add(teamStatisticsList, update: true)
                                        
                                        print("Team statistics have successfully been updated in the database for \(scheduleDate)!!")
                                    }
                                }
                                catch
                                {
                                    print("Error updating team statistics to the database: \(error)")
                                }
                                
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
}


