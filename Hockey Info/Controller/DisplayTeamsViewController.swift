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
    let teamInfoTabBarViewController = DisplayTeamInfoTabBarViewController()
    
    var teamArray = [NHLTeam]()
    
    var selectedTeamAbbreviation = ""
    var selectedTeamName = ""
    
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
        
        selectedTeamName = TeamManager.getFullTeamName((teamArray[indexPath.row].abbreviation))
        selectedTeamAbbreviation = teamArray[indexPath.row].abbreviation
        
        databaseManager.displayTeamInfo(self, teamId)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let displayTeamInfoTabBarViewController = segue.destination as! DisplayTeamInfoTabBarViewController
            
        displayTeamInfoTabBarViewController.teamResults = sender as? Results<NHLTeam>
        
        if let teams = displayTeamInfoTabBarViewController.teamResults
        {
            displayTeamInfoTabBarViewController.title = "\(TeamManager.getFullTeamName(TeamManager.getTeamByID(teams[0].id))) Information"
            
            displayTeamInfoTabBarViewController.selectedTeamAbbreviation = teams[0].abbreviation
            displayTeamInfoTabBarViewController.selectedTeamName = "\(TeamManager.getFullTeamName(TeamManager.getTeamByID(teams[0].id)))"
        }
    }
    
    func loadTeamArrays()
    {
        if let teams = teamResults
        {
            atlanticTeamArray = teams.filter({$0.division == DivisionEnum.Atlantic.rawValue})
            metropolitanTeamArray = teams.filter({$0.division == DivisionEnum.Metropolitan.rawValue})
            centralTeamArray = teams.filter({$0.division == DivisionEnum.Central.rawValue})
            pacificTeamArray = teams.filter({$0.division == DivisionEnum.Pacific.rawValue})
        }
    }
}
