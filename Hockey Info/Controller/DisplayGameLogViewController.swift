//
//  DisplayGameLogViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/2/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift

class DisplayGameLogViewController: UIViewController
{
    @IBOutlet weak var homeLogo: UIImageView!
    @IBOutlet weak var awayLogo: UIImageView!
    @IBOutlet weak var dateString: UILabel!
    @IBOutlet weak var homeGoalsFor: UILabel!
    @IBOutlet weak var awayGoalsFor: UILabel!
    @IBOutlet weak var homeGoalsAgainst: UILabel!
    @IBOutlet weak var awayGoalsAgainst: UILabel!
    @IBOutlet weak var homeShots: UILabel!
    @IBOutlet weak var awayShots: UILabel!
    @IBOutlet weak var homeHits: UILabel!
    @IBOutlet weak var awayHits: UILabel!
    @IBOutlet weak var homeFaceoffWins: UILabel!
    @IBOutlet weak var awayFaceoffWins: UILabel!
    @IBOutlet weak var homeFaceoffLosses: UILabel!
    @IBOutlet weak var awayFaceoffLosses: UILabel!
    @IBOutlet weak var homeFaceoffPercentage: UILabel!
    @IBOutlet weak var awayFaceoffPercentage: UILabel!
    @IBOutlet weak var homePowerPlays: UILabel!
    @IBOutlet weak var awayPowerPlays: UILabel!
    @IBOutlet weak var homePowerPlayGoals: UILabel!
    @IBOutlet weak var awayPowerPlayGoals: UILabel!
    @IBOutlet weak var homePowerPlayPercentage: UILabel!
    @IBOutlet weak var awayPowerPlayPercentage: UILabel!
    @IBOutlet weak var homePenalties: UILabel!
    @IBOutlet weak var awayPenalties: UILabel!
    @IBOutlet weak var homePenaltyMinutes: UILabel!
    @IBOutlet weak var awayPenaltyMinutes: UILabel!
    @IBOutlet weak var homePenaltyKills: UILabel!
    @IBOutlet weak var awayPenaltyKills: UILabel!
    @IBOutlet weak var homePKGoalsAllowed: UILabel!
    @IBOutlet weak var awayPKGoalsAllowed: UILabel!
    @IBOutlet weak var homePenaltyKillPercentage: UILabel!
    @IBOutlet weak var awayPenaltyKillPercentage: UILabel!
    
    var gameLogResult: NHLGameLog?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let gameLog = gameLogResult
        {
            homeLogo.image = UIImage(named: (gameLog.homeTeamAbbreviation))
            awayLogo.image = UIImage(named: (gameLog.awayTeamAbbreviation))
            dateString.text = gameLog.dateCreated
            homeGoalsFor.text = String(gameLog.homeGoalsFor)
            awayGoalsFor.text = String(gameLog.awayGoalsFor)
            homeGoalsAgainst.text = String(gameLog.homeGoalsAgainst)
            awayGoalsAgainst.text = String(gameLog.awayGoalsAgainst)
            homeShots.text = String(gameLog.homeShots)
            awayShots.text = String(gameLog.awayShots)
            homeHits.text = String(gameLog.homeHits)
            awayHits.text = String(gameLog.awayHits)
            homeFaceoffWins.text = String(gameLog.homeFaceoffWins)
            awayFaceoffWins.text = String(gameLog.awayFaceoffWins)
            homeFaceoffLosses.text = String(gameLog.homeFaceoffLosses)
            awayFaceoffLosses.text = String(gameLog.awayFaceoffLosses)
            homeFaceoffPercentage.text = String(gameLog.homeFaceoffPercent)
            awayFaceoffPercentage.text = String(gameLog.awayFaceoffPercent)
            homePowerPlays.text = String(gameLog.homePowerplays)
            awayPowerPlays.text = String(gameLog.awayPowerplays)
            homePowerPlayGoals.text = String(gameLog.homePowerplayGoals)
            awayPowerPlayGoals.text = String(gameLog.awayPowerplayGoals)
            homePowerPlayPercentage.text = String(gameLog.homePowerplayPercent)
            awayPowerPlayPercentage.text = String(gameLog.awayPowerplayPercent)
            homePenalties.text = String(gameLog.homePenalties)
            awayPenalties.text = String(gameLog.awayPenalties)
            homePenaltyMinutes.text = String(gameLog.homePenaltyMinutes)
            awayPenaltyMinutes.text = String(gameLog.awayPenaltyMinutes)
            homePenaltyKills.text = String(gameLog.homePenaltyKills)
            awayPenaltyKills.text = String(gameLog.awayPenaltyKills)
            homePKGoalsAllowed.text = String(gameLog.homePenaltyKillGoalsAllowed)
            awayPKGoalsAllowed.text = String(gameLog.awayPenaltyKillGoalsAllowed)
            homePenaltyKillPercentage.text = String(gameLog.homePenaltyKillPercent)
            awayPenaltyKillPercentage.text = String(gameLog.awayPenaltyKillPercent)
        }
    }
}
