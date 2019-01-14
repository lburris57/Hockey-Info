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
        if (teamScheduleResults?.count) != nil
        {
            for teamSchedule in teamScheduleResults!
            {
                if (teamSchedule.playedStatus == PlayedStatusEnum.completed.rawValue)
                {
                    completedGamesArray.append(teamSchedule)
                }
                else
                {
                    gamesRemainingArray.append(teamSchedule)
                }
            }
        }
    }
}
