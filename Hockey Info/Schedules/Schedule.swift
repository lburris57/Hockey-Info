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
    var startTime: Date
    var endTime: Date
    var categoryColor: UIColor
}

// random events
extension Schedule
{
    init(fromStartDate: Date)
    {
        title = "Capitals at Blue Jackets"
        note = "Nationwide Arena"
        categoryColor = .black
//        title = ["Capitals at Blue Jackets", "Sabres at Canadiens", "Oilers at Penguins"].randomValue()
//        note = ["7:00 PM", "8:00 PM", "10:00 PM"].randomValue()
//        categoryColor = [.red, .orange, .purple, .blue, .black].randomValue()
        
        let day = [Int](0...27).randomValue()
        let hour = [Int](0...23).randomValue()
        let startDate = Calendar.current.date(byAdding: .day, value: day, to: fromStartDate)!
        
        
        startTime = Calendar.current.date(byAdding: .hour, value: hour, to: startDate)!
        endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime)!
    }
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
