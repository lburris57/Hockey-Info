//
//  CompletedScheduleViewCell.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/27/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit

protocol CompletedScheduleViewCellDelegate : class
{
    func completedScheduleViewCellDidTapGameLog(_ sender: CompletedScheduleViewCell)
}

class CompletedScheduleViewCell: UITableViewCell
{
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var opponent: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var gameLogButtonTapped: UIButton!
    
    weak var delegate: CompletedScheduleViewCellDelegate?
    
    @IBAction func gameLogButtonWasTapped(_ sender: UIButton)
    {
        delegate?.completedScheduleViewCellDidTapGameLog(self)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
