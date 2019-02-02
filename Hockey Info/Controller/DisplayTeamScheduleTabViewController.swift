//
//  DisplayTeamScheduleTabViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/11/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DisplayTeamScheduleTabViewController: UITabBarController
{
    var selectedTeamName = ""
    var selectedTeamAbbreviation = ""
    
    var teamScheduleResults: Results<NHLSchedule>?
    
    var completedGamesArray = [NHLSchedule]()
    var gamesRemainingArray = [NHLSchedule]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadTeamArrays()
    }
    
    func loadTeamArrays()
    {
        if let teamSchedules = teamScheduleResults
        {
            completedGamesArray = teamSchedules.filter({$0.playedStatus  == PlayedStatusEnum.completed.rawValue})
            gamesRemainingArray = teamSchedules.filter({$0.playedStatus  != PlayedStatusEnum.completed.rawValue})
        }
    }
}
