//
//  DisplayTeamsViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/11/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DisplayTeamsViewController: UITableViewController
{
    @IBOutlet weak var teamView: UITableView!
    
    var teamResults: Results<NHLTeam>?
    
    let databaseManager = DatabaseManager()
    
    let teamStatsViewController = DisplayTeamStatsViewController()
    
    var teamArray = [NHLTeam]()
    
    var viewTitle = ""
    
    var segueId = ""
    
    let sections = ["Atlantic", "Metropolitan", "Central", "Pacific"]
    
    var atlanticTeamArray = [NHLTeam]()
    var metropolitanTeamArray = [NHLTeam]()
    var centralTeamArray = [NHLTeam]()
    var pacificTeamArray = [NHLTeam]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadTeamArrays()
    }
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch (section)
        {
            case 0:
                return atlanticTeamArray.count
            case 1:
                return metropolitanTeamArray.count
            case 2:
                return centralTeamArray.count
            default:
                return pacificTeamArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch(indexPath.section)
        {
            case 0:
                teamArray = atlanticTeamArray
            case 1:
                teamArray = metropolitanTeamArray
            case 2:
                teamArray = centralTeamArray
            default:
                teamArray = pacificTeamArray
        }
        
        let teamName = TeamManager.getFullTeamName(teamArray[indexPath.row].abbreviation)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "teamCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "teamCell")
        }
        
        cell?.imageView?.image = UIImage(named: teamArray[indexPath.row].abbreviation)
        cell?.textLabel?.text = teamName
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = indexPath[0]
        
        switch(index)
        {
            case 0:
                teamArray = atlanticTeamArray
            case 1:
                teamArray = metropolitanTeamArray
            case 2:
                teamArray = centralTeamArray
            default:
                teamArray = pacificTeamArray
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let teamId = teamArray[indexPath.row].id
        
        viewTitle = TeamManager.getFullTeamName((teamArray[indexPath.row].abbreviation))
        
        if(segueId == "displayTeams")
        {
            databaseManager.displayRoster(self, teamId)
        }
        else if(segueId == "displayTeamStatistics")
        {
            databaseManager.displayTeamStatistics(self, teamId)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "displayRoster")
        {
            let displayRosterViewController = segue.destination as! DisplayRosterViewController
            
            displayRosterViewController.playerResults = sender as? Results<NHLPlayer>

            displayRosterViewController.title = "Players"
        }
        else if(segue.identifier == "displayTeamStatistics")
        {
            let displayTeamStatsViewController = segue.destination as! DisplayTeamStatsViewController
            
            displayTeamStatsViewController.team = sender as? NHLTeam
            
            displayTeamStatsViewController.title = "Stats for \(TeamManager.getFullTeamName( (displayTeamStatsViewController.team?.abbreviation)!))"
        }
    }
    
    func loadTeamArrays()
    {
        if(teamResults != nil)
        {
            for team in teamResults!
            {
                if(team.division == DivisionEnum.Atlantic.rawValue)
                {
                    atlanticTeamArray.append(team)
                }
                else if(team.division == DivisionEnum.Metropolitan.rawValue)
                {
                    metropolitanTeamArray.append(team)
                }
                else if(team.division == DivisionEnum.Central.rawValue)
                {
                    centralTeamArray.append(team)
                }
                else if(team.division == DivisionEnum.Pacific.rawValue)
                {
                    pacificTeamArray.append(team)
                }
            }
        }
    }
}
