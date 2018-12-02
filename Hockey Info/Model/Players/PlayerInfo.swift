//
//  PlayerInfo.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct PlayerInfo: Decodable
{
    var playerList: [PlayerData]?
    var currentTeamInfo: [CurrentTeamData]?
    
    private enum CodingKeys : String, CodingKey
    {
        case playerList = "player"
        case currentTeamInfo = "teamAsOfDate"
    }
}
