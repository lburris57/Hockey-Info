//
//  MiscellaneousData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct MiscellaneousData: Decodable
{
    var goalsFor: Int = 0
    var goalsAgainst: Int = 0
    var shots: Int = 0
    var penalties: Int = 0
    var penaltyMinutes: Int = 0
    var hits: Int = 0
    
    private enum CodingKeys : String, CodingKey
    {
        case goalsFor = "goalsFor"
        case goalsAgainst = "goalsAgainst"
        case shots = "shots"
        case penalties = "penalties"
        case penaltyMinutes = "penaltyMinutes"
        case hits = "hits"
    }
}
