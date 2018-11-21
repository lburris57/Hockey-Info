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
    func retrieveScores(_ scoreView: UITableView) -> [Game]?
    {
        var games = [Game]()
        
        shortDateFormatter.dateFormat = "yyyyMMdd"
        
        print("In retrieveScores method...")
        
        //print("https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/date/" + shortDateFormatter.string(from: today) + "/games.json")
        print("lburris57:'MYSPORTSFEEDS'".toBase64()!)
        
        SVProgressHUD.show()
        
        Alamofire.request(
            
            "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/date/20181119/games.json",
            headers: ["Authorization" : "Basic " + "lburris57:MYSPORTSFEEDS".toBase64()!])
            .responseJSON
            { (response) in
                switch response.result
                {
                case .success:
                    
                    //  Create the JSON object and populate it
                    let json = JSON(response.result.value!)
                    
                    print("Original JSON is:\n \(json)")
                    
                    //  Get the last updated on value
                    let lastUpdatedOn = json["lastUpdatedOn"].stringValue
                    
                    print("Value of lastUpdatedOn is: \(lastUpdatedOn)")
                    
                    let trimmedString = lastUpdatedOn.slicing(from: 0, length: 10)
                    
                    print("Value of trimmed string is: " + trimmedString!)
                    
                    let convertedDate = trimmedString!.date
                    
                    print("Value of convertedDate is: \(convertedDate!)")
                    
                    let homeTeamString = TeamManager.getTeamName(json["games"][0]["schedule"]["homeTeam"]["abbreviation"].stringValue)
                    let awayTeamString = TeamManager.getTeamName(json["games"][0]["schedule"]["awayTeam"]["abbreviation"].stringValue)
                    let playedStatus = json["games"][0]["schedule"]["playedStatus"].stringValue
                    var currentPeriod = json["games"][0]["score"]["currentPeriod"].stringValue
                    let homeScoreTotal = json["games"][0]["score"]["homeScoreTotal"].stringValue
                    let awayScoreTotal = json["games"][0]["score"]["awayScoreTotal"].stringValue
                    
                    if(currentPeriod == "")
                    {
                        currentPeriod = "F"
                    }
                    
                    print("Home team value is: " + homeTeamString)
                    print("Away team value is: " + awayTeamString)
                    print("Played status value is: " + playedStatus)
                    print("Current period value is: " + currentPeriod)
                    print("homeScoreTotal value is: " + homeScoreTotal)
                    print("awayScoreTotal value is: " + awayScoreTotal)
                    
                    self.gameScore.currentPeriod = currentPeriod
                    self.gameScore.homeScore = UInt(homeScoreTotal) ?? 0
                    self.gameScore.awayScore = UInt(awayScoreTotal) ?? 0
                    self.homeTeam.name = homeTeamString
                    self.awayTeam.name = awayTeamString
                    self.game.gameScore = self.gameScore
                    self.game.homeTeam = self.homeTeam
                    self.game.awayTeam = self.awayTeam
                    self.game.date = trimmedString!
                    
                    print("Current period value is: " + self.gameScore.currentPeriod)
                    
                    games.append(self.game)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        
        print("Leaving retrieveScores method...")
        print("Number of games is: \(games.count)")
        
        SVProgressHUD.dismiss()
        
        return games
        
        }
    
    //  Create the retrieveTeamRoster method
    
    //  Create the retrievePlayerInfo method
    
    //  Create the displaySchedule method
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
