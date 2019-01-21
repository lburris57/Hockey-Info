//
//  DisplayScoreSummaryViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/21/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import UIKit

class DisplayScoreSummaryViewController: UITableViewController
{
    @IBOutlet var scoreSummaryView: UITableView!
    
    var periodListSize = 3
    
    var scoringSummary: NHLScoringSummary?
    
    var displayArray = [NHLPeriodScoringData]()
    var firstPeriodArray = [NHLPeriodScoringData]()
    var secondPeriodArray = [NHLPeriodScoringData]()
    var thirdPeriodArray = [NHLPeriodScoringData]()
    var overtimeArray = [NHLPeriodScoringData]()
    var shootoutArray = [NHLPeriodScoringData]()
    
    var sections = ["1st Period", "2nd Period", "3rd Period", "Overtime", "Shootout"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let summary = scoringSummary
        {
            loadArrays(summary)
        }
        
        let myNib = UINib(nibName: "ScoreSummaryCell", bundle: Bundle.main)
        scoreSummaryView.register(myNib, forCellReuseIdentifier: "scoreSummaryCell")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        view.tintColor = UIColor.purple
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return self.sections[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    {
        view.tintColor = UIColor.white
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.textColor = UIColor.white
        footer.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return self.sections[section]
    }

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        if let summary = scoringSummary
        {
            periodListSize = summary.numberOfPeriods
        }
        
        return periodListSize
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch (section)
        {
            case 0:
                return firstPeriodArray.count
            case 1:
                return secondPeriodArray.count
            case 2:
                return thirdPeriodArray.count
            case 3:
                return overtimeArray.count
            case 4:
                return shootoutArray.count
            default:
                return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch(indexPath.section)
        {
            case 0:
                displayArray = firstPeriodArray
            case 1:
                displayArray = secondPeriodArray
            case 2:
                displayArray = thirdPeriodArray
            case 3:
                displayArray = overtimeArray
            case 4:
                displayArray = shootoutArray
            default:
                displayArray = [NHLPeriodScoringData]()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreSummaryCell", for: indexPath) as! ScoreSummaryCell
        
        let time = TimeAndDateUtils.getCurrentTimeRemainingString(displayArray[indexPath.row].periodSecondsElapsed)
        
        //  Remove the "Remaining" text from the time string
        cell.time.text = ConversionUtils.removeRemainingText(time)
        cell.teamLogo?.image = UIImage(named: displayArray[indexPath.row].teamAbbreviation)
        cell.scoringText.text = displayArray[indexPath.row].playDescription
        
        scoreSummaryView.rowHeight = CGFloat(60.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadArrays(_ summary: NHLScoringSummary)
    {
        let periodScoringList = summary.periodScoringList
        
        for periodScoringData in periodScoringList
        {
            switch(periodScoringData.periodNumber)
            {
                case 1:
                    firstPeriodArray.append(periodScoringData)
                case 2:
                    secondPeriodArray.append(periodScoringData)
                case 3:
                    thirdPeriodArray.append(periodScoringData)
                case 4:
                    overtimeArray.append(periodScoringData)
                case 5:
                    shootoutArray.append(periodScoringData)
                default:
                    return
            }
        }
        
        //  Sort the arrays
        firstPeriodArray.sort {$0.periodSecondsElapsed < $1.periodSecondsElapsed}
        secondPeriodArray.sort {$0.periodSecondsElapsed < $1.periodSecondsElapsed}
        thirdPeriodArray.sort {$0.periodSecondsElapsed < $1.periodSecondsElapsed}
        
        if overtimeArray.count > 0
        {
            overtimeArray.sort {$0.periodSecondsElapsed < $1.periodSecondsElapsed}
        }
        
        if shootoutArray.count > 0
        {
            shootoutArray.sort {$0.periodSecondsElapsed < $1.periodSecondsElapsed}
        }
    }
}
