//
//  TeamNames.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/18/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

class TeamNames
{
    static func getFullTeamName(_ name: String) -> String
    {
        let teamNames = ["ANA":"Anaheim Ducks", "ARI":"Arizona Coytotes", "BOS":"Boston Bruins", "BUF":"Buffalo Sabres", "CAL":"Calgary Flames", "CAR":"Carolina Hurricanes", "CHI":" Chicago Blackhawks", "COL":"Colorado Avalanche", "CBJ":"Columbus Blue Jackets", "DAL":"Dallas Stars", "DET":"Detroit Red Wings", "EDM":"Edmonton Oilers","FLO":"Florida Panthers", "LAK":"Los Angeles Kings", "MIN":"Minnesota Wild", "MON":"Montreal Canadiens", "NSH":"Nashville Predators", "NJD":"New Jersey Devils", "NYI":"New York Islanders", "NYR":"New York Rangers", "OTT":"Ottawa Senators", "PHI":"Philadelphia Flyers", "PIT":"Pittsburgh Penguins", "SJS":"San Jose Sharks", "STL":"St. Louis Blues","TBL":"Tampa Bay Lightning", "TOR":"Toronto Maple Leafs", "VAN":"Vancouver Canucks", "VGK":"Vegas Golden Knights", "WAS":"Washington Capitals", "WIN":"Winnipeg Jets"]
        
        return teamNames[name]!
        
    }
    
    static func getTeamName(_ name: String) -> String
    {
        let teamNames = ["ANA":"Ducks", "ARI":"Coytotes", "BOS":"Bruins", "BUF":"Sabres", "CAL":"Flames", "CAR":"Hurricanes", "CHI":"Blackhawks", "COL":"Avalanche", "CBJ":"Blue Jackets", "DAL":"Stars", "DET":"Red Wings", "EDM":"Oilers", "FLO":"Panthers", "LAK":"Kings", "MIN":"Wild", "MON":"Canadiens", "NSH":"Predators", "NJD":"Devils", "NYI":"Islanders", "NYR":"Rangers", "OTT":"Senators", "PHI":"Flyers", "PIT":"Penguins", "SJS":"Sharks", "STL":"Blues", "TBL":"Lightning", "TOR":"Maple Leafs", "VAN":"Canucks", "VGK":"Golden Knights", "WAS":"Capitals", "WIN":"Jets"]
        
        return teamNames[name]!
    }
}
