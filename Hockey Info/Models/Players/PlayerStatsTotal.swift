//
//  PlayerStatsTotal.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/26/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct PlayerStatsTotal: Decodable
{
    var playerStats: PlayerStatData?
    
    private enum CodingKeys : String, CodingKey
    {
        case playerStats = "stats"
    }
}
