//
//  NHLGameLog.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/28/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift

class NHLGameLog: Object
{
    @objc dynamic var id : Int = 0
    @objc dynamic var date : String = ""
    @objc dynamic var time : String = ""
    @objc dynamic var homeTeamId : Int = 0
    @objc dynamic var awayTeamId : Int = 0
    @objc dynamic var homeTeamAbbreviation : String = ""
    @objc dynamic var awayTeamAbbreviation : String = ""
    @objc dynamic var playedStatus : String = ""
    @objc dynamic var homeWins : Int = 0
    @objc dynamic var homeLosses : Int = 0
    @objc dynamic var homeOvertimeWins : Int = 0
    @objc dynamic var homeOvertimeLosses : Int = 0
    @objc dynamic var homePoints : Int = 0
    @objc dynamic var homeFaceoffWins : Int = 0
    @objc dynamic var homeFaceoffLosses : Int = 0
    @objc dynamic var homeFaceoffPercent : Double = 0.0
    @objc dynamic var homePowerplays: Int = 0
    @objc dynamic var homePowerplayGoals: Int = 0
    @objc dynamic var homePowerplayPercent: Double = 0.0
    @objc dynamic var homePenaltyKills: Int = 0
    @objc dynamic var homePenaltyKillGoalsAllowed: Int = 0
    @objc dynamic var homePenaltyKillPercent: Double = 0.0
    @objc dynamic var homeGoalsFor: Int = 0
    @objc dynamic var homeGoalsAgainst: Int = 0
    @objc dynamic var homeShots: Int = 0
    @objc dynamic var homePenalties: Int = 0
    @objc dynamic var homePenaltyMinutes: Int = 0
    @objc dynamic var homeHits: Int = 0
    @objc dynamic var awayWins : Int = 0
    @objc dynamic var awayLosses : Int = 0
    @objc dynamic var awayOvertimeWins : Int = 0
    @objc dynamic var awayOvertimeLosses : Int = 0
    @objc dynamic var awayPoints : Int = 0
    @objc dynamic var awayFaceoffWins : Int = 0
    @objc dynamic var awayFaceoffLosses : Int = 0
    @objc dynamic var awayFaceoffPercent : Double = 0.0
    @objc dynamic var awayPowerplays: Int = 0
    @objc dynamic var awayPowerplayGoals: Int = 0
    @objc dynamic var awayPowerplayPercent: Double = 0.0
    @objc dynamic var awayPenaltyKills: Int = 0
    @objc dynamic var awayPenaltyKillGoalsAllowed: Int = 0
    @objc dynamic var awayPenaltyKillPercent: Double = 0.0
    @objc dynamic var awayGoalsFor: Int = 0
    @objc dynamic var awayGoalsAgainst: Int = 0
    @objc dynamic var awayShots: Int = 0
    @objc dynamic var awayPenalties: Int = 0
    @objc dynamic var awayPenaltyMinutes: Int = 0
    @objc dynamic var awayHits: Int = 0
    @objc dynamic var lastUpdatedOn: String = ""
    @objc dynamic var dateCreated: String = ""
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
}
