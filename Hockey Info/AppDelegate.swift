//
//  AppDelegate.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/14/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    let databaseManager = DatabaseManager()
    let networkManager = NetworkManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        return true
    }
}

/**
 Call this function for showing alert with OK and Cancel button in your View Controller class.
 - Parameters:
 - VC : View Controller over which the function is called. You can use self, or provide view controller name.
 - message: Pass your alert message in String.
 - okClickHandler: This will give you call back inside block when OK button is clicked
 
 ### Usage Example: ###
 ````
 AlertClass().showAlert(self, andMessage: "This is custom alert") { (okClick) in
 }
 ````
 */

