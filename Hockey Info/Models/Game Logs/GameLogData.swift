//
//  GameLogData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/28/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct GameLogData: Decodable
{
    var game: GameData
    var team: [TeamData]
    var stats: [StatsData]
    
    private enum CodingKeys : String, CodingKey
    {
        case game = "game"
        case team = "team"
        case stats = "stats"
    }
}
