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
    var periodSummary: PeriodSummary?
    var isUnplayed: Bool = false
    var isInProgress: Bool = false
    var isCompleted: Bool = false
    var awayScore: UInt = 0
    var awayShots: UInt = 0
    var homeScore: UInt = 0
    var homeShots: UInt = 0
    var currentPeriod: String = ""
    var currentPeriodSecondsRemaining = 0
    var currentPeriodSecondsRemainingString: String = ""
}

extension GameScore
{
    
}
