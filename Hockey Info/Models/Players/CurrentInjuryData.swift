//
//  CurrentInjuryData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct CurrentInjuryData: Decodable
{
    var description: String
    var playingProbability: String
    
    private enum CodingKeys : String, CodingKey
    {
        case description = "description"
        case playingProbability = "playingProbability"
    }
}
