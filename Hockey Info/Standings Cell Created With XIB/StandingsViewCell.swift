//
//  StandingsViewCell.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/14/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit

class StandingsViewCell: UITableViewCell
{
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var gamesPlayed: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var losses: UILabel!
    @IBOutlet weak var overtimeLosses: UILabel!
    @IBOutlet weak var points: UILabel!
    
    
    static let reusableIdentifier = "standingsViewCell"
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
