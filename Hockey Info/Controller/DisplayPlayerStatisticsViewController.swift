//
//  DisplayPlayerStatisticsViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/6/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import UIKit

class DisplayPlayerStatisticsViewController: UITableViewController
{
    @IBOutlet weak var playerStatsView: UITableView!
    
    var playerStatistics: PlayerStatistics?
    
    var statsArray = [String]()
    
    var scoringArray = [String]()
    var skatingGoaltendingArray = [String]()
    var penaltiesArray = [String]()
    
    let sections = ["Scoring", "Skating", "Penalties"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadArrays()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        view.tintColor = UIColor.purple
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if(playerStatistics?.parentPlayer[0].position == "G" && self.sections[section] == "Skating")
        {
            return "Goaltending"
        }
        else
        {
            return self.sections[section]
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    {
        view.tintColor = UIColor.white
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textColor = UIColor.white
        footer.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return self.sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch (section)
        {
            case 0:
                return scoringArray.count
            case 1:
                return skatingGoaltendingArray.count
            default:
                return penaltiesArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch(indexPath.section)
        {
            case 0:
                statsArray = scoringArray
            case 1:
                statsArray = skatingGoaltendingArray
            default:
                statsArray = penaltiesArray
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "playerStatisticsCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "playerStatisticsCell")
        }
        
        cell?.textLabel?.text = statsArray[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadArrays()
    {
        if let playerStats = playerStatistics
        {
            scoringArray.append("Games played: \(playerStats.gamesPlayed)")
            scoringArray.append("Goals: \(playerStats.goals)")
            scoringArray.append("Assists: \(playerStats.assists)")
            scoringArray.append("Points: \(playerStats.points)")
            scoringArray.append("Hat Tricks: \(playerStats.hatTricks)")
            scoringArray.append("Powerplay Goals: \(playerStats.powerplayGoals)")
            scoringArray.append("Powerplay Assists: \(playerStats.powerplayAssists)")
            scoringArray.append("Powerplay Points: \(playerStats.powerplayPoints)")
            scoringArray.append("Shorthanded Goals: \(playerStats.shortHandedGoals)")
            scoringArray.append("Shorthanded Assists: \(playerStats.shortHandedAssists)")
            scoringArray.append("Shorthanded Points: \(playerStats.shortHandedPoints)")
            scoringArray.append("Game Winning Goals: \(playerStats.gameWinningGoals)")
            scoringArray.append("Game Tying Goals: \(playerStats.gameTyingGoals)")
            
            if(playerStatistics?.parentPlayer[0].position == "G")
            {
                skatingGoaltendingArray.append("Minutes Played: \(playerStats.minutesPlayed)")
                skatingGoaltendingArray.append("Wins: \(playerStats.wins)")
                skatingGoaltendingArray.append("Losses: \(playerStats.losses)")
                skatingGoaltendingArray.append("Overtime Wins: \(playerStats.overtimeWins)")
                skatingGoaltendingArray.append("Overtime Losses: \(playerStats.overtimeLosses)")
                skatingGoaltendingArray.append("Shots Against: \(playerStats.shotsAgainst)")
                skatingGoaltendingArray.append("Goals Against: \(playerStats.goalsAgainst)")
                skatingGoaltendingArray.append("Saves: \(playerStats.saves)")
                skatingGoaltendingArray.append("Goals Against Average: \(playerStats.goalsAgainstAverage)")
                skatingGoaltendingArray.append("Save Percentage: \(playerStats.savePercentage)%")
                skatingGoaltendingArray.append("Shutouts: \(playerStats.shutouts)")
                skatingGoaltendingArray.append("Games Started: \(playerStats.gamesStarted)")
                skatingGoaltendingArray.append("Credit For Game: \(playerStats.creditForGame)")
            }
            else
            {
                skatingGoaltendingArray.append("Plus/Minus: \(playerStats.plusMinus)")
                skatingGoaltendingArray.append("Shots: \(playerStats.shots)")
                skatingGoaltendingArray.append("Shot Percentage: \(playerStats.shotPercentage)%")
                skatingGoaltendingArray.append("Blocked Shots: \(playerStats.blockedShots)")
                skatingGoaltendingArray.append("Hits: \(playerStats.hits)")
                skatingGoaltendingArray.append("Faceoffs: \(playerStats.faceoffs)")
                skatingGoaltendingArray.append("Faceoff Wins: \(playerStats.faceoffWins)")
                skatingGoaltendingArray.append("Faceoff Losses: \(playerStats.faceoffLosses)")
                skatingGoaltendingArray.append("Faceoff Percentage: \(playerStats.faceoffPercent)%")
            }
            
            penaltiesArray.append("Penalties: \(playerStats.penalties)")
            penaltiesArray.append("Penalties: \(playerStats.penaltyMinutes)")
        }
    }
}
