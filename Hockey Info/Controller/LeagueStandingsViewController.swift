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
        
        let myNib = UINib(nibName: "StandingsCell", bundle: Bundle.main)
        leagueView.register(myNib, forCellReuseIdentifier: "standingsCell")
        
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
        header.textLabel?.font = UIFont.init(name: "Helvetica Neue", size: 14)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "League Standings     GP         W            L          OTL       PTS"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "standingsCell", for: indexPath) as! StandingsCell
        
        let gamesPlayed = String(teamArray[indexPath.row].gamesPlayed)
        let gamesWon = String(teamArray[indexPath.row].wins)
        let gamesLost = String(teamArray[indexPath.row].losses)
        let overtimeLosses = String(teamArray[indexPath.row].overtimeLosses)
        let totalPoints = String(teamArray[indexPath.row].points)
        
        cell.city.text = TeamManager.getTeamCityName(teamArray[indexPath.row].abbreviation)
        cell.gamesPlayed.text = gamesPlayed.count == 2 ? gamesPlayed : " " + gamesPlayed
        cell.gamesWon.text = gamesWon.count == 2 ? gamesWon : " " + gamesWon
        cell.gamesLost.text = gamesLost.count == 2 ? gamesLost : " " + gamesLost
        cell.overtimeLosses.text = overtimeLosses.count == 2 ? overtimeLosses : "  " + overtimeLosses
        cell.totalPoints.text = totalPoints.count == 3 ? totalPoints : " " + totalPoints
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func loadTeamArray()
    {
        if let standings = teamStandings
        {
            for team in standings
            {
                teamArray.append(team)
            }
            
            //  Sort the arrays
            teamArray.sort {$0.points > $1.points}
        }
    }
}
