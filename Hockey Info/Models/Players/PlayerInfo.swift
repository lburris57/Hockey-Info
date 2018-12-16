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
    var player: PlayerData
    var currentTeamInfo: CurrentTeamData?
    
    private enum CodingKeys : String, CodingKey
    {
        case player = "player"
        case currentTeamInfo = "teamAsOfDate"
    }
}
