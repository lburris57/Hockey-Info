//
//  DisplayRosterViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/11/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DisplayRosterViewController: UITableViewController
{
    @IBOutlet weak var rosterView: UITableView!
    
    let sections = ["Forwards", "Defensemen", "Goalies"]
    
    let databaseManager = DatabaseManager()
    
    var playerResults: Results<NHLPlayer>?
    
    var playerArray = [NHLPlayer]()
    
    var forwardsArray = [NHLPlayer]()
    var defensemenArray = [NHLPlayer]()
    var goalieArray = [NHLPlayer]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadPlayerArrays()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        view.tintColor = UIColor.purple
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch (section)
        {
            case 0:
                return forwardsArray.count
            case 1:
                return defensemenArray.count
            default:
                return goalieArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return self.sections[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch(indexPath.section)
        {
            case 0:
                playerArray = forwardsArray
            case 1:
                playerArray = defensemenArray
            default:
                playerArray = goalieArray
        }
        
        var jerseyNumber = playerArray[indexPath.row].jerseyNumber
        let firstName = playerArray[indexPath.row].firstName
        let lastName = playerArray[indexPath.row].lastName
        
        if(jerseyNumber.count == 1)
        {
            jerseyNumber = " " + jerseyNumber
        }
        
        let playerName =  jerseyNumber + "   " + firstName + " " + lastName
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "playerCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "playerCell")
        }
        
        cell?.textLabel?.text = playerName
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath[0]
        
        switch(index)
        {
            case 0:
                playerArray = forwardsArray
            case 1:
                playerArray = defensemenArray
            default:
                playerArray = goalieArray
        }
        
        //let playerId = playerResults?[indexPath.row].id
        
        //databaseManager.displayRoster(self, teamId!)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "displayPlayer")
        {
            //let displayRosterViewController = segue.destination as! DisplayRosterViewController
            
            //displayRosterViewController.playerResults = sender as? Results<NHLPlayer>
        }
    }
    
    func loadPlayerArrays()
    {
        if(playerResults != nil)
        {
            for player in playerResults!
            {
                if(player.position == PositionEnum.leftWing.rawValue ||
                    player.position == PositionEnum.rightWing.rawValue ||
                    player.position == PositionEnum.center.rawValue)
                {
                    forwardsArray.append(player)
                }
                else if(player.position == PositionEnum.defenseman.rawValue)
                {
                    defensemenArray.append(player)
                }
                else if(player.position == PositionEnum.goalie.rawValue)
                {
                    goalieArray.append(player)
                }
            }
        }
    }
}

