//
//  MainTableViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/2/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import SwifterSwift
import SwiftDate

class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    let categories = ["Schedule", "Standings", "Scores", "Team Rosters", "Team Stats",  "Player Stats"]
    
    let networkManager = NetworkManager()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = categories[indexPath.row]
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let category = categories[indexPath.row]
        
        if(category == "Scores")
        {
            networkManager.retrieveScores(self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let displayScoresViewController = segue.destination as! DisplayScoresViewController
        
        displayScoresViewController.games = sender as! [Game]
    }
}
