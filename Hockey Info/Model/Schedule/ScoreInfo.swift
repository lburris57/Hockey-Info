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
    var currentPeriod : Int?
    var currentPeriodSecondsRemaining: Int?
    var awayScoreTotal: Int?
    var awayShotsTotal: Int?
    var homeScoreTotal: Int?
    var homeShotsTotal: Int?
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
