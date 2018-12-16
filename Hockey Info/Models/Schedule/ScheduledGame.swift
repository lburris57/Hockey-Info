//
//  ScheduledGame.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct ScheduledGame: Decodable
{
    var scheduleInfo: ScheduleInfo
    var scoreInfo: ScoreInfo
    
    private enum CodingKeys : String, CodingKey
    {
        case scheduleInfo = "schedule"
        case scoreInfo = "score"
    }
}
