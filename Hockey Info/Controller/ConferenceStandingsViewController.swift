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
    
    let sections = ["Eastern Conference   GP         W            L          OTL      PTS",
                        "Western Conference  GP         W            L          OTL      PTS"]
    
    var easternTeamArray = [TeamStandings]()
    var westernTeamArray = [TeamStandings]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let myNib = UINib(nibName: "StandingsCell", bundle: Bundle.main)
        conferenceView.register(myNib, forCellReuseIdentifier: "standingsCell")
        
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
        header.textLabel?.font = UIFont.init(name: "Helvetica Neue", size: 14)
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
    
    func loadTeamArrays()
    {
        if let standings = teamStandings
        {
            easternTeamArray = standings.filter({$0.conference == ConferenceEnum.Eastern.rawValue})
            westernTeamArray = standings.filter({$0.conference == ConferenceEnum.Western.rawValue})
            
            //  Sort the arrays
            easternTeamArray.sort {$0.conferenceRank < $1.conferenceRank}
            westernTeamArray.sort {$0.conferenceRank < $1.conferenceRank}
        }
    }
}
