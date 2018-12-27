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
    let sections = ["Record as of \(DateInRegion().toFormat("EEEE, MMM dd, yyyy"))", "Faceoffs", "Power Plays", "Penalty Kills", "Miscellaneous"]
    
    let databaseManager = DatabaseManager()
    
    var team: NHLTeam?
    
    var statsArray = [String]()
    
    var standingsArray = [String]()
    var faceoffsArray = [String]()
    var powerplaysArray = [String]()
    var penaltyKillsArray = [String]()
    var miscellaneousArray = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadStatsArrays()
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

    func loadStatsArrays()
    {
        if(team != nil)
        {
            //  Load the standings data
            let conferenceName = team?.conference
            let conferenceRank = ConversionUtils.normalizeRank((team?.standings[0].conferenceRank)!)
            let divisionName = team?.division
            let divisionRank = ConversionUtils.normalizeRank((team?.standings[0].divisionRank)!)
            let gamesPlayed = team?.statistics[0].gamesPlayed
            let points = team?.statistics[0].points
            let wins = team?.statistics[0].wins
            let losses = team?.statistics[0].losses
            let overtimeLosses = team?.statistics[0].overtimeLosses
            
            let conferenceString = "Rank in the \(conferenceName ?? "") conference: \(conferenceRank)"
            let divisionString = "Rank in the \(divisionName ?? "") division: \(divisionRank)"
            let gamesPlayedString = "Games played: \(gamesPlayed ?? 0)"
            let pointsString = "Points: \(points ?? 0)"
            let winsString = "\(wins ?? 0)"
            let lossesString = "\(losses ?? 0)"
            let overtimeLossesString = "\(overtimeLosses ?? 0)"
            let recordString = "Record: " + winsString + "-" + lossesString + "-" + overtimeLossesString
            
            standingsArray.append(gamesPlayedString)
            standingsArray.append(pointsString)
            standingsArray.append(recordString)
            standingsArray.append(divisionString)
            standingsArray.append(conferenceString)
            
            let faceoffWins = team?.statistics[0].faceoffWins ?? 0
            let faceoffLosses = team?.statistics[0].faceoffLosses ?? 0
            
            //  Load the faceoff data
            let totalFaceoffs = "Total Faceoffs: \(faceoffWins + faceoffLosses)"
            let faceoffWinsString = "Faceoff Wins: \(faceoffWins)"
            let faceoffLossesString = "Faceoff Losses: \(faceoffLosses)"
            let faceoffPercent = "Faceoff Percent: \(team?.statistics[0].faceoffPercent ?? 0.0)%"
            
            faceoffsArray.append(totalFaceoffs)
            faceoffsArray.append(faceoffWinsString)
            faceoffsArray.append(faceoffLossesString)
            faceoffsArray.append(faceoffPercent)
            
            //  Load the power play data
            let powerPlays = "Power Plays: \(team?.statistics[0].powerplays ?? 0)"
            let powerPlayGoals = "Power Play Goals: \(team?.statistics[0].powerplayGoals ?? 0)"
            let powerPlayPercent = "Power Play Percent: \(team?.statistics[0].powerplayPercent ?? 0.0)%"
            
            powerplaysArray.append(powerPlays)
            powerplaysArray.append(powerPlayGoals)
            powerplaysArray.append(powerPlayPercent)
            
            //  Load the penalty kill data
            let penaltyMinutes = "Penalty Minutes: \(team?.statistics[0].penaltyMinutes ?? 0)"
            let penaltyKill = "Penalties Killed: \(team?.statistics[0].penaltyKills ?? 0)/\(team?.statistics[0].penalties ?? 0)"
            let penaltyKillGoalsAllowed = "Penalty Kill Goals Allowed: \(team?.statistics[0].penaltyKillGoalsAllowed ?? 0)"
            let penaltyKillPercent = "Penalty Kill Percent: \(team?.statistics[0].penaltyKillPercent ?? 0.0)%"
            
            penaltyKillsArray.append(penaltyMinutes)
            penaltyKillsArray.append(penaltyKill)
            penaltyKillsArray.append(penaltyKillGoalsAllowed)
            penaltyKillsArray.append(penaltyKillPercent)
            
            //  Load the Misc data
            let goalsFor = "Goals For: \(team?.statistics[0].goalsFor ?? 0)"
            let goalAgainst = "Goals Against: \(team?.statistics[0].goalsAgainst ?? 0)"
            let shots = "Shots: \(team?.statistics[0].shots ?? 0)"
            let hits = "Hits: \(team?.statistics[0].hits ?? 0)"
            
            miscellaneousArray.append(goalsFor)
            miscellaneousArray.append(goalAgainst)
            miscellaneousArray.append(shots)
            miscellaneousArray.append(hits)
        }
    }
}

