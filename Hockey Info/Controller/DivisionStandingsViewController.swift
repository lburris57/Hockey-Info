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
    @IBOutlet var divisionView: UITableView!
    
    var teamStandings: Results<TeamStandings>?
    
    let databaseManager = DatabaseManager()
    
    var teamArray = [TeamStandings]()
    
    var viewTitle = "Players"
    
    let sections = ["Atlantic", "Metropolitan", "Central", "Pacific"]
    
    var atlanticTeamArray = [TeamStandings]()
    var metropolitanTeamArray = [TeamStandings]()
    var centralTeamArray = [TeamStandings]()
    var pacificTeamArray = [TeamStandings]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let headerNib = UINib(nibName: "StandingsHeaderViewCell", bundle: nil)
        divisionView.register(headerNib, forCellReuseIdentifier: "standingsHeaderViewCell")
        
        let nib = UINib(nibName: "StandingsViewCell", bundle: nil)
        divisionView.register(nib, forCellReuseIdentifier: "standingsViewCell")
        
        let displayStandingsTabViewController = self.tabBarController  as! DisplayStandingsTabViewController
        teamStandings = displayStandingsTabViewController.teamStandingsResults

        print("Size of teamStandingsResults in DivisionStandingsViewController is \(teamStandings?.count ?? 9999)")
        
        divisionView.dataSource = self
        divisionView.delegate = self
        
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
        //let header = view as! UITableViewHeaderFooterView
        //view.textLabel?.textColor = UIColor.white
        //view.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
//    {
//        return self.sections[section]
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "standingsHeaderViewCell") as! StandingsHeaderViewCell
        
        headerCell.headerName.text = self.sections[section]
        
        headerView.addSubview(headerCell)
        return headerView
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
        
        divisionView.rowHeight = CGFloat(44.0)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "standingsViewCell") as! StandingsViewCell
        
        cell.teamLogo.image = UIImage(named: teamArray[indexPath.row].abbreviation)
        cell.teamName.text = TeamManager.getTeamName(teamArray[indexPath.row].abbreviation)
        cell.gamesPlayed.text = String(teamArray[indexPath.row].gamesPlayed)
        cell.wins.text = String(teamArray[indexPath.row].wins)
        cell.losses.text = String(teamArray[indexPath.row].losses)
        cell.overtimeLosses.text = String(teamArray[indexPath.row].overtimeLosses)
        cell.points.text = String(teamArray[indexPath.row].points)
        
        return cell
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
            
            //  Sort the arrays
            atlanticTeamArray.sort {$0.divisionRank < $1.divisionRank}
            metropolitanTeamArray.sort {$0.divisionRank < $1.divisionRank}
            centralTeamArray.sort {$0.divisionRank < $1.divisionRank}
            pacificTeamArray.sort {$0.divisionRank < $1.divisionRank}
        }
    }
}
