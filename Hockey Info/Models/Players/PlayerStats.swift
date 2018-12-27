//
//  PlayerStats.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/26/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct PlayerStats: Decodable
{
    var lastUpdatedOn: String?
    var playerStatsTotals: [PlayerStatsTotal]?
    
    private enum CodingKeys : String, CodingKey
    {
        case lastUpdatedOn = "lastUpdatedOn"
        case playerStatsTotals = "playerStatsTotals"
    }
}
