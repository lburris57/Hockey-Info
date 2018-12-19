//
//  DisplayTeamStatsViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/11/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DisplayTeamStatsViewController: UITableViewController
{
    let sections = ["Standings", "Faceoffs", "Powerplays", "Miscellaneous"]
    
    let databaseManager = DatabaseManager()
    
    var statsResults: Results<TeamStatistics>?
    
    var statsArray = [TeamStatistics]()
    
    var standingsArray = [TeamStatistics]()
    var faceoffsArray = [TeamStatistics]()
    var powerplaysArray = [TeamStatistics]()
    var miscellaneousArray = [TeamStatistics]()
    
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
            default:
                statsArray = miscellaneousArray
        }
        
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "statsCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "statsCell")
        }
        
        //cell?.textLabel?.text = playerName
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "displayPlayer")
        {
            let displayPlayerViewController = segue.destination as! DisplayPlayerViewController
            
            displayPlayerViewController.playerResult = sender as? NHLPlayer
        }
    }
    
    func loadStatsArrays()
    {
        if(statsResults != nil)
        {
            for stats in statsResults!
            {
//                if(player.position == PositionEnum.leftWing.rawValue ||
//                    player.position == PositionEnum.rightWing.rawValue ||
//                    player.position == PositionEnum.center.rawValue)
//                {
//                    forwardsArray.append(player)
//                }
//                else if(player.position == PositionEnum.defenseman.rawValue)
//                {
//                    defensemenArray.append(player)
//                }
//                else if(player.position == PositionEnum.goalie.rawValue)
//                {
//                    goalieArray.append(player)
                }
            }
        }
    }

