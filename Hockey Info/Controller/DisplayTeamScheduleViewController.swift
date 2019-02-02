//
//  DisplayTeamScheduleViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/27/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DisplayTeamScheduleViewController: UITableViewController, CompletedScheduleViewCellDelegate
{
    @IBOutlet weak var scheduleView: UITableView!
    
    var selectedTeamName = ""
    var selectedTeamAbbreviation = ""
    
    var completedGames = [NHLSchedule]()
    var gamesRemaining = [NHLSchedule]()
    
    var sections = ["", ""]
    
    let databaseManager = DatabaseManager()
    
    let completedGamesViewController = CompletedGamesViewController()
    
    var teamSchedules: Results<NHLSchedule>?
    
    var scheduleArray = [NHLSchedule]()
    
    var completedGamesArray = [NHLSchedule]()
    var gamesRemainingArray = [NHLSchedule]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let myNib = UINib(nibName: "CompletedScheduleViewCell", bundle: Bundle.main)
        scheduleView.register(myNib, forCellReuseIdentifier: "completedScheduleViewCell")
        
        let myNib2 = UINib(nibName: "FutureScheduleViewCell", bundle: Bundle.main)
        scheduleView.register(myNib2, forCellReuseIdentifier: "futureScheduleViewCell")
        
        loadArrays()
        
        sections[0] = "Completed Games: \(completedGamesArray.count)"
        sections[1] = "Games Remaining: \(gamesRemainingArray.count)"
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
                return completedGamesArray.count
            default:
                return gamesRemainingArray.count
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
        var designator = ""
        var result = ""
        
        var isHomeTeam = false
        
        switch(indexPath.section)
        {
            case 0:
                
                scheduleView.rowHeight = CGFloat(65.0)
                
                scheduleArray = completedGamesArray
                
                if(selectedTeamAbbreviation == scheduleArray[indexPath.row].homeTeam)
                {
                    isHomeTeam = true
                }
                
                var scoreString = ""
                
                let homeScore = scheduleArray[indexPath.row].homeScoreTotal
                let awayScore = scheduleArray[indexPath.row].awayScoreTotal
                
                designator = scheduleArray[indexPath.row].homeTeam == selectedTeamAbbreviation ? "vs" : "@"
                
                if(isHomeTeam)
                {
                    result = homeScore > awayScore ? "W" : "L"
                }
                else
                {
                    result = homeScore > awayScore ? "L" : "W"
                }
                
                let numberOfPeriods = scheduleArray[indexPath.row].numberOfPeriods
                
                if(homeScore > awayScore)
                {
                    scoreString = "\(result)" + " " + "\(homeScore)" + "-" + "\(awayScore)"
                }
                else
                {
                    scoreString = "\(result)" + " " + "\(awayScore)" + "-" + "\(homeScore)"
                }
                
                if(numberOfPeriods == 4)
                {
                    scoreString = scoreString + " OT"
                }
                else if(numberOfPeriods == 5)
                {
                    scoreString = scoreString + " SO"
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "completedScheduleViewCell", for: indexPath) as! CompletedScheduleViewCell
                cell.selectionStyle = .none
                cell.delegate = self
            
                cell.date.text = scheduleArray[indexPath.row].date
                cell.opponent.text = isHomeTeam ?
                    designator + " " + TeamManager.getTeamCityName(scheduleArray[indexPath.row].awayTeam) : designator + " " + TeamManager.getTeamCityName(scheduleArray[indexPath.row].homeTeam)
                cell.result.text = scoreString
            
                return cell
           
            default:
            
                scheduleView.rowHeight = CGFloat(65.0)
                
                scheduleArray = gamesRemainingArray
                
                if(selectedTeamAbbreviation == scheduleArray[indexPath.row].homeTeam)
                {
                    isHomeTeam = true
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "futureScheduleViewCell", for: indexPath) as! FutureScheduleViewCell
                cell.selectionStyle = .none
                
                designator = scheduleArray[indexPath.row].homeTeam == selectedTeamAbbreviation ? "vs" : "@"
                
                cell.date.text = scheduleArray[indexPath.row].date
                cell.opponent.text = isHomeTeam ?
                    designator + " " + TeamManager.getTeamCityName(scheduleArray[indexPath.row].awayTeam) : designator + " " + TeamManager.getTeamCityName(scheduleArray[indexPath.row].homeTeam)
                cell.time.text = scheduleArray[indexPath.row].time
            
                return cell
        }
    }
    
    func completedScheduleViewCellDidTapGameLog(_ sender: CompletedScheduleViewCell)
    {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        
        databaseManager.displayGameLog(completedGamesViewController, completedGamesArray[tappedIndexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let displayGameLogViewController = segue.destination as! DisplayGameLogViewController
            
        displayGameLogViewController.gameLogResult = sender as? NHLGameLog
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func loadArrays()
    {
        if let schedules = teamSchedules
        {
            completedGamesArray = schedules.filter({$0.playedStatus  == PlayedStatusEnum.completed.rawValue})
            gamesRemainingArray = schedules.filter({$0.playedStatus  != PlayedStatusEnum.completed.rawValue})
        }
    }
}
