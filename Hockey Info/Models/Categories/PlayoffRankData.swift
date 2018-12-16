//
//  PlayoffRankData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct PlayoffRankData: Decodable
{
    var conferenceName: String
    var divisionName: String?
    var appliesTo: String
    var rank: Int = 0
    
    private enum CodingKeys : String, CodingKey
    {
        case conferenceName = "conferenceName"
        case divisionName = "divisionName"
        case appliesTo = "appliesTo"
        case rank = "rank"
    }
}
