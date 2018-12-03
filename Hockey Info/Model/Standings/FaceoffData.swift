//
//  FaceoffData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct FaceoffData: Decodable
{
    var faceoffWins: Int = 0
    var faceoffLosses: Int = 0
    var faceoffPercent: Double = 0.0
    
    private enum CodingKeys : String, CodingKey
    {
        case faceoffWins = "faceoffWins"
        case faceoffLosses = "faceoffLosses"
        case faceoffPercent = "faceoffPercent"
    }
}
