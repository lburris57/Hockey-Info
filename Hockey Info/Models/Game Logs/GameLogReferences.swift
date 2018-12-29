//
//  GameLogReferences.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/28/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct GameLogReferences: Decodable
{
    var gameReferences: [GameReference]
    
    private enum CodingKeys : String, CodingKey
    {
        case gameReferences = "gameReferences"
    }
}
