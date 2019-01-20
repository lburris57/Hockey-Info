//
//  MainMenuViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/2/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class MainMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var mainMenuView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    var categories = [MenuCategory]()
    
    let networkManager = NetworkManager()
    
    let databaseManager = DatabaseManager()
    
    var alert: UIAlertController?
    
    let displayScoresViewController = DisplayScoresViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(databaseManager.teamRosterRequiresSaving())
        {
            self.presentInitialAlert()
            
            networkManager.saveRosters()
        }
        
        if(databaseManager.scheduleRequiresSaving())
        {
            networkManager.saveSchedule()
        }
        
        if(databaseManager.teamStandingsRequiresSaving())
        {
            networkManager.saveStandings()
        }
        
        if(databaseManager.gameLogRequiresSaving())
        {
            networkManager.saveGameLogs()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
            {
                self.dismissAlert()
            }
        }
        
        if(databaseManager.mainMenuCategoriesRequiresSaving())
        {
            databaseManager.saveMainMenuCategories()
        }
        
        categories = databaseManager.retrieveMainMenuCategories()
        
        if (!databaseManager.teamRosterRequiresSaving() && databaseManager.tablesRequireReload())
        {
            self.reloadTables()
        }
        else
        {
            print("Tables don't need to be reloaded...")
        }
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *)
        {
            mainMenuView.refreshControl = refreshControl
        }
        else
        {
            mainMenuView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshTableData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing database tables...")
    }
    
    @objc private func refreshTableData(_ sender: Any)
    {
        self.refreshTableData()
    }
    
    func refreshTableData()
    {
        networkManager.saveRosters()
        networkManager.saveStandings()
        networkManager.reloadGameLogs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            self.refreshControl.endRefreshing()
            self.linkTables()
        }
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
        if(databaseManager.teamTableRequiresLinking())
        {
            linkTables()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let category = categories[indexPath.row].category

        if(category == "Scores")
        {
            networkManager.updateScheduleForDate(Date())
            
            databaseManager.displaySchedule(self, "displayScores")
        }
        else if(category == "Season Schedule")
        {
            databaseManager.retrieveTodaysGames(self)
        }
        else if(category == "Team Information")
        {
            databaseManager.displayTeams(self, category)
        }
        else if(category == "Standings")
        {
            databaseManager.displayStandings(self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "displaySchedule")
        {
            let displayCalendarViewController = segue.destination as! DisplayCalendarViewController

            displayCalendarViewController.scheduledGames = sender as? Results<NHLSchedule>
        }
        else if(segue.identifier == "displayAllTeams")
        {
            let displayTeamsViewController = segue.destination as! DisplayTeamsViewController
            
            displayTeamsViewController.segueId = segue.identifier!
            
            displayTeamsViewController.teamResults = sender as? Results<NHLTeam>
        }
        else if(segue.identifier == "displayScores")
        {
            let displayScoresViewController = segue.destination as! DisplayScoresViewController
            
            displayScoresViewController.nhlSchedules = sender as? Results<NHLSchedule>
        }
        else if(segue.identifier == "displayStandings")
        {
            let displayStandingsTabViewController = segue.destination as! DisplayStandingsTabViewController
            
            displayStandingsTabViewController.teamStandingsResults = sender as? Results<TeamStandings>
        }
    }
}

extension MainMenuViewController
{
    func presentInitialAlert()
    {
        alert = UIAlertController(title: "Loading Database Tables", message: "Database tables must be populated the first time Hockey Info is run.  Please wait...", preferredStyle: .alert)
        alert!.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert!.view.addSubview(loadingIndicator)
        self.present(alert!, animated: true)
    }
    
    func presentUpdatingTablesAlert()
    {
        alert = UIAlertController(title: "Loading Database Tables", message: "Database tables are updated daily.  Please wait...", preferredStyle: .alert)
        alert!.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert!.view.addSubview(loadingIndicator)
        self.present(alert!, animated: true)
    }
    
    func reloadTables()
    {
        self.presentUpdatingTablesAlert()
        
        networkManager.saveRosters()
        networkManager.saveStandings()
        networkManager.reloadGameLogs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            self.linkTables()
            self.dismissAlert()
        }
    }
    
    func linkTables()
    {
        print("Linking table data...")
        
        //  If tables have been reloaded, remove existing
        //  team links to prevent duplicate data
        databaseManager.deleteTeamLinks()

        databaseManager.linkPlayersToTeams()
        databaseManager.linkStandingsToTeams()
        databaseManager.linkStatisticsToTeams()
        databaseManager.linkSchedulesToTeams()
        databaseManager.linkGameLogsToTeams()
        databaseManager.linkPlayerInjuriesToTeams()

        print("Linking of table data was successful!")

        networkManager.updateScheduleForDate(Date())
    }
    
    func dismissAlert()
    {
        self.alert?.dismiss(animated: false, completion: nil)
    }
}
