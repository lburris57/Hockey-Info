//
//  TeamStandingsData.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct TeamStandingsData: Decodable
{
    var teamInformation: TeamInformation
    var teamStats: TeamStats
    var overallRankInfo: OverallRankData
    var conferenceRankInfo: ConferenceRankData
    var divisionRankInfo: DivisionRankData
    var playoffRankInfo: PlayoffRankData
    
    private enum CodingKeys : String, CodingKey
    {
        case teamInformation = "team"
        case teamStats = "stats"
        case overallRankInfo = "overallRank"
        case conferenceRankInfo = "conferenceRank"
        case divisionRankInfo = "divisionRank"
        case playoffRankInfo = "playoffRank"
    }
}
