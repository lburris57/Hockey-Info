//
//  Standings.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct Standings: Decodable
{
    var lastUpdatedOn: Date
    var referenceList: [StandingsReferenceData]?
    var teamList: [TeamStandingsData]?
    
    private enum CodingKeys : String, CodingKey
    {
        case lastUpdatedOn = "lastUpdatedOn"
        case referenceList = "references"
        case teamList = "teams"
    }
}