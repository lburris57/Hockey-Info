//
//  PeriodScoringData.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/20/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import Foundation

struct PeriodScoringData: Decodable
{
    var periodNumber: Int
    var homeScore: Int
    var awayScore: Int
    var scoringPlays: [ScoringPlay]
    
    private enum CodingKeys : String, CodingKey
    {
        case periodNumber = "periodNumber"
        case homeScore = "homeScore"
        case awayScore = "awayScore"
        case scoringPlays = "scoringPlays"
    }
}
