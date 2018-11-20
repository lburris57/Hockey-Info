//
//  ViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/14/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import SwifterSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var scoreView: UITableView!
    
    let today = Date()
    
    let shortDateFormatter = DateFormatter()
    let fullDateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let dateStringFormatter = DateFormatter()
    
    var timesRemaining = ["12:42", "09:47"]
    var visitingTeamNames = ["BLUE JACKETS", "OILERS"]
    var visitingTeamRecords = ["44-17-10", "47-14-10"]
    var homeTeamNames = ["CAPITALS", "FLAMES"]
    var homeTeamRecords = ["47-14-10", "44-17-10"]
    var visitingTeamScores = ["2", "1"]
    var homeTeamScores = ["5", "2"]
    var periods = ["3rd", "2nd"]
    
    var game = Game()
    var homeTeam = Team()
    var awayTeam = Team()
    var gameScore = GameScore()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        fullDateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        timeFormatter.dateFormat = "hh:mm a"
        shortDateFormatter.dateFormat = "yyyyMMdd"
        
        scoreView.dataSource = self
        scoreView.delegate = self
        
        let nib = UINib(nibName: "ScoreCell", bundle: nil)
        scoreView.register(nib, forCellReuseIdentifier: "scoreCell")
        
        downloadGameData()
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    // MARK: - Scores Table Header Code
    
    /// Creates the header title for the scores table view
    ///
    /// - Parameters:
    ///   - tableView: scores table view
    ///   - section: the section header
    /// - Returns: String representation of the section header text
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Scores for " + fullDateFormatter.string(from: today) + " at " + timeFormatter.string(from: today)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.adjustsFontSizeToFitWidth = true
        
        view.tintColor = UIColor.black
    }

    // MARK: - Scores Table Cell Code
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1 //timesRemaining.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as! ScoreCell
        
        scoreView.rowHeight = CGFloat(130.0)
        
        print("In numberOfRowsInSection method...")
        
        cell.timeRemaining.text = timesRemaining[indexPath.row] + " remaining"
        cell.visitingTeamName.text = game.awayTeam?.name
        cell.visitingTeamRecord.text = visitingTeamRecords[indexPath.row]
        cell.homeTeamName.text = game.homeTeam?.name
        cell.homeTeamRecord.text = homeTeamRecords[indexPath.row]
        cell.visitingTeamScore.text = "\(game.gameScore?.awayScore ?? 0)"
        cell.homeTeamScore.text = "\(game.gameScore?.homeScore ?? 0)"
        cell.period.text = game.gameScore?.currentPeriod
        
        /*cell.timeRemaining.text = timesRemaining[indexPath.row] + " remaining"
        cell.visitingTeamName.text = visitingTeamNames[indexPath.row]
        cell.visitingTeamRecord.text = visitingTeamRecords[indexPath.row]
        cell.homeTeamName.text = homeTeamNames[indexPath.row]
        cell.homeTeamRecord.text = homeTeamRecords[indexPath.row]
        cell.visitingTeamScore.text = visitingTeamScores[indexPath.row]
        cell.homeTeamScore.text = homeTeamScores[indexPath.row]
        cell.period.text = periods[indexPath.row]*/
        
        return cell
    }
    
    // MARK: - Network code
    func downloadGameData()
    {
        print("In downloadGameData method...")
        
        print("https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/date/" + shortDateFormatter.string(from: today) + "/games.json")
        //https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/date/20181021/games.json
        
        Alamofire.request(
            
            "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/date/20181118/games.json",
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
                    
                        let homeTeamString = TeamNames.getTeamName(json["games"][0]["schedule"]["homeTeam"]["abbreviation"].stringValue)
                        let awayTeamString = TeamNames.getTeamName(json["games"][0]["schedule"]["awayTeam"]["abbreviation"].stringValue)
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
                        self.gameScore.homeScore = UInt(homeScoreTotal)
                        self.gameScore.awayScore = UInt(awayScoreTotal)
                        self.homeTeam.name = homeTeamString
                        self.awayTeam.name = awayTeamString
                        self.game.gameScore = self.gameScore
                        self.game.homeTeam = self.homeTeam
                        self.game.awayTeam = self.awayTeam
                        self.game.date = trimmedString
                    
                        print("Current period value is: " + self.gameScore.currentPeriod! )
                    
                    case .failure(let error):
                        
                        print(error)
                }
        }
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
