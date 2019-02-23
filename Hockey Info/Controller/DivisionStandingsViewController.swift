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
    
    let sections = ["Atlantic Division         GP         W            L          OTL      PTS",
                        "Metro Division            GP         W            L          OTL      PTS",
                        "Central Division         GP         W            L          OTL      PTS",
                        "Pacific Division          GP         W            L          OTL      PTS"]
    
    var teamStandings: Results<TeamStandings>?
    var teamArray = [TeamStandings]()
    var atlanticTeamArray = [TeamStandings]()
    var metropolitanTeamArray = [TeamStandings]()
    var centralTeamArray = [TeamStandings]()
    var pacificTeamArray = [TeamStandings]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let myNib = UINib(nibName: "StandingsCell", bundle: Bundle.main)
        divisionView.register(myNib, forCellReuseIdentifier: "standingsCell")
        
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
