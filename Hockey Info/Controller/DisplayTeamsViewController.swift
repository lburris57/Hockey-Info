//
//  DisplayTeamsViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/11/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DisplayTeamsViewController: UITableViewController
{
    @IBOutlet weak var teamView: UITableView!
    
    var teamResults: Results<NHLTeam>?
    
    let databaseManager = DatabaseManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return teamResults?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let teamName = TeamManager.getFullTeamName(teamResults?[indexPath.row].abbreviation ?? "")
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "teamCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "teamCell")
        }
        
        cell?.imageView?.image = UIImage(named: teamResults?[indexPath.row].abbreviation ?? "")
        cell?.textLabel?.text = teamName
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let teamId = teamResults?[indexPath.row].id
        
        //databaseManager.displayRoster(self, teamId!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "displayRoster")
        {
            let displayRosterViewController = segue.destination as! DisplayRosterViewController
            
            //displayRosterViewController.playerResults = sender as? Results<NHLPlayer>
        }
    }
}
