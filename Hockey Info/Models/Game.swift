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
    var ID: UInt = 0
    var date: String = ""
    var time: String = ""
    var location: String = ""
    var homeTeam: TeamInfo?
    var awayTeam: TeamInfo?
    var gameScore: GameScore?
}
