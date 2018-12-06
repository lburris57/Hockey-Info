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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        autoreleasepool
        {
            //let teamNames = ["ANA":29, "ARI":30, "BOS":11, "BUF":15, "CGY":23, "CAR":3, "CHI":20, "COL":22, "CBJ":19, "DAL":27, "DET":16, "EDM":24, "FLO":4, "LAK":28, "MIN":25, "MTL":14, "NSH":18, "NJD":7, "NYI":8, "NYR":9, "OTT":13, "PHI":6, "PIT":10, "SJS":26, "STL":17, "TBL":1, "TOR":12, "VAN":21, "VGK":142, "WSH":5, "WPJ":2]
            
            //let realm = try! Realm()
            
//            let teams = List<Team>()
//
//            for(abbreviation, id) in teamNames
//            {
//                let team = Team()
//
//                team.id = String(id)
//                team.abbreviation = abbreviation
//                team.cityName = TeamManager.getFullTeamName(abbreviation)
//                team.dateCreated = Date()
//
//                teams.append(team)
//            }
//
//            do
//            {
//                try realm.write
//                {
//                    realm.add(teams)
//
//                    print("Teams have been added to the database!!")
//                }
//            }
//            catch
//            {
//                print("Error saving teams to the database: \(error)")
//            }
            
            //print(Realm.Configuration.defaultConfiguration.fileURL!)
        }
        
        //let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        //let realmURLs = [realmURL, realmURL.appendingPathExtension("lock"), realmURL.appendingPathExtension("note"), realmURL.appendingPathExtension("management")]
        
        
        //print("Deleting Realm database from URL: \(realmURL)")
        
        /*for URL in realmURLs
        {
            do
            {
                try FileManager.default.removeItem(at: URL)
            }
            catch
            {
                print("Error deleting Realm database")
            }
        }*/
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

