//
//  DisplayScoresViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 11/14/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift
import JTAppleCalendar
import SVProgressHUD

class DisplayScoresViewController: UIViewController
{
    // MARK: Outlets
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var showTodayButton: UIBarButtonItem!
    @IBOutlet weak var scoreView: UITableView!
    
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    
    let databaseManager = DatabaseManager()
    let networkManager = NetworkManager()
    
    var nhlSchedules: Results<NHLSchedule>? = nil
    
    var selectedGameId = 0
    
    // MARK: Config
    let formatter = DateFormatter()
    let dateFormatterString = "yyyy MM dd"
    let numOfRowsInCalendar = 6
    let numOfRandomEvent = 100
    let calendarCellIdentifier = "CellView"
    let scoreCellIdentifier = "scoreCell"
    
    var selectedDate = Date()
    
    private let refreshControl = UIRefreshControl()
    
    var iii: Date?
    
    // MARK: Helpers
    var numOfRowIsSix: Bool
    {
        get
        {
            return calendarView.visibleDates().outdates.count < 7
        }
    }
    
    var currentMonthSymbol: String
    {
        get
        {
            let startDate = (calendarView.visibleDates().monthDates.first?.date)!
            let month = Calendar.current.dateComponents([.month], from: startDate).month!
            let monthString = DateFormatter().monthSymbols[month-1]
            
            return monthString
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupViewNibs()
        showTodayButton.target = self
        showTodayButton.action = #selector(showTodayWithAnimate)
        showToday(animate: false)
        
        let gesturer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        calendarView.addGestureRecognizer(gesturer)
        
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Updating scores...")
        
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *)
        {
            scoreView.refreshControl = refreshControl
        }
        else
        {
            scoreView.addSubview(refreshControl)
        }

        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshScoreData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshScoreData(_ sender: Any)
    {
        self.fetchScoreData()
    }
    
    func fetchScoreData()
    {
        networkManager.updateScheduleForDate(selectedDate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            self.refreshControl.endRefreshing()
            self.nhlSchedules = self.databaseManager.retrieveScoresAsNHLSchedules(self.selectedDate)
            self.scoreView.reloadData()
        }
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer)
    {
        let point = gesture.location(in: calendarView)
        
        guard let cellStatus = calendarView.cellStatus(at: point) else
        {
            return
        }
        
        if calendarView.selectedDates.first != cellStatus.date
        {
            calendarView.deselectAllDates()
            calendarView.selectDates([cellStatus.date])
        }
    }
    
    func setupViewNibs()
    {
        let myNib = UINib(nibName: "CellView", bundle: Bundle.main)
       calendarView.register(myNib, forCellWithReuseIdentifier: calendarCellIdentifier)
        
        let myNib2 = UINib(nibName: "ScoreCell", bundle: Bundle.main)
        scoreView.register(myNib2, forCellReuseIdentifier: scoreCellIdentifier)
        
        let myNib3 = UINib(nibName: "ScheduleTableViewCell", bundle: Bundle.main)
        scoreView.register(myNib3, forCellReuseIdentifier: "detail")
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo)
    {
        guard let startDate = visibleDates.monthDates.first?.date else
        {
            return
        }
        
        let year = Calendar.current.component(.year, from: startDate)
        
        title = "\(currentMonthSymbol) \(year)"
    }
}

// MARK: Helpers
extension DisplayScoresViewController
{
    func select(onVisibleDates visibleDates: DateSegmentInfo)
    {
        guard let firstDateInMonth = visibleDates.monthDates.first?.date else
        { return }
        
        if firstDateInMonth.isThisMonth()
        {
            calendarView.selectDates([Date()])
        }
        else
        {
            calendarView.selectDates([firstDateInMonth])
        }
    }
}

// MARK: Button events
extension DisplayScoresViewController
{
    @objc func showTodayWithAnimate()
    {
        showToday(animate: true)
    }
    
    func showToday(animate:Bool)
    {
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: animate, preferredScrollPosition: nil, extraAddedOffset: 0)
        {
            [unowned self] in
            
            self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            }
            
            self.adjustCalendarViewHeight()
            self.calendarView.selectDates([Date()])
        }
    }
}

// MARK: Dynamic CalendarView's height
extension DisplayScoresViewController
{
    func adjustCalendarViewHeight()
    {
        adjustCalendarViewHeight(higher: self.numOfRowIsSix)
    }
    
    func adjustCalendarViewHeight(higher: Bool)
    {
        separatorViewTopConstraint.constant = higher ? 0 : -calendarView.frame.height / CGFloat(numOfRowsInCalendar)
    }
}

// MARK: CalendarCell's ui config
extension DisplayScoresViewController
{
    func configureCell(view: JTAppleCell?, cellState: CellState)
    {
        guard let myCustomCell = view as? CellView else { return }
        
        myCustomCell.dayLabel.text = cellState.text
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        
        myCustomCell.isHidden = cellHidden
        myCustomCell.selectedView.backgroundColor = UIColor.black
        
        if Calendar.current.isDateInToday(cellState.date)
        {
            myCustomCell.selectedView.backgroundColor = UIColor.red
        }
        
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        handleCellSelection(view: myCustomCell, cellState: cellState)
        
        myCustomCell.eventView.isHidden = true
    }
    
    func handleCellSelection(view: CellView, cellState: CellState)
    {
        view.selectedView.isHidden = !cellState.isSelected
    }
    
    func handleCellTextColor(view: CellView, cellState: CellState)
    {
        if cellState.isSelected
        {
            view.dayLabel.textColor = UIColor.white
        }
        else
        {
            view.dayLabel.textColor = UIColor.black
            
            if cellState.day == .sunday || cellState.day == .saturday
            {
                view.dayLabel.textColor = UIColor.gray
            }
        }
        
        if Calendar.current.isDateInToday(cellState.date)
        {
            if cellState.isSelected
            {
                view.dayLabel.textColor = UIColor.white
            }
            else
            {
                view.dayLabel.textColor = UIColor.red
            }
        }
    }
}

// MARK: JTAppleCalendarViewDataSource
extension DisplayScoresViewController: JTAppleCalendarViewDataSource
{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters
    {
        formatter.dateFormat = dateFormatterString
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2030 02 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numOfRowsInCalendar,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: true)
        return parameters
    }
}

// MARK: JTAppleCalendarViewDelegate
extension DisplayScoresViewController: JTAppleCalendarViewDelegate
{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath)
    {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calendarCellIdentifier, for: indexPath) as! CellView
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell
    {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calendarCellIdentifier, for: indexPath) as! CellView
        configureCell(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo)
    {
        setupViewsOfCalendar(from: visibleDates)
        if visibleDates.monthDates.first?.date == iii
        {
            return
        }
        
        iii = visibleDates.monthDates.first?.date
        
        select(onVisibleDates: visibleDates)
        
        view.layoutIfNeeded()
        
        adjustCalendarViewHeight()
        
        UIView.animate(withDuration: 0.5)
        { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState)
    {
        selectedDate = date
        
        networkManager.updateScheduleForDate(date)
        
        nhlSchedules = databaseManager.retrieveScoresAsNHLSchedules(date)
            
        configureCell(view: cell, cellState: cellState)
        scoreView.contentOffset = CGPoint()
        scoreView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState)
    {
        configureCell(view: cell, cellState: cellState)
    }
}

// MARK: UITableViewDataSource
extension DisplayScoresViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(nhlSchedules?.count == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! ScheduleTableViewCell
            cell.selectionStyle = .default
            cell.noteLabel.text = "No games scheduled"
            cell.startTimeLabel.text = ""
            cell.endTimeLabel.text = ""
            cell.titleLabel.text = ""
            cell.noteLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            cell.categoryLine.isHidden = true
            
            scoreView.rowHeight = CGFloat(40.0)
            scoreView.separatorStyle = .none
            
            return cell
        }
        else
        {
            let schedule = nhlSchedules![indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoreCell
            cell.scheduledGame = schedule
            
            scoreView.rowHeight = CGFloat(130.0)
            
            if(schedule.playedStatus == PlayedStatusEnum.completed.rawValue && schedule.date != TimeAndDateUtils.getCurrentDateAsString())
            {
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .blue
                tableView.allowsSelection = true
            }
            else
            {
                cell.accessoryType = .none
                cell.selectionStyle = .none
                tableView.allowsSelection = false
            }
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nhlSchedules?.count == 0 ? 1 : nhlSchedules?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let schedule = nhlSchedules![indexPath.row]
        
        selectedGameId = schedule.id
        
        print("Selected gameId is: \(selectedGameId)")
        
        networkManager.saveScoringSummary(forGameId: selectedGameId)
        
        SVProgressHUD.show(withStatus: "Loading...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
        {
            self.databaseManager.displayGameLog(self, self.selectedGameId)
            SVProgressHUD.dismiss()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let displayGameLogViewController = segue.destination as! DisplayGameLogViewController
        
        print("Selected game id in prepare for segue is \(selectedGameId)")
        
        displayGameLogViewController.gameLogResult = sender as? NHLGameLog
        
        displayGameLogViewController.selectedGameId = selectedGameId
    }
}
