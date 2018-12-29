//
//  GameReference.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/28/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct GameReference: Decodable
{
    var id: Int
    var startTime: String
    var awayTeam: TeamData
    var homeTeam: TeamData
    var playedStatus: String
    
    private enum CodingKeys : String, CodingKey
    {
        case id = "id"
        case startTime = "startTime"
        case awayTeam = "awayTeam"
        case homeTeam = "homeTeam"
        case playedStatus = "playedStatus"
    }
}
