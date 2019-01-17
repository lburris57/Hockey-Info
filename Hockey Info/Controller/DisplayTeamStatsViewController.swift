//
//  DisplayTeamStatsViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/11/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift
import SwiftDate

class DisplayTeamStatsViewController: UITableViewController
{
    @IBOutlet weak var statsView: UITableView!
    
    let sections = ["Record as of \(DateInRegion().toFormat("EEEE, MMM dd, yyyy"))", "Faceoffs", "Power Plays", "Penalty Kills", "Miscellaneous"]
    
    let databaseManager = DatabaseManager()
    
    var selectedTeamName = ""
    var selectedTeamAbbreviation = ""
    
    var statsArray = [String]()
    
    var statistics = TeamStatistics()
    
    var team = NHLTeam()
    
    var standingsArray = [String]()
    var faceoffsArray = [String]()
    var powerplaysArray = [String]()
    var penaltyKillsArray = [String]()
    var miscellaneousArray = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let displayTeamInfoTabBarViewController = self.tabBarController  as! DisplayTeamInfoTabBarViewController
        
        statistics = displayTeamInfoTabBarViewController.statsArray[0]
        team = displayTeamInfoTabBarViewController.team
        
        selectedTeamName = displayTeamInfoTabBarViewController.selectedTeamName
        selectedTeamAbbreviation = displayTeamInfoTabBarViewController.selectedTeamAbbreviation
        
        loadStatsArrays(statistics)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch (section)
        {
            case 0:
                return standingsArray.count
            case 1:
                return faceoffsArray.count
            case 2:
                return powerplaysArray.count
            case 3:
                return penaltyKillsArray.count
            default:
                return miscellaneousArray.count
        }
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
        return self.sections[section]
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch(indexPath.section)
        {
            case 0:
                statsArray = standingsArray
            case 1:
                statsArray = faceoffsArray
            case 2:
                statsArray = powerplaysArray
            case 3:
                statsArray = penaltyKillsArray
            default:
                statsArray = miscellaneousArray
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "statsCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "statsCell")
        }
        
        cell?.textLabel?.text = statsArray[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func loadStatsArrays(_ statistics: TeamStatistics)
    {
        //  Load the standings data
        let conferenceName = team.conference
        let conferenceRank = ConversionUtils.normalizeRank(team.standings[0].conferenceRank)
        let divisionName = team.division
        let divisionRank = ConversionUtils.normalizeRank(team.standings[0].divisionRank)
        let gamesPlayed = statistics.gamesPlayed
        let points = statistics.points
        let wins = statistics.wins
        let losses = statistics.losses
        let overtimeLosses = statistics.overtimeLosses
        
        let conferenceString = "Rank in the \(conferenceName) conference: \(conferenceRank)"
        let divisionString = "Rank in the \(divisionName) division: \(divisionRank)"
        let gamesPlayedString = "Games played: \(gamesPlayed)"
        let pointsString = "Points: \(points)"
        let winsString = "\(wins)"
        let lossesString = "\(losses)"
        let overtimeLossesString = "\(overtimeLosses)"
        let recordString = "Record: " + winsString + "-" + lossesString + "-" + overtimeLossesString
        
        standingsArray.append(gamesPlayedString)
        standingsArray.append(pointsString)
        standingsArray.append(recordString)
        standingsArray.append(divisionString)
        standingsArray.append(conferenceString)
        
        let faceoffWins = statistics.faceoffWins
        let faceoffLosses = statistics.faceoffLosses
        
        //  Load the faceoff data
        let totalFaceoffs = "Total Faceoffs: \(faceoffWins + faceoffLosses)"
        let faceoffWinsString = "Faceoff Wins: \(faceoffWins)"
        let faceoffLossesString = "Faceoff Losses: \(faceoffLosses)"
        let faceoffPercent = "Faceoff Percent: \(statistics.faceoffPercent)%"
        
        faceoffsArray.append(totalFaceoffs)
        faceoffsArray.append(faceoffWinsString)
        faceoffsArray.append(faceoffLossesString)
        faceoffsArray.append(faceoffPercent)
        
        //  Load the power play data
        let powerPlays = "Power Plays: \(statistics.powerplays)"
        let powerPlayGoals = "Power Play Goals: \(statistics.powerplayGoals)"
        let powerPlayPercent = "Power Play Percent: \(statistics.powerplayPercent)%"
        
        powerplaysArray.append(powerPlays)
        powerplaysArray.append(powerPlayGoals)
        powerplaysArray.append(powerPlayPercent)
        
        //  Load the penalty kill data
        let penaltyMinutes = "Penalty Minutes: \(statistics.penaltyMinutes)"
        let penaltyKill = "Penalties Killed: \(statistics.penaltyKills)/\(statistics.penalties)"
        let penaltyKillGoalsAllowed = "Penalty Kill Goals Allowed: \(statistics.penaltyKillGoalsAllowed)"
        let penaltyKillPercent = "Penalty Kill Percent: \(statistics.penaltyKillPercent)%"
        
        penaltyKillsArray.append(penaltyMinutes)
        penaltyKillsArray.append(penaltyKill)
        penaltyKillsArray.append(penaltyKillGoalsAllowed)
        penaltyKillsArray.append(penaltyKillPercent)
        
        //  Load the Misc data
        let goalsFor = "Goals For: \(statistics.goalsFor)"
        let goalAgainst = "Goals Against: \(statistics.goalsAgainst)"
        let shots = "Shots: \(statistics.shots)"
        let hits = "Hits: \(statistics.hits)"
        
        miscellaneousArray.append(goalsFor)
        miscellaneousArray.append(goalAgainst)
        miscellaneousArray.append(shots)
        miscellaneousArray.append(hits)
    }
}

