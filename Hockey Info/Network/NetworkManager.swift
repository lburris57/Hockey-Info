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
    
    var games = [Game]()
    
    var game = Game()
    var homeTeam = TeamInfo()
    var awayTeam = TeamInfo()
    var gameScore = GameScore()
    
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
        
        request.addValue("Basic " + "lburris57:MYSPORTSFEEDS".toBase64()!, forHTTPHeaderField: "Authorization")
        
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
                            
                            print("Value of official image source is \(rosterPlayers.playerInfoList[0].player.officialImageSource?.absoluteString ?? "WTF???")")
                            
                            for playerInfo in rosterPlayers.playerInfoList
                            {
                                let nhlPlayer = NHLPlayer()
                                
                                nhlPlayer.dateCreated = dateString
                                nhlPlayer.id = String(playerInfo.player.id)
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
                                nhlPlayer.teamId = String(playerInfo.currentTeamInfo?.id ?? 0)
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
        
        request.addValue("Basic " + "lburris57:MYSPORTSFEEDS".toBase64()!, forHTTPHeaderField: "Authorization")
        
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
        
                                nhlSchedule.id = String(scheduledGame.scheduleInfo.id)
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
                                print("Error saving teams to the database: \(error)")
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
    
    //  Create the saveStandings method
    func saveStandings()
    {
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        
        let dateString = fullDateFormatter.string(from: today)
        
        let teamStandingsList = List<TeamStandings>()
        let teamList = List<NHLTeam>()
        
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/standings.json")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + "lburris57:MYSPORTSFEEDS".toBase64()!, forHTTPHeaderField: "Authorization")
        
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
                                    let nhlTeam = NHLTeam()
                                    
                                    teamStandings.id = String(teamStandingsData.teamInformation.id)
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
                                    
                                    nhlTeam.dateCreated = dateString
                                    nhlTeam.id = String(teamStandingsData.teamInformation.id)
                                    nhlTeam.abbreviation = teamStandingsData.teamInformation.abbreviation
                                    nhlTeam.city = teamStandingsData.teamInformation.city
                                    nhlTeam.name = teamStandingsData.teamInformation.name
                                    
                                    teamStandingsList.append(teamStandings)
                                    teamList.append(nhlTeam)
                                }
                                
                                do
                                {
                                    print("Saving team data...")
                                    
                                    try self.realm.write
                                    {
                                        self.realm.add(teamList)
                                        
                                        print("Teams have successfully been added to the database!!")
                                    }
                                }
                                catch
                                {
                                    print("Error saving teams to the database: \(error)")
                                }
                                
                                do
                                {
                                    print("Saving team standings data...")
                                    
                                    try self.realm.write
                                    {
                                        self.realm.add(teamStandingsList)
                                        
                                        print("Team standings have successfully been added to the database!!")
                                    }
                                }
                                catch
                                {
                                    print("Error saving team standings to the database: \(error)")
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
    
    //  Create the saveStats method
    func saveStats()
    {
        //  Set the URL
        let url = URL(string: "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/standings.json")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        
        request.addValue("Basic " + "lburris57:MYSPORTSFEEDS".toBase64()!, forHTTPHeaderField: "Authorization")
        
        //  Get the JSON data with closure
        session.dataTask(with: request)
        {
            (data, response, err) in
            
            if err == nil
            {
                do
                {
                    let nhlStandings = try JSONDecoder().decode(NHLStandings.self, from: data!)
                    
                    for standingsCategory in nhlStandings.references.standingsCategories
                    {

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


