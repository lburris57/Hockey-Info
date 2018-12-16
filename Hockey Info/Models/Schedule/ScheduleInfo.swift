//
//  ScheduleInfo.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/1/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

struct ScheduleInfo: Decodable
{
    var id: Int = 0
    var startTime: String
    var venueAllegiance: String
    var scheduleStatus: String
    var playedStatus: String
    var awayTeamInfo: TeamData
    var homeTeamInfo: TeamData
    var venueInfo: VenueData
    
    private enum CodingKeys : String, CodingKey
    {
        case id = "id"
        case startTime = "startTime"
        case venueAllegiance = "venueAllegiance"
        case scheduleStatus = "scheduleStatus"
        case playedStatus = "playedStatus"
        case awayTeamInfo = "awayTeam"
        case homeTeamInfo = "homeTeam"
        case venueInfo = "venue"
    }
}
