//
//  HandednessData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct HandednessData: Decodable
{
    var shoots: String?
    
    private enum CodingKeys : String, CodingKey
    {
        case shoots = "shoots"
    }
}
