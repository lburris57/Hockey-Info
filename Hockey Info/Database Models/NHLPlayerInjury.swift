//
//  NHLPlayerInjury.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/31/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift

class NHLPlayerInjury : Object
{
    @objc dynamic var id : Int = 0
    @objc dynamic var teamId : Int = 0
    @objc dynamic var teamAbbreviation : String = ""
    @objc dynamic var firstName : String = ""
    @objc dynamic var lastName : String = ""
    @objc dynamic var position : String = ""
    @objc dynamic var jerseyNumber : String = ""
    @objc dynamic var injuryDescription : String = ""
    @objc dynamic var playingProbablity : String = ""
    @objc dynamic var dateCreated: String = ""
    
    var parentPlayer = LinkingObjects(fromType: NHLPlayer.self, property: "playerInjuries")
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
}
