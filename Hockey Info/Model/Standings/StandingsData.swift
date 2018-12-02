//
//  StandingsData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct StandingsData: Decodable
{
    var wins: Int = 0
    var losses: Int = 0
    var overtimeWins: Int = 0
    var overtimeLosses: Int = 0
    var points: Int = 0
    
    private enum CodingKeys : String, CodingKey
    {
        case wins = "wins"
        case losses = "losses"
        case overtimeWins = "overtimeWins"
        case overtimeLosses = "overtimeLosses"
        case points = "points"
    }
}
