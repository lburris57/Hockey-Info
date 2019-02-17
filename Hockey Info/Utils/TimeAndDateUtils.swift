//
//  TimeAndDateUtils.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/7/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation
import SwiftDate

class TimeAndDateUtils
{
    static func getDate(_ timestamp: String) -> String
    {
        let formatter = DateFormatter()
        
        var date = Date()
        
        formatter.dateFormat = Constants.GMT_FORMAT
        
        if TimeZone.current.isDaylightSavingTime()
        {
            date = (formatter.date(from: timestamp)?.addingTimeInterval(-(9*60*60)))!
        }
        else
        {
            date = (formatter.date(from: timestamp)?.addingTimeInterval(-(10*60*60)))!
        }
        
        return date.toFormat(Constants.LONG_DATE_FORMAT)
    }
    
    static func getTime(_ timestamp: String) -> String
    {
        let formatter = DateFormatter()
        
        var date = Date()
        
        formatter.dateFormat = Constants.GMT_FORMAT
        
        if TimeZone.current.isDaylightSavingTime()
        {
            date = (formatter.date(from: timestamp)?.addingTimeInterval(-(9*60*60)))!
        }
        else
        {
            date = (formatter.date(from: timestamp)?.addingTimeInterval(-(10*60*60)))!
        }
        
        return date.toFormat("hh:mm a")
    }
    
    static func getDateAndTime(_ timestamp: String) -> (String, String)
    {
        let formatter = DateFormatter()
        
        var date = Date()
        
        formatter.dateFormat = Constants.GMT_FORMAT
        
        if TimeZone.current.isDaylightSavingTime()
        {
            date = (formatter.date(from: timestamp)?.addingTimeInterval(-(9*60*60)))!
        }
        else
        {
            date = (formatter.date(from: timestamp)?.addingTimeInterval(-(10*60*60)))!
        }
        
        return (date.toFormat(Constants.LONG_DATE_FORMAT), date.toFormat("hh:mm a"))
    }
    
    static func getCurrentTimeRemainingString(_ currentPeriodSecondsRemaining: Int) -> String
    {
        var currentTimeRemainingString = ""
        
        if currentPeriodSecondsRemaining > 0
        {
            if currentPeriodSecondsRemaining >= 60
            {
                let mins = Int(currentPeriodSecondsRemaining / 60)
                let sixtyMins: Int = mins * 60
                let secs = currentPeriodSecondsRemaining - sixtyMins
                
                if(mins < 10)
                {
                    if(secs < 10)
                    {
                        currentTimeRemainingString = "0\(mins):0\(secs) Remaining"
                    }
                    else
                    {
                        currentTimeRemainingString = "0\(mins):\(secs) Remaining"
                    }
                }
                else
                {
                    if(secs < 10)
                    {
                        currentTimeRemainingString = "\(mins):0\(secs) Remaining"
                    }
                    else
                    {
                        currentTimeRemainingString = "\(mins):\(secs) Remaining"
                    }
                }
            }
            else
            {
                if(currentPeriodSecondsRemaining < 10)
                {
                    currentTimeRemainingString = "00:0\(currentPeriodSecondsRemaining) Remaining"
                }
                else
                {
                    currentTimeRemainingString = "00:\(currentPeriodSecondsRemaining) Remaining"
                }
            }
        }
        else
        {
            return currentTimeRemainingString
        }
        
        return currentTimeRemainingString
    }
    
    static func getCurrentDateAsString() -> String
    {
        return (Date().toFormat(Constants.LONG_DATE_FORMAT))
    }
    
    static func getDateAsString(_ date: Date) -> String
    {
        return (date.toFormat(Constants.LONG_DATE_FORMAT))
    }
    
    static func getCurrentDateAsStringInWebServiceFormat() -> String
    {
        return (Date().toFormat(Constants.SHORT_DATE_FORMAT))
    }
    
    static func createDateStringInWebServiceFormat(from beginDate: Date, to endDate: Date) -> String
    {
        return (beginDate.toFormat(Constants.SHORT_DATE_FORMAT)) + "-" + (endDate.toFormat(Constants.SHORT_DATE_FORMAT))
    }
    
    static func createUpdateDateStringInWebServiceFormat(from date: Date) -> String
    {
        return "since-" + date.toFormat(Constants.SHORT_DATE_FORMAT)
    }
    
    static func getDate(fromString dateString: String, dateFormat format: String ) -> Date?
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.date(from: dateString)
    }
}
