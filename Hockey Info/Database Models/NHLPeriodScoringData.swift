//
//  NHLPeriodScoringData.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/20/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift

class NHLPeriodScoringData: Object
{
    @objc dynamic var id : Int = 0
    @objc dynamic var gameId : Int = 0
    @objc dynamic var periodNumber : Int = 0
    @objc dynamic var teamAbbreviation : String = ""
    @objc dynamic var periodSecondsElapsed: Int = 0
    @objc dynamic var playDescription: String = ""
    @objc dynamic var dateCreated: String = ""
    
    var parentTeam = LinkingObjects(fromType: NHLScoringSummary.self, property: "periodScoringList")
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
}
