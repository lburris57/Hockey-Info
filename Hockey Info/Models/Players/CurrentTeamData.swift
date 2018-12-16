//
//  CurrentTeamData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct CurrentTeamData: Decodable
{
    var id: Int = 0
    var abbreviation: String
}

private enum CodingKeys : String, CodingKey
{
    case id = "id"
    case abbreviation = "abbreviation"
}
