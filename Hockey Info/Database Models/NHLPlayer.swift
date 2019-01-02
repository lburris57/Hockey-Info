//
//  NHLPlayer.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/20/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift

class NHLPlayer : Object
{
    @objc dynamic var id : Int = 0
    @objc dynamic var teamId : Int = 0
    @objc dynamic var teamAbbreviation : String = ""
    @objc dynamic var firstName : String = ""
    @objc dynamic var lastName : String = ""
    @objc dynamic var position : String = ""
    @objc dynamic var jerseyNumber : String = ""
    @objc dynamic var height : String = ""
    @objc dynamic var weight : String = ""
    @objc dynamic var birthDate : String = ""
    @objc dynamic var age : String = ""
    @objc dynamic var birthCity : String = ""
    @objc dynamic var birthCountry : String = ""
    @objc dynamic var imageURL : String = ""
    @objc dynamic var shoots : String = ""
    @objc dynamic var dateCreated: String = ""
    
    var playerStatisticsList = List<PlayerStatistics>()
    var playerInjuries = List<NHLPlayerInjury>()
    
    var parentTeam = LinkingObjects(fromType: NHLTeam.self, property: "players")
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
}
