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
    let fullDateFormatter = DateFormatter()
    
    let today = Date()
    
    //  Create a new Realm database
    let realm = try! Realm()
    
    //  Create the displayPlayerInfo method
    func displayPlayerInfo(_ viewController: MainViewController, _ id: String) -> NHLPlayer?
    {
        let playerResult = realm.objects(NHLPlayer.self).filter("id =='4264'").first
        
        return playerResult
        
//        DispatchQueue.main.async
//        {
//            viewController.performSegue(withIdentifier: "displayPlayer", sender: playerResult)
//        }
    }
    
    //  Create the displaySchedule method
    func displaySchedule(_ viewController: MainViewController)
    {
        let scheduleResult = realm.objects(NHLSchedule.self)
        
        DispatchQueue.main.async
        {
            viewController.performSegue(withIdentifier: "displayCalendar", sender: scheduleResult)
        }
    }
    
    //  Create the displayTeams method
    func displayTeams(_ viewController: MainViewController)
    {
        let teamResult = realm.objects(NHLTeam.self)
        
        DispatchQueue.main.async
        {
            viewController.performSegue(withIdentifier: "displayTeams", sender: teamResult)
        }
    }
    
    //  Create the displayRoster method
    func displayTeams(_ viewController: MainViewController, _ teamId: String)
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
    
    func retrieveTodaysGames(_ mainViewController: MainViewController)
    {
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        
        let dateString = fullDateFormatter.string(from: today)
        
        do
        {
            try realm.write
            {
                let scheduledGames = realm.objects(NHLSchedule.self).filter("date = '\(dateString)'")
                
                mainViewController.performSegue(withIdentifier: "displayCalendar", sender: scheduledGames)
            }
        }
        catch
        {
            print("Error retrieving today's games!")
        }
    }
    
    func retrieveGames(_ date: Date) -> [Schedule]
    {
        var schedules = [Schedule]()
        
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        
        let dateString = fullDateFormatter.string(from: date)
        
        do
        {
            try realm.write
            {
                let scheduledGames = realm.objects(NHLSchedule.self).filter("date = '\(dateString)'")
                
                for scheduledGame in scheduledGames
                {
                    let awayTeam = TeamManager.getFullTeamName(scheduledGame.awayTeam)
                    let homeTeam = TeamManager.getFullTeamName(scheduledGame.homeTeam)
                    let venue = TeamManager.getVenueByTeam(scheduledGame.homeTeam)
                    let startTime = scheduledGame.time
                    
                    let schedule = Schedule(title: "\(awayTeam) @ \(homeTeam)",
                        note: "\(venue)",
                        startTime: "\(startTime)",
                        endTime: "\(startTime)",
                        categoryColor: .black)
                    
                    schedules.append(schedule)
                }
            }
        }
        catch
        {
            print("Error retrieving today's games!")
        }
        
        return schedules
    }
}