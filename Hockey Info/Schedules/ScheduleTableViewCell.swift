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
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            //startTimeLabel.text = ""
            //endTimeLabel.text = "7:00 PM"
//            startTimeLabel.text = dateFormatter.string(from: schedule.startTime)
//            endTimeLabel.text = dateFormatter.string(from: schedule.endTime)
            categoryLine.backgroundColor = schedule.categoryColor
        }
    }
}
