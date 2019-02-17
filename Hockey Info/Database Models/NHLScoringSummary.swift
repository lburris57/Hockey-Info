//
//  NHLScoringSummary.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/20/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift

class NHLScoringSummary: Object
{
    @objc dynamic var id : Int = 0
    @objc dynamic var gameId : Int = 0
    @objc dynamic var playedStatus : String = ""
    @objc dynamic var homeTeamAbbreviation : String = ""
    @objc dynamic var awayTeamAbbreviation : String = ""
    @objc dynamic var homeScoreTotal : Int = 0
    @objc dynamic var awayScoreTotal : Int = 0
    @objc dynamic var numberOfPeriods : Int = 0
    @objc dynamic var dateCreated: String = ""

    var periodScoringList = List<NHLPeriodScoringData>()
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
}
