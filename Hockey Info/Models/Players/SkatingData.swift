//
//  SkatingData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/26/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct SkatingData: Decodable
{
    var plusMinus: Int?
    var shots: Int?
    var shotPercentage: Double?
    var blockedShots: Int?
    var hits: Int?
    var faceoffs: Int?
    var faceoffWins: Int?
    var faceoffLosses: Int?
    var faceoffPercent: Double?
    
    private enum CodingKeys : String, CodingKey
    {
        case plusMinus = "plusMinus"
        case shots = "shots"
        case shotPercentage = "shotPercentage"
        case blockedShots = "blockedShots"
        case hits = "hits"
        case faceoffs = "faceoffs"
        case faceoffWins = "faceoffWins"
        case faceoffLosses = "faceoffLosses"
        case faceoffPercent = "faceoffPercent"
    }
}
