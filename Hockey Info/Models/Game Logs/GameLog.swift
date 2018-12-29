//
//  GameLog.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/28/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct GameLog: Decodable
{
    var lastUpdatedOn: String
    var gameLogDataList: [GameLogData]
    
    private enum CodingKeys : String, CodingKey
    {
        case lastUpdatedOn = "lastUpdatedOn"
        case gameLogDataList = "gamelogs"
    }
}
