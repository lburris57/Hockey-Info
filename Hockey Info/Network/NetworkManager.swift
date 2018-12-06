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
    let realm = try! Realm()
    
    let today = Date()
    
    let shortDateFormatter = DateFormatter()
    let fullDateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let dateStringFormatter = DateFormatter()
    
    var games = [Game]()
    
    //fullDateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
    //timeFormatter.dateFormat = "hh:mm a"
    
    var game = Game()
    var homeTeam = TeamInfo()
    var awayTeam = TeamInfo()
    var gameScore = GameScore()
    
    //  Create a new Realm database
    
    //  Create the saveRosters method
    
    //  Create the saveSchedule method
    
    //  Create the retrieveStandings method
    
    //  Create the retrieveScores method
    // MARK: - Network code
    func retrieveScores(_ viewController: MainTableViewController)
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
                        var currentPeriod = json["games"][i]["score"]["currentPeriod"].stringValue
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
                        
                        let dateString = self.getDateAndTime(startTme)
                        
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
    
     //  Create the retrievePlayerInfo method
    
    //  Create the retrieveTeamRoster method
    func retrieveTeamRoster()
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
        
        team.dateCreated = teamResult?.dateCreated
        team.abbreviation = (teamResult?.abbreviation)!
        team.cityName = (teamResult?.cityName)!
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
                        player.dateCreated = Date()
                        
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
    
    //  Create the displaySchedule method
    
    
    
    func getDateAndTime(_ timestamp: String) -> (String, String)
    {
        let formatter = DateFormatter()
        
        var date = Date()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if TimeZone.current.isDaylightSavingTime()
        {
        date = (formatter.date(from: timestamp)?.addingTimeInterval(-(9*60*60)))!
        }
        else
        {
        date = (formatter.date(from: timestamp)?.addingTimeInterval(-(10*60*60)))!
        }
        
        print("Date is: \(date.toFormat("EEEE, MMM dd, yyyy"))")
        print("Time is: \(date.toFormat("hh:mm a"))")
        
        return (date.toFormat("EEEE, MMM dd, yyyy"), date.toFormat("hh:mm a"))
    }
}

extension String
{
    func fromBase64() -> String?
    {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else
        {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String?
    {
        guard let data = self.data(using: String.Encoding.utf8) else
        {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}

extension Int: Sequence
{
    public func makeIterator() -> CountableRange<Int>.Iterator
    {
        return (0..<self).makeIterator()
    }
}
