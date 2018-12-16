//
//  PeriodInfo.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct PeriodInfo: Decodable
{
    var periodNumber: Int = 0
    var awayScore: Int = 0
    var awayShots: Int = 0
    var homeScore: Int = 0
    var homeShots: Int = 0
    
    private enum CodingKeys : String, CodingKey
    {
        case periodNumber = "periodNumber"
        case awayScore = "awayScore"
        case awayShots = "awayShots"
        case homeScore = "homeScore"
        case homeShots = "homeShots"
    }
}
