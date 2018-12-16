//
//  VenueData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct VenueData: Decodable
{
    var id: Int = 0
    var name: String
    
    private enum CodingKeys : String, CodingKey
    {
        case id = "id"
        case name = "name"
    }
}
