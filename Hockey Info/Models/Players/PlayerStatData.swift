//
//  PlayerStatData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/26/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct PlayerStatData: Decodable
{
    var gamesPlayed: Int?
    var scoringData: ScoringData?
    var skatingData: SkatingData?
    var goaltendingData: GoaltendingData?
    var penaltyData: PenaltyData?
    
    private enum CodingKeys : String, CodingKey
    {
        case gamesPlayed = "gamesPlayed"
        case scoringData = "scoring"
        case skatingData = "skating"
        case goaltendingData = "goaltending"
        case penaltyData = "penalties"
    }
}
