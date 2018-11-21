//
//  TeamManager
//  Hockey Info
//
//  Created by Larry Burris on 11/18/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

class TeamManager
{
    static func getFullTeamName(_ name: String) -> String
    {
        let teamNames = ["ANA":"Anaheim Ducks", "ARI":"Arizona Coytotes", "BOS":"Boston Bruins", "BUF":"Buffalo Sabres", "CAL":"Calgary Flames", "CAR":"Carolina Hurricanes", "CHI":" Chicago Blackhawks", "COL":"Colorado Avalanche", "CBJ":"Columbus Blue Jackets", "DAL":"Dallas Stars", "DET":"Detroit Red Wings", "EDM":"Edmonton Oilers","FLO":"Florida Panthers", "LAK":"Los Angeles Kings", "MIN":"Minnesota Wild", "MON":"Montreal Canadiens", "NSH":"Nashville Predators", "NJD":"New Jersey Devils", "NYI":"New York Islanders", "NYR":"New York Rangers", "OTT":"Ottawa Senators", "PHI":"Philadelphia Flyers", "PIT":"Pittsburgh Penguins", "SJS":"San Jose Sharks", "STL":"St. Louis Blues","TBL":"Tampa Bay Lightning", "TOR":"Toronto Maple Leafs", "VAN":"Vancouver Canucks", "VGK":"Vegas Golden Knights", "WAS":"Washington Capitals", "WPJ":"Winnipeg Jets"]
        
        return teamNames[name]!
    }
    
    static func getTeamName(_ name: String) -> String
    {
        let teamNames = ["ANA":"Ducks", "ARI":"Coytotes", "BOS":"Bruins", "BUF":"Sabres", "CAL":"Flames", "CAR":"Hurricanes", "CHI":"Blackhawks", "COL":"Avalanche", "CBJ":"Blue Jackets", "DAL":"Stars", "DET":"Red Wings", "EDM":"Oilers", "FLO":"Panthers", "LAK":"Kings", "MIN":"Wild", "MON":"Canadiens", "NSH":"Predators", "NJD":"Devils", "NYI":"Islanders", "NYR":"Rangers", "OTT":"Senators", "PHI":"Flyers", "PIT":"Penguins", "SJS":"Sharks", "STL":"Blues", "TBL":"Lightning", "TOR":"Maple Leafs", "VAN":"Canucks", "VGK":"Golden Knights", "WAS":"Capitals", "WPJ":"Jets"]
        
        return teamNames[name]!
    }
    
    static func getIDByTeam(_ name: String) -> Int
    {
        let teamNames = ["ANA":29, "ARI":30, "BOS":11, "BUF":15, "CAL":23, "CAR":3, "CHI":20, "COL":22, "CBJ":19, "DAL":27, "DET":16, "EDM":24, "FLO":4, "LAK":28, "MIN":25, "MON":14, "NSH":18, "NJD":7, "NYI":8, "NYR":9, "OTT":13, "PHI":6, "PIT":10, "SJS":26, "STL":17, "TBL":1, "TOR":12, "VAN":21, "VGK":142, "WAS":5, "WPJ":2]
        
        return teamNames[name]!
    }
    
    
    static func getTeamByID(_ teamId: Int) -> String
    {
        let teamIds = [29:"ANA", 30:"ARI", 11:"BOS", 15:"BUF", 23:"CAL", 3:"CAR", 20:"CHI", 22:"COL", 19:"CBJ", 27:"DAL", 16:"DET", 24:"EDM", 4:"FLO", 28:"LAK", 25:"MIN", 14:"MON", 18:"NSH", 7:"NJD", 8:"NYI", 9:"NYR", 13:"OTT", 6:"PHI", 10:"PIT", 26:"SJS", 17:"STL", 1:"TBL", 12:"TOR", 21:"VAN", 142:"VGK", 5:"WAS", 2:"WPJ"]
        
        return teamIds[teamId]!
    }
}
