//
//  StandingsCell.swift
//  Hockey Info
//
//  Created by Larry Burris on 2/23/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import UIKit

class StandingsCell: UITableViewCell
{
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var gamesPlayed: UILabel!
    @IBOutlet weak var gamesWon: UILabel!
    @IBOutlet weak var gamesLost: UILabel!
    @IBOutlet weak var overtimeLosses: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
}
