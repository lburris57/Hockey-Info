//
//  TeamStats.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct TeamStats: Decodable
{
    var gamesPlayed: Int
    var standingsInfo: [StandingsData]?
    var faceoffInfo: [FaceoffData]?
    var powerplayInfo: [PowerplayData]?
    var miscellaneousInfo: [MiscellaneousData]?
    
    private enum CodingKeys : String, CodingKey
    {
        case gamesPlayed = "gamesPlayed"
        case standingsInfo = "standings"
        case faceoffInfo = "faceoffs"
        case powerplayInfo = "powerplay"
        case miscellaneousInfo = "miscellaneous"
    }
}
