//
//  DailyGames.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/18/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct GameScore
{
    var periodSummary: PeriodSummary? = nil
    var isUnplayed: Bool? = nil
    var isInProgress: Bool? = nil
    var isCompleted: Bool? = nil
    var awayScore: UInt? = nil
    var awayShots: UInt? = nil
    var homeScore: UInt? = nil
    var homeShots: UInt? = nil
    var currentPeriod: String? = nil
    var currentPeriodSecondsRemaining = 0
}

extension GameScore
{
    func currentTimeRemainingString(_ currentPeriodSecondsRemaining: Int) -> String
    {
        var currentTimeRemainingString = ""
        
        if currentPeriodSecondsRemaining > 0
        {
            if currentPeriodSecondsRemaining >= 60
            {
                let mins = Int(currentPeriodSecondsRemaining / 60)
                let sixtyMins: Int = mins * 60
                let secs = currentPeriodSecondsRemaining - sixtyMins
                
                if(mins < 10)
                {
                    currentTimeRemainingString = "0\(mins):\(secs) Remaining"
                }
                else
                {
                    currentTimeRemainingString = "\(mins):\(secs) Remaining"
                }
            }
            else
            {
                currentTimeRemainingString = "00:\(currentPeriodSecondsRemaining) Remaining"
            }
        }
        else
        {
            return currentTimeRemainingString
        }
        
        return currentTimeRemainingString
    }
}
