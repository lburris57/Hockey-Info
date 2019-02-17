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
    
    func displayScoringSummary(_ viewController: DisplayGameLogViewController, _ gameId: Int)
    {
        var scoringSummaryResult: NHLScoringSummary?
        
        do
        {
            try realm.write
            {
                scoringSummaryResult = realm.objects(NHLScoringSummary.self).filter("id ==\(gameId)").first
            }
        }
        catch
        {
            print("Error retrieving scoring summary!")
        }
        
        viewController.performSegue(withIdentifier: "displayScoringSummary", sender: scoringSummaryResult)
    }
    
    func displayGameLog(_ viewController: CompletedGamesViewController, _ gameId: Int)
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
    
    func displayGameLog(_ viewController: DisplayScoresViewController, _ gameId: Int)
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
        
        viewController.performSegue(withIdentifier: "displayAllTeams", sender: teamResults)
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
    
    func displayTeamInfo(_ viewController: DisplayTeamsViewController, _ teamId: Int)
    {
        var teamResult: Results<NHLTeam>?
        
        do
        {
            try realm.write
            {
                teamResult = realm.objects(NHLTeam.self).filter("id ==\(teamId)")
            }
        }
        catch
        {
            print("Error retrieving team info!")
        }
        
        viewController.performSegue(withIdentifier: "displayDefaultRoster", sender: teamResult)
    }
    
    func displayInjuries(_ viewController: DisplayTeamsViewController, _ teamId: Int)
    {
        var injuryResult: Results<NHLPlayerInjury>?
        
        do
        {
            try realm.write
            {
                injuryResult = realm.objects(NHLPlayerInjury.self).filter("teamId ==\(teamId)")
            }
        }
        catch
        {
            print("Error retrieving injuries!")
        }
        
        viewController.performSegue(withIdentifier: "displayInjuries", sender: injuryResult)
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
        let categories = ["Season Schedule", "Team Information", "Standings", "Scores"]
        
        let categoryList = List<MainMenuCategory>()
        
        let dateString = TimeAndDateUtils.getCurrentDateAsString()
        
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
        do
        {
            try realm.write
            {
                let scheduledGames = realm.objects(NHLSchedule.self).filter("date = '\(TimeAndDateUtils.getCurrentDateAsString())'")
                
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
        
        let dateString = TimeAndDateUtils.getDateAsString(date)
        
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
                
                if(schedules.count == 0)
                {
                    let schedule = Schedule(title: "",
                        note: "No games scheduled",
                        startTime: "",
                        endTime: "",
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
    
    func retrieveScoringSummary(for gameId: Int) throws -> NHLScoringSummary?
    {
        var scoringSummaryResult: NHLScoringSummary?
        
        do
        {
            try realm.write
            {
                scoringSummaryResult = realm.objects(NHLScoringSummary.self).filter("id ==\(gameId)").first
            }
        }
        catch
        {
            print("Error retrieving scoring summary!")
            throw DatabaseErrorEnum.readFromDatabase
        }
        
        return scoringSummaryResult
    }
    
    func retrieveScoresAsNHLSchedules(_ date: Date) -> Results<NHLSchedule>
    {
        var scheduledGames : Results<NHLSchedule>?
        
        let dateString = TimeAndDateUtils.getDateAsString(date)
        
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
            print("Error retrieving teams!")
        }
        
        return teamResult!
    }
    
    func retrieveGameLogForDate(_ date: Date) -> Results<NHLGameLog>
    {
        var gameLogResult: Results<NHLGameLog>?
        
        let dateString = TimeAndDateUtils.getDateAsString(date)
        
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
                    if(team.players.count == 0 || team.schedules.count == 0 ||
                       team.gameLogs.count == 0 || team.standings.count == 0 ||
                       team.statistics.count == 0)
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
    
    func linkPlayerInjuriesToTeams()
    {
        //  Get all the teams
        let teamResults = realm.objects(NHLTeam.self)
        
        //  Spin through the teams and retrieve the player injuries based on the team abbreviation
        for team in teamResults
        {
            do
            {
                try realm.write
                {
                    //  Get all player injuries for that particular team
                    let injuryResults = realm.objects(NHLPlayerInjury.self).filter("teamAbbreviation =='\(team.abbreviation)'").sorted(byKeyPath: "playingProbablity", ascending: false)
                    
                    for injuries in injuryResults
                    {
                        //  Set the player injuries in the parent team
                        team.playerInjuries.append(injuries)
                    }
                    
                    //  Save the team to the database
                    realm.add(team)
                    
                    print("Player injuries have successfully been linked to \(team.name)!")
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
    
    func tablesRequireReload() -> Bool
    {
        let dateString = TimeAndDateUtils.getCurrentDateAsString()
        
        let playerInjuryResult = realm.objects(NHLPlayerInjury.self).first
        
        let dateCreated = playerInjuryResult?.dateCreated
        
        if dateString != dateCreated
        {
            return true
        }
        
        return false
    }
    
    func deleteTeamLinks()
    {
        do
        {
            try realm.write
            {
                let teamResults = realm.objects(NHLTeam.self)
                
                for team in teamResults
                {
                    team.players.removeAll()
                    team.playerInjuries.removeAll()
                    team.standings.removeAll()
                    team.statistics.removeAll()
                    team.schedules.removeAll()
                    team.gameLogs.removeAll()
                    
                    realm.add(team, update: true)
                }
            }
        }
        catch
        {
            print("Error deleting team links!")
        }
    }
    
    func deleteScoringSummaryData()
    {
        do
        {
            try realm.write
            {
                let scoringSummaryResults = realm.objects(NHLScoringSummary.self)
                let periodScoringDataResults = realm.objects(NHLPeriodScoringData.self)
                
                realm.delete(scoringSummaryResults)
                realm.delete(periodScoringDataResults)
            }
        }
        catch
        {
            print("Error deleting scoring summary data!")
        }
    }
    
    func getLatestDatePlayed() -> String
    {
        let scheduleResult = realm.objects(NHLSchedule.self).filter("playedStatus == '\(PlayedStatusEnum.completed.rawValue)'")
        let sortedScheduleResult = scheduleResult.sorted(byKeyPath: "id", ascending: false)
        
        return sortedScheduleResult[0].date
    }
    
    func getLatestGameLogDate() -> String
    {
        let maxValue =  realm.objects(NHLGameLog.self).max(ofProperty: "id") as Int?
        let gameLogResult = realm.objects(NHLGameLog.self).filter("id == \(maxValue ?? 0)")
        
        return gameLogResult[0].date
    }
}
