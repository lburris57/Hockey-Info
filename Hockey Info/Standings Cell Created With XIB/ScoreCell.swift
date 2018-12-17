//
//  ScoreCell.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/15/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit

class ScoreCell: UITableViewCell
{
    static let reusableIdentifier = "scoreCell"
    
    @IBOutlet weak var timeRemaining: UITextField!
    @IBOutlet weak var visitingTeamLogo: UIImageView!
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var visitingTeamName: UITextField!
    @IBOutlet weak var visitingTeamRecord: UITextField!
    @IBOutlet weak var homeTeamName: UITextField!
    @IBOutlet weak var homeTeamRecord: UITextField!
    @IBOutlet weak var visitingTeamScore: UITextField!
    @IBOutlet weak var homeTeamScore: UITextField!
    @IBOutlet weak var period: UITextField!
    
    var records = [String:String]()
    
    let databaseManager = DatabaseManager()
    
    var scheduledGame: NHLSchedule!
    {
        didSet
        {
            if records.count == 0
            {
                records = databaseManager.loadTeamRecords()
            }
            
            let remainingTime = scheduledGame.currentTimeRemaining
                
            if(remainingTime > 0)
            {
                timeRemaining.text = TimeAndDateUtils.getCurrentTimeRemainingString(remainingTime)
            }
            
            if scheduledGame.playedStatus == PlayedStatusEnum.unplayed.rawValue
            {
                period.text = scheduledGame.time
                timeRemaining.text = ""
            }
            else if(scheduledGame.playedStatus == PlayedStatusEnum.completed.rawValue)
            {
                if scheduledGame.numberOfPeriods > 0
                {
                    period.text = ConversionUtils.retrievePlayedStatusFromNumberOfPeriods(scheduledGame.numberOfPeriods)
                    timeRemaining.text = ""
                }
            }
            else if(scheduledGame.playedStatus == PlayedStatusEnum.inProgress.rawValue)
            {
                let currentPeriod = scheduledGame.currentPeriod
                
                switch (currentPeriod)
                {
                    case 1: period.text = String(currentPeriod) + "st"
                    
                    case 2: period.text = String(currentPeriod) + "nd"
                    
                    case 3: period.text = String(currentPeriod) + "rd"
                    
                    default: period.text = ""
                }
            }
            
            visitingTeamLogo.image = UIImage(named: scheduledGame.awayTeam)
            visitingTeamName.text = TeamManager.getFullTeamName(scheduledGame.awayTeam)
            visitingTeamScore.text = String(scheduledGame.awayScoreTotal)
            visitingTeamRecord.text = records[scheduledGame.awayTeam]
            
            homeTeamLogo.image = UIImage(named: scheduledGame.homeTeam)
            homeTeamName.text = TeamManager.getFullTeamName(scheduledGame.homeTeam)
            homeTeamScore.text = String(scheduledGame.homeScoreTotal)
            homeTeamRecord.text = records[scheduledGame.homeTeam]
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
