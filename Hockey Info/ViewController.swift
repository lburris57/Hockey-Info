//
//  ViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/14/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var scoreView: UITableView!
    
    var timesRemaining = ["12:42", "09:47"]
    var visitingTeamNames = ["BLUE JACKETS", "OILERS"]
    var visitingTeamRecords = ["44-17-10", "47-14-10"]
    var homeTeamNames = ["CAPITALS", "FLAMES"]
    var homeTeamRecords = ["47-14-10", "44-17-10"]
    var visitingTeamScores = ["2", "1"]
    var homeTeamScores = ["5", "2"]
    var periods = ["3", "2"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scoreView.frame.origin.x = view.safeAreaInsets.left
        scoreView.frame.origin.y = view.safeAreaInsets.top
        scoreView.frame.size.width = view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right
        scoreView.frame.size.height = 300
        
        scoreView.dataSource = self
        scoreView.delegate = self
        
        let nib = UINib(nibName: "ScoreCell", bundle: nil)
        scoreView.register(nib, forCellReuseIdentifier: "scoreCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return timesRemaining.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as! ScoreCell
        
        scoreView.rowHeight = CGFloat(130.0)
        
        cell.timeRemaining.text = timesRemaining[indexPath.row] + " remaining"
        cell.visitingTeamName.text = visitingTeamNames[indexPath.row]
        cell.visitingTeamRecord.text = visitingTeamRecords[indexPath.row]
        cell.homeTeamName.text = homeTeamNames[indexPath.row]
        cell.homeTeamRecord.text = homeTeamRecords[indexPath.row]
        cell.visitingTeamScore.text = visitingTeamScores[indexPath.row]
        cell.homeTeamScore.text = homeTeamScores[indexPath.row]
        cell.period.text = periods[indexPath.row]
        
        return cell
    }
}

