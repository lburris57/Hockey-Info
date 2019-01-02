//
//  PlayerInjuries.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/31/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct PlayerInjuries: Decodable
{
    var lastUpdatedOn: String
    var playerInfoList: [PlayerInjuryInfo]
    
    private enum CodingKeys : String, CodingKey
    {
        case lastUpdatedOn = "lastUpdatedOn"
        case playerInfoList = "players"
    }
}
