//
//  GoaltendingData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/28/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct GoaltendingData: Decodable
{
    var wins: Int?
    var losses: Int?
    var overtimeWins: Int?
    var overtimeLosses: Int?
    var goalsAgainst: Int?
    var shotsAgainst: Int?
    var saves: Int?
    var goalsAgainstAverage: Double?
    var savePercentage: Double?
    var shutouts: Int?
    var gamesStarted: Int?
    var creditForGame: Int?
    var minutesPlayed: Int?
    
    private enum CodingKeys : String, CodingKey
    {
        case wins = "wins"
        case losses = "losses"
        case overtimeWins = "overtimeWins"
        case overtimeLosses = "overtimeLosses"
        case goalsAgainst = "goalsAgainst"
        case shotsAgainst = "shotsAgainst"
        case saves = "saves"
        case goalsAgainstAverage = "goalsAgainstAverage"
        case savePercentage = "savePercentage"
        case shutouts = "shutouts"
        case gamesStarted = "gamesStarted"
        case creditForGame = "creditForGame"
        case minutesPlayed = "minutesPlayed"
    }
}
