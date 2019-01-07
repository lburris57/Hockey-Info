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
    
    // MARK: Display Methods
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
    
    func displayPlayerStatistics(_ viewController: DisplayPlayerViewController, _ playerId: Int)
    {
        var playerStatisticsResult: PlayerStatistics?
        
        do
        {
            try realm.write
            {
                playerStatisticsResult = realm.objects(PlayerStatistics.self).filter("id ==\(playerId)").first
            }
        }
        catch
        {
            print("Error retrieving player statistics!")
        }
        
        viewController.performSegue(withIdentifier: "displayPlayerStatistics", sender: playerStatisticsResult)
    }
    
    func displayGameLog(_ viewController: DisplayTeamScheduleViewController, _ gameId: Int)
    {
        var gameLogResult: NHLGameLog?
        
        do
        {
            try realm.write
            {
                gameLogResult = realm.objects(NHLGameLog.self).filter("id ==\(gameId)").first
            }
        }
        catch
        {
            print("Error retrieving game log!")
        }
        
        viewController.performSegue(withIdentifier: "displayGameLog", sender: gameLogResult)
    }
    
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
    
    func displayTeams(_ viewController: MainMenuViewController, _ category:String)
    {
        var teamResults: Results<NHLTeam>?
        
        var segueId = ""
        
        if(category == "Team Rosters")
        {
            segueId = "displayTeams"
        }
        else if(category == "Team Schedule")
        {
            segueId = "displayTeamsForSchedule"
        }
        else
        {
            segueId = "displayTeamStatistics"
        }
        
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
        
        viewController.performSegue(withIdentifier: segueId, sender: teamResults)
    }
    
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
    
    func displayTeamStatistics(_ viewController: DisplayTeamsViewController, _ teamId: Int)
    {
        var team : NHLTeam?
        
        do
        {
            try realm.write
            {
                team = realm.objects(NHLTeam.self).filter("id = \(teamId)").first
            }
        }
        catch
        {
            print("Error retrieving team result for \(teamId)!")
        }
        
        viewController.performSegue(withIdentifier: "displayTeamStatistics", sender: team)
    }
    
    func displayTeamSchedule(_ viewController: DisplayTeamsViewController, _ teamId: Int)
    {
        var teamSchedules : Results<NHLSchedule>?
        
        let team = TeamManager.getTeamByID(teamId)
        
        do
        {
            try realm.write
            {
                teamSchedules = realm.objects(NHLSchedule.self).filter("homeTeam = '\(team)' OR awayTeam = '\(team)'")
            }
        }
        catch
        {
            print("Error retrieving schedule results for \(teamId)!")
        }
        
        viewController.performSegue(withIdentifier: "displayTeamSchedule", sender: teamSchedules)
    }
    
    // MARK: Requires saving methods
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
    
    func playerStatsRequiresSaving() -> Bool
    {
        var result = false
        
        do
        {
            try realm.write
            {
                if realm.objects(PlayerStatistics.self).count == 0
                {
                    result = true
                }
            }
        }
        catch
        {
            print("Error retrieving player stats count!")
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
    
    func gameLogRequiresSaving() -> Bool
    {
        var result = false
        
        do
        {
            try realm.write
            {
                if realm.objects(NHLGameLog.self).count == 0
                {
                    result = true
                }
            }
        }
        catch
        {
            print("Error retrieving game log count!")
        }
        
        return result
    }
    
    func saveMainMenuCategories()
    {
        let categories = ["Season Schedule", "Team Schedule", "Standings", "Scores", "Team Rosters", "Team Statistics", "Player Statistics"]
        
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
    
    // MARK: Retrieve methods
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
    
    func retrieveAllPlayers() -> Results<NHLPlayer>
    {
        var rosterResult: Results<NHLPlayer>?
        
        do
        {
            try realm.write
            {
                rosterResult = realm.objects(NHLPlayer.self)
            }
        }
        catch
        {
            print("Error retrieving roster!")
        }
        
        return rosterResult!
    }
    
    func retrieveAllTeams() -> Results<NHLTeam>
    {
        var teamResult: Results<NHLTeam>?
        
        do
        {
            try realm.write
            {
                teamResult = realm.objects(NHLTeam.self)
            }
        }
        catch
        {
            print("Error retrieving roster!")
        }
        
        return teamResult!
    }
    
    func retrieveGameLogForDate(_ date: Date) -> Results<NHLGameLog>
    {
        var gameLogResult: Results<NHLGameLog>?
        
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        
        let dateString = fullDateFormatter.string(from: date)
        
        do
        {
            try realm.write
            {
                gameLogResult = realm.objects(NHLGameLog.self).filter("date='\(dateString)'")
            }
        }
        catch
        {
            print("Error retrieving game logs!")
        }
        
        return gameLogResult!
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
    
    // MARK: Link methods
    func teamTableRequiresLinking() -> Bool
    {
        var result = false
        
        do
        {
            try realm.write
            {
                if let team = realm.objects(NHLTeam.self).filter("id = \(5)").first
                {
                    if(team.players.count == 0)
                    {
                        result = true
                    }
                }
            }
        }
        catch
        {
            print("Error retrieving team!")
        }
        
        return result
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
                    
                    print("Size of playerResults is: \(playerResults.count)")
                    
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
                        //  Set the schedule in the parent team
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
    
    func linkGameLogsToTeams()
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
                    //  Get all game logs for that particular team
                    let gameLogResults = realm.objects(NHLGameLog.self).filter("homeTeamAbbreviation =='\(team.abbreviation)' OR " + "awayTeamAbbreviation =='\(team.abbreviation)'")
                    
                    for gameLog in gameLogResults
                    {
                        //  Set the gameLog in the parent team
                        team.gameLogs.append(gameLog)
                    }
                    
                    //  Save the team to the database
                    realm.add(team)
                    
                    print("Game logs have successfully been linked to \(team.name)!")
                }
            }
            catch
            {
                print("Error saving teams to the database: \(error)")
            }
        }
    }
    
    // MARK: Load/Reload methods
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
    
    func reloadInjuryTableIfRequired()
    {
        let networkManager = NetworkManager()
        
        fullDateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        
        let dateString = fullDateFormatter.string(from: today)
        
        let playerInjuryResults = realm.objects(NHLPlayerInjury.self)
        
        if playerInjuryResults.count > 0
        {
            if(playerInjuryResults[0].dateCreated != dateString)
            {
                do
                {
                    try realm.write
                    {
                        realm.delete(realm.objects(NHLPlayerInjury.self))
                    }
                }
                catch
                {
                    print("Error deleting player injury data!")
                }
                
                networkManager.savePlayerInjuries()
                
                networkManager.updateScheduleForDate(Date())
            }
        }
    }
}
