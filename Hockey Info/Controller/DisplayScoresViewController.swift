//
//  DisplayScoresViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/14/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import SwifterSwift
import SwiftDate

class DisplayScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var scoreView: UITableView!
    
    var categoryValue: String = ""
    
    let networkManager = NetworkManager()
    
    let today = Date()
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
    
    var games = [Game]()
    
    override func viewDidLoad()
    {
        let formatter = DateFormatter()
        
        var date = Date()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if TimeZone.current.isDaylightSavingTime()
        {
            date = (formatter.date(from: "2018-12-01T15:11:37.377Z")?.addingTimeInterval(-(9*60*60)))!
        }
        else
        {
            date = (formatter.date(from: "2018-12-02T00:00:00.000Z")?.addingTimeInterval(-(10*60*60)))!
        }
        
        print("Date is: \(date.toFormat("EEEE, MMM dd, yyyy"))")
        print("Time is: \(date.toFormat("hh:mm a"))")
        
        super.viewDidLoad()
        
        fullDateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        timeFormatter.dateFormat = "hh:mm a"
        
        scoreView.dataSource = self
        scoreView.delegate = self
        
        let nib = UINib(nibName: "ScoreCell", bundle: nil)
        scoreView.register(nib, forCellReuseIdentifier: "scoreCell")
        
        self.scoreView.reloadData()
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
        print("Size of games array in numberOfRowsInSection is \(games.count)")
        
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as! ScoreCell
        
        scoreView.rowHeight = CGFloat(130.0)
        
        let visitingTeamName = games[indexPath.row].awayTeam?.name
        let homeTeamName = games[indexPath.row].homeTeam?.name
        
        if(games.count > 0)
        {
            if games[indexPath.row].gameScore?.currentPeriod == "F"
            {
                cell.timeRemaining.text = ""
            }
            else
            {
                cell.timeRemaining.text = timesRemaining[0] + " remaining"
            }
            
            cell.visitingTeamName.text = visitingTeamName
            cell.visitingTeamRecord.text = visitingTeamRecords[0]
            cell.homeTeamName.text = homeTeamName
            cell.homeTeamRecord.text = homeTeamRecords[0]
            cell.visitingTeamScore.text = "\(games[indexPath.row].gameScore?.awayScore ?? 0)"
            cell.homeTeamScore.text = "\(games[indexPath.row].gameScore?.homeScore ?? 0)"
            cell.period.text = games[indexPath.row].gameScore?.currentPeriod
            cell.homeTeamLogo.image = UIImage(named: games[indexPath.row].homeTeam?.abbreviation ?? "")
            cell.visitingTeamLogo.image = UIImage(named: games[indexPath.row].awayTeam?.abbreviation ?? "")
        }
        
        return cell
    }
}
