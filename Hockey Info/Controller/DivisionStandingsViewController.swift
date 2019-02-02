//
//  DivisionStandingsViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/13/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DivisionStandingsViewController: UITableViewController
{
    @IBOutlet weak var divisionView: UITableView!
    
    let databaseManager = DatabaseManager()
    
    let sections = ["Atlantic Division", "Metropolitan Division", "Central Division", "Pacific Division"]
    
    var teamStandings: Results<TeamStandings>?
    var teamArray = [TeamStandings]()
    var atlanticTeamArray = [TeamStandings]()
    var metropolitanTeamArray = [TeamStandings]()
    var centralTeamArray = [TeamStandings]()
    var pacificTeamArray = [TeamStandings]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let displayStandingsTabViewController = self.tabBarController  as! DisplayStandingsTabViewController
        teamStandings = displayStandingsTabViewController.teamStandingsResults
        
        loadTeamArrays()
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
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "divisionViewCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "divisionViewCell")
        }
        
        cell?.textLabel?.text = TeamManager.getTeamCityName(teamArray[indexPath.row].abbreviation)
        cell?.detailTextLabel?.text = String(teamArray[indexPath.row].gamesPlayed) + "\t\t" +
        String(teamArray[indexPath.row].wins) + "\t\t" + String(teamArray[indexPath.row].losses) + "\t\t" +
        String(teamArray[indexPath.row].overtimeLosses) + "\t\t" + String(teamArray[indexPath.row].points)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func loadTeamArrays()
    {
        if let standings = teamStandings
        {
            atlanticTeamArray = standings.filter({$0.division == DivisionEnum.Atlantic.rawValue})
            metropolitanTeamArray = standings.filter({$0.division == DivisionEnum.Metropolitan.rawValue})
            centralTeamArray = standings.filter({$0.division == DivisionEnum.Central.rawValue})
            pacificTeamArray = standings.filter({$0.division == DivisionEnum.Pacific.rawValue})
            
            //  Sort the arrays
            atlanticTeamArray.sort {$0.divisionRank < $1.divisionRank}
            metropolitanTeamArray.sort {$0.divisionRank < $1.divisionRank}
            centralTeamArray.sort {$0.divisionRank < $1.divisionRank}
            pacificTeamArray.sort {$0.divisionRank < $1.divisionRank}
        }
    }
}
