//
//  LeagueStandingsViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/13/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class LeagueStandingsViewController: UITableViewController
{
    @IBOutlet weak var leagueView: UITableView!
    
    var teamStandings: Results<TeamStandings>?
    
    let databaseManager = DatabaseManager()
    
    var teamArray = [TeamStandings]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let displayStandingsTabViewController = self.tabBarController  as! DisplayStandingsTabViewController
        teamStandings = displayStandingsTabViewController.teamStandingsResults
        
        loadTeamArray()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
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
        return "League Standings"
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
        return ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return teamArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "leagueViewCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "leagueViewCell")
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
    
    func loadTeamArray()
    {
        if(teamStandings != nil)
        {
            for team in teamStandings!
            {
                teamArray.append(team)
            }
            
            //  Sort the arrays
            teamArray.sort {$0.points > $1.points}
        }
    }
}
