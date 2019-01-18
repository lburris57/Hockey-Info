//
//  DisplayPlayerInjuryViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/13/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DisplayPlayerInjuryViewController: UITableViewController
{
    @IBOutlet weak var injuryView: UITableView!
    
    var selectedTeamName = ""
    var selectedTeamAbbreviation = ""
    
    let sections = ["Injuries for \(TimeAndDateUtils.getCurrentDateAsString())"]
    
    var injuryArray = [NHLPlayerInjury]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let displayTeamInfoTabBarViewController = self.tabBarController  as! DisplayTeamInfoTabBarViewController
        
        injuryArray = displayTeamInfoTabBarViewController.injuryArray
        
        selectedTeamName = displayTeamInfoTabBarViewController.selectedTeamName
        selectedTeamAbbreviation = displayTeamInfoTabBarViewController.selectedTeamAbbreviation
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
        return self.sections[0]
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
        //  Always display at least one row
        return injuryArray.count > 0 ? injuryArray.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        injuryView.rowHeight = CGFloat(100.0)
        
        var playerName = ""
        var position = ""
        var injuryDescription = ""
        var playingProbablity = ""
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "injuryCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "injuryCell")
        }
        
        cell?.textLabel?.numberOfLines = 0
        
        if injuryArray.count > 0
        {
            playerName = injuryArray[indexPath.row].firstName + " " + injuryArray[indexPath.row].lastName
            position = injuryArray[indexPath.row].position
            injuryDescription = injuryArray[indexPath.row].injuryDescription.uppercased()
            playingProbablity = injuryArray[indexPath.row].playingProbablity
            
            let labelText =
                    "Player: \(playerName) - \(position)\n" +
                    "Injury Description: \(injuryDescription) \n" +
                    "Playing Probablity: \(playingProbablity)"
            
            cell?.textLabel?.text = labelText
        }
        else
        {
            cell?.textLabel?.text = "No reported injuries"
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
