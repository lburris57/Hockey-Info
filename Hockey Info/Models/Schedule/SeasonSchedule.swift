//
//  SeasonSchedule.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct SeasonSchedule: Decodable
{
    var lastUpdatedOn: String
    var gameList: [ScheduledGame]
    
    private enum CodingKeys : String, CodingKey
    {
        case lastUpdatedOn = "lastUpdatedOn"
        case gameList = "games"
    }
}
