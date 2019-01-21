//
//  ScoringSummary.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/20/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import Foundation

struct ScoringSummary: Decodable
{
    var lastUpdatedOn: String
    var game: GameReference
    var scoringInfo: ScoringInfo
    
    private enum CodingKeys : String, CodingKey
    {
        case lastUpdatedOn = "lastUpdatedOn"
        case game = "game"
        case scoringInfo = "scoring"
    }
}
