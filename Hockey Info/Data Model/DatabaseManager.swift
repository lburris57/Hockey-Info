//
//  DatabaseManager.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/7/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import RealmSwift

class DatabaseManager
{
    //  Create a new Realm database
    let realm = try! Realm()
    
    //  Create the displayPlayerInfo method
    func displayPlayerInfo(_ viewController: MainTableViewController, _ id: String)
    {
        let playerResult = realm.objects(NHLPlayer.self).filter("id ==\(id)").first
        
        DispatchQueue.main.async
            {
                viewController.performSegue(withIdentifier: "displayPlayer", sender: playerResult)
        }
    }
    
    //  Create the displaySchedule method
    func displaySchedule(_ viewController: MainTableViewController)
    {
        let scheduleResult = realm.objects(NHLSchedule.self)
        
        DispatchQueue.main.async
        {
            viewController.performSegue(withIdentifier: "displaySchedule", sender: scheduleResult)
        }
    }
    
    //  Create the displayTeams method
    func displayTeams(_ viewController: MainTableViewController)
    {
        let teamResult = realm.objects(NHLTeam.self)
        
        DispatchQueue.main.async
        {
            viewController.performSegue(withIdentifier: "displaySchedule", sender: teamResult)
        }
    }
}
