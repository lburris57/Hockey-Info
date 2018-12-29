//
//  GameData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/28/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct GameData: Decodable
{
    var id: Int
    var startTime: String
    var awayTeamAbbreviation: String
    var homeTeamAbbreviation: String
    
    private enum CodingKeys : String, CodingKey
    {
        case id = "id"
        case startTime = "startTime"
        case awayTeamAbbreviation = "awayTeamAbbreviation"
        case homeTeamAbbreviation = "homeTeamAbbreviation"
    }
}
