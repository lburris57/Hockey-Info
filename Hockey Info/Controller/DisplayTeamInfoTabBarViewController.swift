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
    var segueId = ""
    var teamResults: Results<NHLTeam>?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("Size of teamResults is \(teamResults?.count ?? 0)")
        
        print("Size of teamResults is \(teamResults?.count ?? 0)")
    }
}
