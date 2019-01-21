//
//  ScoreSummaryCell.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/21/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import UIKit

class ScoreSummaryCell: UITableViewCell
{
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var scoringText: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
}
