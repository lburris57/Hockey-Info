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
    var scheduleInfoList: [ScheduleInfo]
    var scoreInfoList: [ScoreInfo]
    
    private enum CodingKeys : String, CodingKey
    {
        case scheduleInfoList = "schedule"
        case scoreInfoList = "score"
    }
}
