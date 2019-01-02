//
//  PlayerInjuryInfo.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/31/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct PlayerInjuryInfo: Decodable
{
    var id: Int = 0
    var firstName: String
    var lastName: String
    var position: String?
    var jerseyNumber: Int?
    var currentTeamInfo: CurrentTeamData?
    var currentInjuryInfo: CurrentInjuryData?
    
    private enum CodingKeys : String, CodingKey
    {
        case id = "id"
        case firstName = "firstName"
        case lastName = "lastName"
        case position = "position"
        case jerseyNumber = "jerseyNumber"
        case currentTeamInfo = "currentTeam"
        case currentInjuryInfo = "currentInjury"
    }
}
