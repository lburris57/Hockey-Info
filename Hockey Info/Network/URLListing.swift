//
//  URLListing.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/23/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

enum URLListing: String
{
    case retrieveGameScorePrefix = "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/date/"
    case retrieveGameScoreSuffix = "/games.json"
    case retrieveSeasonSchedule = ""
    case retrieveAllPlayers = "a"
    case retrievePlayersByTeamIdPrefix = "b"
    case retrievePlayersByTeamIdSuffix = "c"
    case retrieveStandings = "https://api.mysportsfeeds.com/v2.0/pull/nhl/2018-2019-regular/standings.json"
    case retrievePlayerStatsPrefix = "d"
    case retrievePlayerStatsSuffix = "e"
}

