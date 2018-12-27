//
//  ScoringData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/26/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct ScoringData: Decodable
{
    var goals: Int?
    var assists: Int?
    var points: Int?
    var hatTricks: Int?
    var powerplayGoals: Int?
    var powerplayAssists: Int?
    var powerplayPoints: Int?
    var shorthandedGoals: Int?
    var shorthandedAssists: Int?
    var shorthandedPoints: Int?
    var gameWinningGoals: Int?
    var gameTyingGoals: Int?
    
    private enum CodingKeys : String, CodingKey
    {
        case goals = "goals"
        case assists = "assists"
        case points = "points"
        case hatTricks = "hatTricks"
        case powerplayGoals = "powerplayGoals"
        case powerplayAssists = "powerplayAssists"
        case powerplayPoints = "powerplayPoints"
        case shorthandedGoals = "shorthandedGoals"
        case shorthandedAssists = "shorthandedAssists"
        case shorthandedPoints = "shorthandedPoints"
        case gameWinningGoals = "gameWinningGoals"
        case gameTyingGoals = "gameTyingGoals"
    }
}
