//
//  CompletedGamesViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/11/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift
import SVProgressHUD

class CompletedGamesViewController: UITableViewController, CompletedScheduleViewCellDelegate
{
    @IBOutlet weak var completeScheduleView: UITableView!
    
    var completedGamesArray = [NHLSchedule]()
    
    var selectedTeamName = ""
    var selectedTeamAbbreviation = ""
    
    var selectedGameId = 0
    
    let progressBar = TYProgressBar()
    
    var timer: Timer!
    var counter: Double = 0.0
    
    let databaseManager = DatabaseManager()
    let networkManager = NetworkManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let displayTeamInfoTabBarViewController = self.tabBarController  as! DisplayTeamInfoTabBarViewController
        
        completedGamesArray = displayTeamInfoTabBarViewController.completedGamesArray
        
        selectedTeamName = displayTeamInfoTabBarViewController.selectedTeamName
        selectedTeamAbbreviation = displayTeamInfoTabBarViewController.selectedTeamAbbreviation

        let myNib = UINib(nibName: "CompletedScheduleViewCell", bundle: Bundle.main)
        completeScheduleView.register(myNib, forCellReuseIdentifier: "completedScheduleViewCell")
    }
    
    func setupProgressBar()
    {
        progressBar.frame = CGRect(x: 0, y: 0, width: 220, height: 220)
        progressBar.center = view.center
        progressBar.gradients = [#colorLiteral(red: 0.6862745098, green: 0.3215686275, blue: 0.8705882353, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        progressBar.lineDashPattern = [4, 2]
        progressBar.textColor = .purple
        progressBar.lineHeight = 10
        progressBar.isHidden = true
        self.view.addSubview(progressBar)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return completedGamesArray.count
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
        return "Completed Games for \(selectedTeamName): \(completedGamesArray.count)"
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
        var result = ""
        
        var isHomeTeam = false
        
            completeScheduleView.rowHeight = CGFloat(65.0)
            
            if(selectedTeamAbbreviation == completedGamesArray[indexPath.row].homeTeam)
            {
                isHomeTeam = true
            }
            
            var scoreString = ""
            
            let homeScore = completedGamesArray[indexPath.row].homeScoreTotal
            let awayScore = completedGamesArray[indexPath.row].awayScoreTotal
            
            designator = completedGamesArray[indexPath.row].homeTeam == selectedTeamAbbreviation ? "vs" : "@"
            
            if(isHomeTeam)
            {
                result = homeScore > awayScore ? "W" : "L"
            }
            else
            {
                result = homeScore > awayScore ? "L" : "W"
            }
            
            let numberOfPeriods = completedGamesArray[indexPath.row].numberOfPeriods
            
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
            
            cell.date.text = completedGamesArray[indexPath.row].date
            cell.opponent.text = isHomeTeam ?
                designator + " " + TeamManager.getTeamCityName(completedGamesArray[indexPath.row].awayTeam) : designator + " " + TeamManager.getTeamCityName(completedGamesArray[indexPath.row].homeTeam)
            cell.result.text = scoreString
            
            return cell
        }
    
    func completedScheduleViewCellDidTapGameLog(_ sender: CompletedScheduleViewCell)
    {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        
        selectedGameId = completedGamesArray[tappedIndexPath.row].id
        
        networkManager.saveScoringSummary(forGameId: selectedGameId)
        
        //displayTimer()
        
        SVProgressHUD.show(withStatus: "Loading...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
        {
            self.databaseManager.displayGameLog(self, self.selectedGameId)
            SVProgressHUD.dismiss()
        }
    }
    
    @objc func displayTimer()
    {
        progressBar.isHidden = false
        
        progressBar.progress = 0
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ticker), userInfo: nil, repeats: true)
    }
    
    @objc func ticker()
    {
        if counter > 1
        {
            timer.invalidate()
            counter = 0
            return
        }
        
        counter += 0.10
        
        progressBar.progress = counter
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let displayGameLogViewController = segue.destination as! DisplayGameLogViewController
        
        print("Selected game id in prepare for segue is \(selectedGameId)")
        
        displayGameLogViewController.gameLogResult = sender as? NHLGameLog
        
        displayGameLogViewController.selectedGameId = selectedGameId
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
