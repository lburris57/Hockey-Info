//
//  PlayerStatId.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/27/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct PlayerStatId: Decodable
{
    var id: Int?
    var firstName: String?
    var lastName: String?
    var currentTeam: CurrentTeamData?
    
    private enum CodingKeys : String, CodingKey
    {
        case id = "id"
        case firstName = "firstName"
        case lastName = "lastName"
        case currentTeam = "currentTeam"
    }
}
