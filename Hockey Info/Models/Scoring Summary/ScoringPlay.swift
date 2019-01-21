//
//  ScoringPlay.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/20/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import Foundation

struct ScoringPlay: Decodable
{
    var team: TeamData
    var periodSecondsElapsed: Int
    var playDescription: String
    
    private enum CodingKeys : String, CodingKey
    {
        case team = "team"
        case periodSecondsElapsed = "periodSecondsElapsed"
        case playDescription = "playDescription"
    }
}
