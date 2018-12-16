//
//  StandingsCategory.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct StandingsCategory: Decodable
{
    var category: String
    var fullName: String
    var description: String
    var abbreviation: String
    var type: String
    
    private enum CodingKeys : String, CodingKey
    {
        case category = "category"
        case fullName = "fullName"
        case description = "description"
        case abbreviation = "abbreviation"
        case type = "type"
    }
}
