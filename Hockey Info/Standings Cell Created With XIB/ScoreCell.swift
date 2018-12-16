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
    
    var scheduledGame :ScheduledGame!
    {
        didSet
        {
            if let remainingTime = scheduledGame.scoreInfo.currentPeriodSecondsRemaining
            {
                timeRemaining.text = TimeAndDateUtils.getCurrentTimeRemainingString(remainingTime)
            }
            
            if scheduledGame.scheduleInfo.playedStatus == PlayedStatusEnum.unplayed.rawValue
            {
                period.text = TimeAndDateUtils.getTime(scheduledGame.scheduleInfo.startTime)
            }
            else if(scheduledGame.scheduleInfo.playedStatus == PlayedStatusEnum.completed.rawValue)
            {
                if let periodList = scheduledGame.scoreInfo.periodList
                {
                    period.text = ConversionUtils.retrievePlayedStatusFromNumberOfPeriods(periodList.count)
                }
            }
            
            visitingTeamLogo.image = UIImage(named: scheduledGame.scheduleInfo.awayTeamInfo.abbreviation)
            
            visitingTeamName.text = TeamManager.getFullTeamName(scheduledGame.scheduleInfo.awayTeamInfo.abbreviation)
            
            if let awayScore = scheduledGame.scoreInfo.awayScoreTotal
            {
                visitingTeamScore.text = String(awayScore)
            }
            
            homeTeamLogo.image = UIImage(named: scheduledGame.scheduleInfo.homeTeamInfo.abbreviation)
            
            homeTeamName.text = TeamManager.getFullTeamName(scheduledGame.scheduleInfo.homeTeamInfo.abbreviation)
            
            if let homeScore = scheduledGame.scoreInfo.awayScoreTotal
            {
                homeTeamScore.text = String(homeScore)
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
