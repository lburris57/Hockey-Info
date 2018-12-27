//
//  PlayerStatistics.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/17/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift

class PlayerStatistics : Object
{
    @objc dynamic var id : Int = 0
    @objc dynamic var gamesPlayed: Int = 0
    @objc dynamic var goals: Int = 0
    @objc dynamic var assists: Int = 0
    @objc dynamic var points: Int = 0
    @objc dynamic var hatTricks: Int = 0
    @objc dynamic var powerplayGoals: Int = 0
    @objc dynamic var powerplayAssists: Int = 0
    @objc dynamic var powerplayPoints: Int = 0
    @objc dynamic var shortHandedGoals: Int = 0
    @objc dynamic var shortHandedAssists: Int = 0
    @objc dynamic var shortHandedPoints: Int = 0
    @objc dynamic var gameWinningGoals: Int = 0
    @objc dynamic var gameTyingGoals: Int = 0
    @objc dynamic var plusMinus: Int = 0
    @objc dynamic var shots: Int = 0
    @objc dynamic var shotPercentage: Double = 0.0
    @objc dynamic var blockedShots: Int = 0
    @objc dynamic var hits: Int = 0
    @objc dynamic var faceoffs: Int = 0
    @objc dynamic var faceoffWins: Int = 0
    @objc dynamic var faceoffLosses: Int = 0
    @objc dynamic var faceoffPercent: Double = 0.0
    @objc dynamic var penalties: Int = 0
    @objc dynamic var penaltyMinutes: Int = 0
    @objc dynamic var dateCreated: String = ""
    
    var parentPlayer = LinkingObjects(fromType: NHLPlayer.self, property: "statistics")
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
}
