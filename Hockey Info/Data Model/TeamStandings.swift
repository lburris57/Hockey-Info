//
//  TeamStandings.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/7/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift

class TeamStandings: Object
{
    @objc dynamic var id : String = ""
    @objc dynamic var abbreviation : String = ""
    @objc dynamic var conference : String = ""
    @objc dynamic var conferenceRank : Int = 0
    @objc dynamic var division : String = ""
    @objc dynamic var divisionRank : Int = 0
    @objc dynamic var gamesPlayed : Int = 0
    @objc dynamic var wins : Int = 0
    @objc dynamic var losses : Int = 0
    @objc dynamic var overtimeLosses : Int = 0
    @objc dynamic var points : Int = 0
    @objc dynamic var dateCreated: String = ""
}
