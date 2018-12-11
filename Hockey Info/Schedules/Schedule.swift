//
//  Schedule.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/9/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit

struct Schedule
{
    var title: String
    var note: String
    var startTime: String
    var endTime: String
    var categoryColor: UIColor
}

extension Schedule : Equatable
{
    static func ==(lhs: Schedule, rhs: Schedule) -> Bool
    {
        return lhs.startTime == rhs.startTime
    }
}

extension Schedule : Comparable
{
    static func <(lhs: Schedule, rhs: Schedule) -> Bool
    {
        return lhs.startTime < rhs.startTime
    }
}
