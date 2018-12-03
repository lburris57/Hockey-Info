//
//  NHLTeam.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/20/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift

class NHLTeam : Object
{
    @objc dynamic var id : String = ""
    @objc dynamic var abbreviation : String = ""
    @objc dynamic var cityName : String = ""
    @objc dynamic var dateCreated: Date?
    
    let players = List<NHLPlayer>()
}
