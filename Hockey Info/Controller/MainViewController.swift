//
//  MainViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/2/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift
import SwifterSwift
import SwiftDate

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    let categories = ["Schedule", "Standings", "Scores", "Team Rosters", "Team Stats"]
    
    let networkManager = NetworkManager()
    
    let databaseManager = DatabaseManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //print("In viewDidLoad method in MainTableViewController...")
        
        if(databaseManager.teamStandingsRequiresSaving())
        {
            networkManager.saveStandings()
        }
        
        if(databaseManager.teamRosterRequiresSaving())
        {
            networkManager.saveRosters()
        }
        
        if(databaseManager.scheduleRequiresSaving())
        {
            networkManager.saveSchedule()
        }
        
        //print("Leaving viewDidLoad method in MainTableViewController...")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        //print("In numberOfSections method in MainTableViewController...")
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //print("In numberOfRowsInSection method in MainTableViewController...")
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //print("In cellForRowAt method in MainTableViewController...")
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = categories[indexPath.row]
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print("In didSelectRowAt method in MainTableViewController...")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let category = categories[indexPath.row]
        
        if(category == "Scores")
        {
            //networkManager.retrieveScores(self)
        }
        else if(category == "Schedule")
        {
            //performSegue(withIdentifier: "displayCalendar", sender: self)
            databaseManager.retrieveTodaysGames(self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //let displayScoresViewController = segue.destination as! DisplayScoresViewController
        
        //displayScoresViewController.games = sender as! [Game]
        
         //print("In prepare method in MainTableViewController...")
        
        let displayCalendarViewController = segue.destination as! DisplayCalendarViewController

        displayCalendarViewController.scheduledGames = sender as? Results<NHLSchedule>
    }
}
