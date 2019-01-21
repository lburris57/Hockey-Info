//
//  ScoringInfo.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/20/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import Foundation

struct ScoringInfo: Decodable
{
    var homeScoreTotal: Int
    var awayScoreTotal: Int
    var periodList: [PeriodScoringData]
    
    private enum CodingKeys : String, CodingKey
    {
        case homeScoreTotal = "homeScoreTotal"
        case awayScoreTotal = "awayScoreTotal"
        case periodList = "periods"
    }
}
