//
//  ScoreInfo.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct ScoreInfo: Decodable
{
    var currentPeriod : Int = 0
    var currentPeriodSecondsRemaining: Int = 0
    var awayScoreTotal: Int = 0
    var awayShotsTotal: Int = 0
    var homeScoreTotal: Int = 0
    var homeShotsTotal: Int = 0
    
    var periodList: [PeriodInfo]?
    
    private enum CodingKeys : String, CodingKey
    {
        case currentPeriod = "currentPeriod"
        case currentPeriodSecondsRemaining = "currentPeriodSecondsRemaining"
        case awayScoreTotal = "awayScoreTotal"
        case awayShotsTotal = "awayShotsTotal"
        case homeScoreTotal = "homeScoreTotal"
        case homeShotsTotal = "homeShotsTotal"
        
        case periodList = "periods"
    }
}
