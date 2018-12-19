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
    
    //  Create the displayPlayer method
    func displayPlayer(_ viewController: DisplayRosterViewController, _ id: Int)
    {
        var playerResult: NHLPlayer?
        
        do
        {
            try realm.write
            {
                playerResult = realm.objects(NHLPlayer.self).filter("id ==\(id)").first
            }
        }
        catch
        {
            print("Error retrieving player!")
        }
        
        viewController.performSegue(withIdentifier: "displayPlayer", sender: playerResult)
    }
    
    //  Create the displayStandings method
    func displayStandings(_ viewController: MainMenuViewController)
    {
        var standingsResult: Results<TeamStandings>?
        
        do
        {
            try realm.write
            {
                standingsResult = realm.objects(TeamStandings.self)
            }
        }
        catch
        {
            print("Error retrieving team standings!")
        }
        
        viewController.performSegue(withIdentifier: "displayStandings", sender: standingsResult)
    }
    
    //  Create the displaySchedule method
    func displaySchedule(_ viewController: MainMenuViewController, _ segueId: String)
    {
        var scheduleResult: Results<NHLSchedule>?
        
        do
        {
            try realm.write
            {
                scheduleResult = realm.objects(NHLSchedule.self)
            }
        }
        catch
        {
            print("Error retrieving schedule!")
        }
        
        viewController.performSegue(withIdentifier: segueId, sender: scheduleResult)
    }
    
    //  Create the displayTeams method
    func displayTeams(_ viewController: MainMenuViewController)
    {
        var teamResults: Results<NHLTeam>?
        
        do
        {
            try realm.write
            {
                teamResults = realm.objects(NHLTeam.self)
            }
        }
        catch
        {
            print("Error retrieving teams!")
        }
        
        viewController.performSegue(withIdentifier: "displayTeams", sender: teamResults)
    }
    
    //  Create the displayRoster method
    func displayRoster(_ viewController: DisplayTeamsViewController, _ teamId: Int)
    {
        var rosterResult: Results<NHLPlayer>?
        
        do
        {
            try realm.write
            {
                rosterResult = realm.objects(NHLPlayer.self).filter("teamId ==\(teamId)")
            }
        }
        catch
        {
            print("Error retrieving roster!")
        }
        
        viewController.performSegue(withIdentifier: "displayRoster", sender: rosterResult)
    }
    
    func mainMenuCategoriesRequiresSaving() -> Bool
    {
        var result = false
        
        do
        {
            try realm.write
            {
                if realm.objects(MainMenuCategory.self).count == 0
                {
                    result = true
                }
            }
        }
        catch
        {
            print("Error retrieving category count!")
        }
        
        return result
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
    
    func retrieveTodaysGames(_ mainViewController: MainMenuViewController)
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
            print("Error retrieving scheduled games for \(dateString)!")
        }
        
        return schedules
    }
    
    func retrieveScoresAsNHLSchedules(_ date: Date) -> Results<NHLSchedule>
    {
        var scheduledGames : Results<NHLSchedule>?
        
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        
        let dateString = fullDateFormatter.string(from: date)
        
        do
        {
            try realm.write
            {
                scheduledGames = realm.objects(NHLSchedule.self).filter("date = '\(dateString)'")
            }
        }
        catch
        {
            print("Error retrieving scheduled games for \(dateString)!")
        }
        
        return scheduledGames!
    }
    
    func retrieveTeamStatistics(_ teamId: Int) -> Results<TeamStatistics>
    {
        var teamStatistics : Results<TeamStatistics>?
            
        do
        {
            try realm.write
            {
                teamStatistics = realm.objects(TeamStatistics.self).filter("teamId = \(teamId)")
            }
        }
        catch
        {
            print("Error retrieving team statistics for \(teamId)!")
        }
        
        return teamStatistics!
    }
    
    func saveMainMenuCategories()
    {
        let categories = ["Schedule", "Standings", "Scores", "Team Rosters", "Team Stats"]
        
        let categoryList = List<MainMenuCategory>()
        
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        
        let dateString = fullDateFormatter.string(from: today)
        
        var id = 0
        
        for category in categories
        {
            let mainMenuCategory = MainMenuCategory()
            
            mainMenuCategory.id = id
            mainMenuCategory.category = category
            mainMenuCategory.dateCreated = dateString
            
            id = id + 1
            
            categoryList.append(mainMenuCategory)
        }
        
        do
        {
            print("Saving main menu category data...")
            
            try self.realm.write
            {
                self.realm.add(categoryList)
                
                print("Main menu categories have successfully been added to the database!!")
            }
        }
        catch
        {
            print("Error saving main menu categories to the database: \(error)")
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func retrieveMainMenuCategories() -> [MenuCategory]
    {
        var categories = [MenuCategory]()
        
        do
        {
            try realm.write
            {
                let menuCategories = realm.objects(MainMenuCategory.self)
                
                for menuCategory in menuCategories
                {
                    categories.append(MenuCategory(id: menuCategory.id, category: menuCategory.category, dateCreated: menuCategory.dateCreated))
                }
            }
        }
        catch
        {
            print("Error retrieving main menu categories!")
        }
        
        return categories
    }
    
    func linkPlayersToTeams()
    {
        //  Get all the teams
        let teamResults = realm.objects(NHLTeam.self)
        
        //  Spin through the teams and retrieve the players based on the team id
        for team in teamResults
        {
            do
            {
                try realm.write
                {
                    //  Get all players for that particular team
                    let playerResults = realm.objects(NHLPlayer.self).filter("teamId ==\(team.id)")
                    
                    for player in playerResults
                    {
                        //  Set the players in the parent team
                        team.players.append(player)
                    }
                    
                    //  Save the team to the database
                    realm.add(team)
                    
                    print("Players have successfully been linked to \(team.name)!")
                }
            }
            catch
            {
                print("Error saving teams to the database: \(error)")
            }
        }
    }
    
    func linkStandingsToTeams()
    {
        //  Get all the teams
        let teamResults = realm.objects(NHLTeam.self)
        
        //  Spin through the teams and retrieve the standings based on the team abbreviation
        for team in teamResults
        {
            do
            {
                try realm.write
                {
                    //  Get all standings for that particular team
                    let standingsResults = realm.objects(TeamStandings.self).filter("abbreviation =='\(team.abbreviation)'")
                    
                    for standings in standingsResults
                    {
                        //  Set the standings in the parent team
                        team.standings.append(standings)
                    }
                    
                    //  Save the team to the database
                    realm.add(team)
                    
                    print("Standings have successfully been linked to \(team.name)!")
                }
            }
            catch
            {
                print("Error saving teams to the database: \(error)")
            }
        }
    }
    
    func linkStatisticsToTeams()
    {
        //  Get all the teams
        let teamResults = realm.objects(NHLTeam.self)
        
        //  Spin through the teams and retrieve the statistics based on the team abbreviation
        for team in teamResults
        {
            do
            {
                try realm.write
                {
                    //  Get all statistics for that particular team
                    let statisticsResults = realm.objects(TeamStatistics.self).filter("abbreviation =='\(team.abbreviation)'")
                    
                    for statistics in statisticsResults
                    {
                        //  Set the statistics in the parent team
                        team.statistics.append(statistics)
                    }
                    
                    //  Save the team to the database
                    realm.add(team)
                    
                    print("Statistics have successfully been linked to \(team.name)!")
                }
            }
            catch
            {
                print("Error saving teams to the database: \(error)")
            }
        }
    }
    
    func linkSchedulesToTeams()
    {
        //  Get all the teams
        let teamResults = realm.objects(NHLTeam.self)
        
        //  Spin through the teams and retrieve the schedules based on the team abbreviation
        for team in teamResults
        {
            do
            {
                try realm.write
                {
                    //  Get all schedules for that particular team
                    let scheduleResults = realm.objects(NHLSchedule.self).filter("homeTeam =='\(team.abbreviation)' OR " + "awayTeam =='\(team.abbreviation)'")
                    
                    for schedule in scheduleResults
                    {
                        //  Set the standings in the parent team
                        team.schedules.append(schedule)
                    }
                    
                    //  Save the team to the database
                    realm.add(team)
                    
                    print("Schedules have successfully been linked to \(team.name)!")
                }
            }
            catch
            {
                print("Error saving teams to the database: \(error)")
            }
        }
    }
    
    func loadTeamRecords() -> [String:String]
    {
        var records = [String:String]()
        
        do
        {
            try realm.write
            {
                let teamStandings = realm.objects(TeamStandings.self)
                
                for teamStanding in teamStandings
                {
                    let record = String(teamStanding.wins) + "-" + String(teamStanding.losses) + "-" + String(teamStanding.overtimeLosses)
                    
                    records[teamStanding.abbreviation] = record
                }
            }
        }
        catch
        {
            print("Error loading team records!")
        }
        
        return records
    }
}
