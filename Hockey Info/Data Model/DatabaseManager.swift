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
    func displayPlayerInfo(_ viewController: MainTableViewController, _ id: String) -> NHLPlayer?
    {
        let playerResult = realm.objects(NHLPlayer.self).filter("id =='4264'").first
        
        return playerResult
        
//        DispatchQueue.main.async
//        {
//            viewController.performSegue(withIdentifier: "displayPlayer", sender: playerResult)
//        }
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
            viewController.performSegue(withIdentifier: "displayTeams", sender: teamResult)
        }
    }
    
    //  Create the displayRoster method
    func displayTeams(_ viewController: MainTableViewController, _ teamId: String)
    {
        let teamResult = realm.objects(NHLPlayer.self)
        
        DispatchQueue.main.async
            {
                viewController.performSegue(withIdentifier: "displayRoster", sender: teamResult)
        }
    }
    
    func scheduleRequiresSaving() -> Bool
    {
        var result = false
        
        do
        {
            try realm.write
            {
                if realm.objects(NHLSchedule.self).count == 0
                {
                    result = true
                }
            }
        }
        catch
        {
            print("Error retrieving schedule count!")
        }
        
        return result
    }
    
    func teamStandingsRequiresSaving() -> Bool
    {
        var result = false
        
        do
        {
            try realm.write
            {
                if realm.objects(TeamStandings.self).count == 0
                {
                    result = true
                }
            }
        }
        catch
        {
            print("Error retrieving team standings count!")
        }
        
        return result
    }
    
    func teamRosterRequiresSaving() -> Bool
    {
        var result = false
        
        do
        {
            try realm.write
            {
                if realm.objects(NHLPlayer.self).count == 0
                {
                    result = true
                }
            }
        }
        catch
        {
            print("Error retrieving players count!")
        }
        
        return result
    }
}
