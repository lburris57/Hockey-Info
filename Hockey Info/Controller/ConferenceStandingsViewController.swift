//
//  ConferenceStandingsViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/13/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class ConferenceStandingsViewController: UITableViewController
{
    @IBOutlet weak var conferenceView: UITableView!
    
    var teamStandings: Results<TeamStandings>?
    
    let databaseManager = DatabaseManager()
    
    var teamArray = [TeamStandings]()
    
    let sections = ["Eastern Conference", "Western Conference"]
    
    var easternTeamArray = [TeamStandings]()
    var westernTeamArray = [TeamStandings]()
    
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
            return easternTeamArray.count
        default:
            return westernTeamArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch(indexPath.section)
        {
        case 0:
            teamArray = easternTeamArray
        default:
            teamArray = westernTeamArray
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "conferenceViewCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "conferenceViewCell")
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
        if(teamStandings != nil)
        {
            for team in teamStandings!
            {
                if(team.conference == ConferenceEnum.Eastern.rawValue)
                {
                    easternTeamArray.append(team)
                }
                else if(team.conference == ConferenceEnum.Western.rawValue)
                {
                    westernTeamArray.append(team)
                }
            }
            
            //  Sort the arrays
            easternTeamArray.sort {$0.conferenceRank < $1.conferenceRank}
            westernTeamArray.sort {$0.conferenceRank < $1.conferenceRank}
        }
    }
}
