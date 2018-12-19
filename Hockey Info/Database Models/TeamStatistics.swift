//
//  TeamStatistics.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/17/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift

class TeamStatistics : Object
{
    @objc dynamic var id : Int = 0
    @objc dynamic var abbreviation : String = ""
    @objc dynamic var gamesPlayed: Int = 0
    @objc dynamic var wins: Int = 0
    @objc dynamic var losses: Int = 0
    @objc dynamic var overtimeWins: Int = 0
    @objc dynamic var overtimeLosses: Int = 0
    @objc dynamic var points: Int = 0
    @objc dynamic var powerplays: Int = 0
    @objc dynamic var powerplayGoals: Int = 0
    @objc dynamic var powerplayPercent: Double = 0.0
    @objc dynamic var penaltyKills: Int = 0
    @objc dynamic var penaltyKillGoalsAllowed: Int = 0
    @objc dynamic var penaltyKillPercent: Double = 0.0
    @objc dynamic var goalsFor: Int = 0
    @objc dynamic var goalsAgainst: Int = 0
    @objc dynamic var shots: Int = 0
    @objc dynamic var penalties: Int = 0
    @objc dynamic var penaltyMinutes: Int = 0
    @objc dynamic var hits: Int = 0
    @objc dynamic var faceoffWins: Int = 0
    @objc dynamic var faceoffLosses: Int = 0
    @objc dynamic var faceoffPercent: Double = 0.0
    @objc dynamic var dateCreated: String = ""
    
    var parentTeam = LinkingObjects(fromType: NHLTeam.self, property: "statistics")
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
}
