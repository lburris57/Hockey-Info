//
//  CompletedScheduleViewCell.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/27/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit

class CompletedScheduleViewCell: UITableViewCell
{
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var opponent: UILabel!
    @IBOutlet weak var result: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
