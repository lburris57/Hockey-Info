//
//  GamesRemainingViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/11/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class GamesRemainingViewController: UITableViewController
{
    @IBOutlet weak var remainingScheduleView: UITableView!
    
    var gamesRemainingArray = [NHLSchedule]()
    
    var selectedTeamName = ""
    var selectedTeamAbbreviation = ""
    
    let databaseManager = DatabaseManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let displayTeamInfoTabBarViewController = self.tabBarController  as! DisplayTeamInfoTabBarViewController
        
        gamesRemainingArray = displayTeamInfoTabBarViewController.gamesRemainingArray
        
        selectedTeamName = displayTeamInfoTabBarViewController.selectedTeamName
        selectedTeamAbbreviation = displayTeamInfoTabBarViewController.selectedTeamAbbreviation
        
        let myNib = UINib(nibName: "FutureScheduleViewCell", bundle: Bundle.main)
        remainingScheduleView.register(myNib, forCellReuseIdentifier: "futureScheduleViewCell")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return gamesRemainingArray.count
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
        return "Games Remaining for \(selectedTeamName)"
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var designator = ""
        
        var isHomeTeam = false
        
         remainingScheduleView.rowHeight = CGFloat(65.0)
        
        if(selectedTeamAbbreviation == gamesRemainingArray[indexPath.row].homeTeam)
        {
            isHomeTeam = true
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "futureScheduleViewCell", for: indexPath) as! FutureScheduleViewCell
        cell.selectionStyle = .none
        
        designator = gamesRemainingArray[indexPath.row].homeTeam == selectedTeamAbbreviation ? "vs" : "@"
        
        cell.date.text = gamesRemainingArray[indexPath.row].date
        cell.opponent.text = isHomeTeam ?
            designator + " " + TeamManager.getTeamCityName(gamesRemainingArray[indexPath.row].awayTeam) : designator + " " + TeamManager.getTeamCityName(gamesRemainingArray[indexPath.row].homeTeam)
        cell.time.text = gamesRemainingArray[indexPath.row].time
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
