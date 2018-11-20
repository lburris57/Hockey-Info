//
//  Game.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/18/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//

import Foundation

struct Game
{
    var ID: UInt? = nil
    var date: String? = nil
    var time: String? = nil
    var location: String? = nil
    var homeTeam: Team? = nil
    var awayTeam: Team? = nil
    var gameScore: GameScore? = nil
}
