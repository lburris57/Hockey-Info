//
//  DisplayStandingsTabViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/11/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DisplayStandingsTabViewController: UITabBarController
{
    var teamStandingsResults: Results<TeamStandings>?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}
