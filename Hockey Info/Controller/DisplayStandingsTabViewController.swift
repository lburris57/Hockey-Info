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
    @IBOutlet weak var tabbar: UITabBar!
    
    var teamStandingsResults: Results<TeamStandings>?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
//    override func viewDidLayoutSubviews()
//    {
//        self.tabbar.frame = CGRect( x: 0, y: 64, width: 420, height: 50)
//    }
}
