//
//  DisplayTeamInfoTabBarViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/16/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DisplayTeamInfoTabBarViewController: UITabBarController
{
    var selectedTeamName = ""
    var selectedTeamAbbreviation = ""
    
    var teamResults: Results<NHLTeam>?
    var team = NHLTeam()
    
    var playerArray = [NHLPlayer]()
    var statsArray = [TeamStatistics]()
    var injuryArray = [NHLPlayerInjury]()
    var completedGamesArray = [NHLSchedule]()
    var gamesRemainingArray = [NHLSchedule]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let teams = teamResults
        {
            team = teams[0]
            
            loadArrays(teams)
        }
    }
        
    func loadArrays(_ teams: Results<NHLTeam>)
    {
        //  Load the playerArray
        for player in teams[0].players
        {
            playerArray.append(player)
        }
        
        //  Load the injuryArray
        for injury in teams[0].playerInjuries
        {
            injuryArray.append(injury)
        }
        
        //  Load the statsArray
        for stats in teams[0].statistics
        {
            statsArray.append(stats)
        }
        
        let today = TimeAndDateUtils.getCurrentDateAsString()
        
        //  Load the schedule arrays
        completedGamesArray = teams[0].schedules.filter({$0.playedStatus == PlayedStatusEnum.completed.rawValue && $0.date != today})
        gamesRemainingArray = teams[0].schedules.filter({$0.playedStatus != PlayedStatusEnum.completed.rawValue || $0.date == today})
    }
}
