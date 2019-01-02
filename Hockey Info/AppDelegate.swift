//
//  AppDelegate.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/14/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let databaseManager = DatabaseManager()
        let networkManager = NetworkManager()
        
        if(databaseManager.teamTableRequiresLinking())
        {
            print("Linking table data...")
            
            databaseManager.linkPlayersToTeams()
            databaseManager.linkStandingsToTeams()
            databaseManager.linkStatisticsToTeams()
            databaseManager.linkSchedulesToTeams()
            databaseManager.linkGameLogsToTeams()
            
            print("Linking of table data was successful!")
            
            networkManager.updateScheduleForDate(Date())
        }
        
        //  If the player injury table is populated and the last updated date is not today,
        //  delete the current data and reload the table
        databaseManager.reloadInjuryTableIfRequired()
        
        return true
    }
}

