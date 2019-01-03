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
    
    let homeTeamAbbreviation = ""
    
    var completedGames = [NHLSchedule]()
    var gamesRemaining = [NHLSchedule]()
    
    var sections = ["", ""]
    
    let databaseManager = DatabaseManager()
    
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
        switch(indexPath.section)
        {
            case 0:
                
                scheduleArray = completedGamesArray
                
                var scoreString = ""
                
                let homeScore = scheduleArray[indexPath.row].homeScoreTotal
                let awayScore = scheduleArray[indexPath.row].awayScoreTotal
                let result = homeScore > awayScore ? "W" : "L"
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
                cell.opponent.text = scheduleArray[indexPath.row].awayTeam
                cell.result.text = scoreString
            
                return cell
           
            default:
            
                scheduleArray = gamesRemainingArray
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "futureScheduleViewCell", for: indexPath) as! FutureScheduleViewCell
                cell.selectionStyle = .none
                
                let designator = scheduleArray[indexPath.row].homeTeam == homeTeamAbbreviation ? "vs" : "@"
                
                cell.date.text = scheduleArray[indexPath.row].date
                cell.opponent.text = designator + " " + scheduleArray[indexPath.row].awayTeam
                cell.time.text = scheduleArray[indexPath.row].time
            
                return cell
        }
    }
    
    func completedScheduleViewCellDidTapGameLog(_ sender: CompletedScheduleViewCell)
    {
        //guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        
        //completedGamesArray[tappedIndexPath.row].id
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func loadArrays()
    {
        if (teamSchedules?.count) != nil
        {
            for teamSchedule in teamSchedules!
            {
                if (teamSchedule.playedStatus == PlayedStatusEnum.completed.rawValue)
                {
                    completedGamesArray.append(teamSchedule)
                }
                else
                {
                    gamesRemainingArray.append(teamSchedule)
                }
            }
        }
    }
}
