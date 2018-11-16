//
//  ScoreCell.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/15/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//

import UIKit

class ScoreCell: UITableViewCell
{
    static let reusableIdentifier = "scoreCell"
    
    @IBOutlet weak var timeRemaining: UITextField!
    
    @IBOutlet weak var visitingTeamName: UITextField!
   
    @IBOutlet weak var visitingTeamRecord: UITextField!
    
    @IBOutlet weak var homeTeamName: UITextField!
    
    @IBOutlet weak var homeTeamRecord: UITextField!
    
    @IBOutlet weak var visitingTeamScore: UITextField!
    
    @IBOutlet weak var homeTeamScore: UITextField!
    
    @IBOutlet weak var period: UITextField!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
