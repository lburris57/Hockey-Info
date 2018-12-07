//
//  RosterPlayers.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct RosterPlayers: Decodable
{
    var lastUpdatedOn: String
    var playerInfoList: [PlayerInfo]
    
    private enum CodingKeys : String, CodingKey
    {
        case lastUpdatedOn = "lastUpdatedOn"
        case playerInfoList = "players"
    }
}
