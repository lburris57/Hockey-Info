//
//  ScheduleTableViewCell.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/9/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit

class ScheduleTableViewCell: UITableViewCell
{
    @IBOutlet weak var categoryLine: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    var schedule: Schedule!
    {
        didSet
        {
            titleLabel.text = schedule.title
            noteLabel.text = schedule.note
            endTimeLabel.text = schedule.startTime
            categoryLine.backgroundColor = schedule.categoryColor
        }
    }
}
