//
//  TeamInformation.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct TeamInformation: Decodable
{
    var id: Int = 0
    var city: String
    var name: String
    var abbreviation: String
    var venueInfo: [VenueData]?
    
    private enum CodingKeys : String, CodingKey
    {
        case id = "id"
        case city = "city"
        case name = "name"
        case abbreviation = "abbreviation"
        case venueInfo = "venueInfo"
    }
}
