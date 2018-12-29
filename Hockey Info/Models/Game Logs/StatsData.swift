//
//  StatsData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/28/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct StatsData: Decodable
{
    var standings: StandingsData
    var faceoffs: FaceoffData
    var powerplay: PowerplayData
    var miscellaneous: MiscellaneousData
    
    private enum CodingKeys : String, CodingKey
    {
        case standings = "standings"
        case faceoffs = "faceoffs"
        case powerplay = "powerplay"
        case miscellaneous = "miscellaneous"
    }
}
