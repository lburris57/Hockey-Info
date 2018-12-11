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
                    
                    print("Value of lastUpdatedOn is \(nhlStandings.lastUpdatedOn)")
                    
                    //for teamStatReference in seasonTeamStats.references.teamStatReferences
                    for standingsCategory in nhlStandings.references.standingsCategories
                    {
                        print("-----------------------------------------")
                        print("Category is \(standingsCategory.category)")
                        print("Type is \(standingsCategory.type)")
                        print("Description is \(standingsCategory.description)")
                        print("Abbreviation is \(standingsCategory.abbreviation)")
                        print("Full Name is \(standingsCategory.fullName)")
                    }
                }
                catch
                {
                    print("Error retrieving data...\(err.debugDescription)")
                }
            }
        }.resume()
    }
    
    //  Create the retrieveScores method
    // MARK: - Network code
    func retrieveScores(_ viewController: MainMenuViewController, _ date: String)
    {
        shortDateFormatter.dateFormat = "yyyyMMdd"
        
        //print("In retrieveScores method...")
        
        //print("https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/date/" + shortDateFormatter.string(from: today) + "/games.json")
        //https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/date/20181008/games.json
        print("lburris57:'MYSPORTSFEEDS'".toBase64()!)
        
        SVProgressHUD.show()
        
        Alamofire.request(
            "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/date/" + shortDateFormatter.string(from: today) + "/games.json",
            headers: ["Authorization" : "Basic " + "lburris57:MYSPORTSFEEDS".toBase64()!])
            .responseJSON
            { (response) in
                switch response.result
                {
                    case .success:
                    
                    self.games.removeAll()
                        
                    //  Create the JSON object and populate it
                    let json = JSON(response.result.value!)
                    
                    //print("Original JSON in retrieveScores method is:\n \(json)")
                    
                    //  Get the last updated on value
                    let lastUpdatedOn = json["lastUpdatedOn"].stringValue
                    
                    //print("Value of lastUpdatedOn is: \(lastUpdatedOn)")
                    
                    let trimmedString = lastUpdatedOn.slicing(from: 0, length: 10)
                    
                    //print("Value of trimmed string is: " + trimmedString!)
                    
                    let numberOfGames = json["games"].arrayValue.count
                    
                    print("Number of games in retrieveScores method in network manager is \(numberOfGames)")
                    
                    for i in numberOfGames
                    {
                        print("Performing loop \(i)...")
                        
                        let homeTeamString = TeamManager.getTeamName(json["games"][i]["schedule"]["homeTeam"]["abbreviation"].stringValue)
                        let awayTeamString = TeamManager.getTeamName(json["games"][i]["schedule"]["awayTeam"]["abbreviation"].stringValue)
                        let playedStatus = json["games"][i]["schedule"]["playedStatus"].stringValue
                        let currentPeriod = json["games"][i]["score"]["currentPeriod"].stringValue
                        let homeScoreTotal = json["games"][i]["score"]["homeScoreTotal"].stringValue
                        let awayScoreTotal = json["games"][i]["score"]["awayScoreTotal"].stringValue
                        //let timeRemaining = json["games"][i]["score"]["currentPeriodSecondsRemaining"]
                        
                        let timeRemaining = 847
                        
                        let currentTimeRemainingString = GameScore.retrieveCurrentTimeRemainingString(timeRemaining)
                        
                        let numberOfPeriods = json["games"][i]["score"]["periods"].arrayValue.count
                        
                        print("Value of currentPeriod is \(currentPeriod)")
                        
                        print("Value of currentTimeRemaining is \(currentTimeRemainingString)")
                        
                        print("Number of periods is \(numberOfPeriods)")
                        
                        print("Played status value is: " + playedStatus)
                        
                        print("Value of currentPeriod1 is \(currentPeriod)")
                        
                        print("Value of played status enum is \(PlayedStatusEnum.unplayed.rawValue)")
                        
                        if(currentPeriod == "" && playedStatus != PlayedStatusEnum.unplayed.rawValue)
                        {
                            //currentPeriod = "F"
                        }
                        
                        print("Value of currentPeriod2 is \(currentPeriod)")
                        
                        let startTme = json["games"][i]["schedule"]["startTime"].stringValue
                        
                        print("Start time value is: " + startTme)
                        
                        let dateString = TimeAndDateUtils.getDateAndTime(startTme)
                        
                        print("Date string value is + \(dateString)")
                        
                        var timeString = dateString.1
                            
                        if timeString.hasPrefix("0")
                        {
                            timeString = timeString.slicing(from: 1, length: timeString.count - 1) ?? ""
                        }
                        
                        print("Value of timeRemaining in NetworkManager is \(timeRemaining)")
                        
                        self.gameScore.currentPeriod = currentPeriod
                        self.gameScore.homeScore = UInt(homeScoreTotal) ?? 0
                        self.gameScore.awayScore = UInt(awayScoreTotal) ?? 0
                        self.homeTeam.abbreviation = json["games"][i]["schedule"]["homeTeam"]["abbreviation"].stringValue
                        self.awayTeam.abbreviation = json["games"][i]["schedule"]["awayTeam"]["abbreviation"].stringValue
                        self.homeTeam.name = homeTeamString
                        self.awayTeam.name = awayTeamString
                        self.game.gameScore = self.gameScore
                        self.game.homeTeam = self.homeTeam
                        self.game.awayTeam = self.awayTeam
                        self.gameScore.currentPeriodSecondsRemainingString = currentTimeRemainingString
                        self.gameScore.currentPeriodSecondsRemaining = timeRemaining
                        self.game.date = trimmedString!
                        self.game.time = timeString
                        
                        self.games.append(self.game)
                    }
                    
                    //print("Number of games in retrieveScores method in network manager is: \(self.games.count)")
                    
                    DispatchQueue.main.async
                    {
                        viewController.performSegue(withIdentifier: "showScores", sender: self.games)
                    }
                    
                    SVProgressHUD.dismiss()
                    
                    case .failure(let error):
                    
                    print(error)
                }
            }
        }
    
     
    
    //  Create the retrieveTeamRoster method
    func retrieveTeamRoster(_ id: String)
    {
//        let playerResults = realm.objects(Player.self)
//
//        do
//        {
//            try self.realm.write
//            {
//                self.realm.delete(playerResults)
//
//                print("Players have been deleted from the database!!")
//            }
//        }
//        catch
//        {
//            print("Error deleting players from the database: \(error)")
//        }
        
        let playerList = List<NHLPlayer>()
        
        let teamResult = realm.objects(NHLTeam.self).filter("id == '5'").first
        
        let team = NHLTeam()
        
        team.dateCreated = (teamResult?.dateCreated)!
        team.abbreviation = (teamResult?.abbreviation)!
        team.city = (teamResult?.city)!
        team.id = (teamResult?.id)!
        
        Alamofire.request(
            "https://api.mysportsfeeds.com/v2.0/pull/nhl/players.json?team=5&rosterstatus=assigned-to-roster",
            headers: ["Authorization" : "Basic " + "lburris57:MYSPORTSFEEDS".toBase64()!])
            .responseJSON
            { (response) in
                switch response.result
                {
                    case .success:
                    
                    //  Create the JSON object and populate it
                    let json = JSON(response.result.value!)
                    
                     let numberOfPlayers = json["players"].arrayValue.count
                    
                    print("Original JSON in retrieveTeamRoster method is:\n \(json)")
                    
                    for i in numberOfPlayers
                    {
                        let player = NHLPlayer()
                        
                        player.id = json["players"][i]["player"]["id"].stringValue
                        player.firstName = json["players"][i]["player"]["firstName"].stringValue
                        player.lastName = json["players"][i]["player"]["lastName"].stringValue
                        player.position = json["players"][i]["player"]["primaryPosition"].stringValue
                        player.jerseyNumber = json["players"][i]["player"]["jerseyNumber"].stringValue
                        player.height = json["players"][i]["player"]["height"].stringValue
                        player.weight = json["players"][i]["player"]["weight"].stringValue
                        player.birthDate = json["players"][i]["player"]["birthDate"].stringValue
                        player.age = json["players"][i]["player"]["age"].stringValue
                        player.birthCity = json["players"][i]["player"]["birthCity"].stringValue
                        player.birthCountry = json["players"][i]["player"]["birthCountry"].stringValue
                        player.imageURL = json["players"][i]["player"]["officialImageSrc"].stringValue
                        player.shoots = json["players"][i]["player"]["handedness"]["shoots"].stringValue
                        //player.dateCreated = Date()
                        
                        team.players.append(player)
                        
                        playerList.append(player)
                    }
                    
                    do
                    {
                        try self.realm.write
                        {
                            self.realm.add(playerList)
        
                            print("Players have been added to the database!!")
                        }
                    }
                    catch
                    {
                        print("Error saving players to the database: \(error)")
                    }
                    
                    SVProgressHUD.dismiss()
                    
                    case .failure(let error):
                    
                    print(error)
                }
        }
    }
    
    
    
}


