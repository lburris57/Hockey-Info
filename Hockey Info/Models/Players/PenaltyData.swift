//
//  PenaltyData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/26/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct PenaltyData: Decodable
{
    var penalties: Int?
    var penaltyMinutes: Int?
    
    private enum CodingKeys : String, CodingKey
    {
        case penalties = "penalties"
        case penaltyMinutes = "penaltyMinutes"
    }
}
