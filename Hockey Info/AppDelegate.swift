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
            
            print("Linking of table data was successful!")
        }
        else
        {
            //networkManager.updateScheduleForDate(Date())
        }
        
        return true
    }
}

