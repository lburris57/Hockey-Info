//
//  MainMenuViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/2/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift
//import SwifterSwift
//import SwiftDate

class MainMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var categories = [MenuCategory]()
    
    let networkManager = NetworkManager()
    
    let databaseManager = DatabaseManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("In viewDidLoad method in MainTableViewController...")
        
        if(databaseManager.mainMenuCategoriesRequiresSaving())
        {
            databaseManager.saveMainMenuCategories()
        }
        
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
        
        categories.removeAll()
        
        categories = databaseManager.retrieveMainMenuCategories()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = categories[indexPath.row].category
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let category = categories[indexPath.row].category
        
        if(category == "Scores")
        {
            //networkManager.retrieveScores(self)
        }
        else if(category == "Schedule")
        {
            databaseManager.retrieveTodaysGames(self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let displayCalendarViewController = segue.destination as! DisplayCalendarViewController

        displayCalendarViewController.scheduledGames = sender as? Results<NHLSchedule>
    }
}
