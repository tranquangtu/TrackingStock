//
//  View.swift
//  Collection
//
//  Created by Tatsumi on 10/17/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit

class HistoricalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate{
    var menuView: BTNavigationDropdownMenu!
    var code: String!
    
    @IBOutlet var btnCode: UIBarButtonItem!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    var arrHistorical: [Historical] = []
    var getHistorical: GetHistorical = GetHistorical()
    var iBool: Bool = false
    let items = ["7-Day", "30-Day", "3-Month", "6-Month","1-Year"]


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.btnCode.title = self.code
        menuView = BTNavigationDropdownMenu(title: items.first!, items: items)
        menuView.cellHeight = 50
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            self.load(indexPath)
            
        }
        self.navigationItem.titleView = menuView
        //arrHistorical = getHistorical.GetStockArray("aapl", dayS: "2015-06-13", dayE: "2015-10-17")
        load(0)
    }
    override func viewWillAppear(animated: Bool) {
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    func alertView(){
        let alertView = UIAlertController(title: "Warring!!!", message: "No data!", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    func formatDay(value: Int)->[String]{
        var arr:[String] = []
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = NSDate()
        arr.append(dateFormatter.stringFromDate(today))
        switch(value){
        case 0:
            let desDate = today.dateByAddingTimeInterval(-7*24*60*60)
            arr.append(dateFormatter.stringFromDate(desDate))
            break
        case 1:
            let desDate = today.dateByAddingTimeInterval(-30*24*60*60)
            arr.append(dateFormatter.stringFromDate(desDate))
            break
        case 2:
            let desDate = today.dateByAddingTimeInterval(-90*24*60*60)
            arr.append(dateFormatter.stringFromDate(desDate))
            break
        case 3:
            let desDate = today.dateByAddingTimeInterval(-180*24*60*60)
            arr.append(dateFormatter.stringFromDate(desDate))
            break
        case 4:
            let desDate = today.dateByAddingTimeInterval(-365*24*60*60)
            arr.append(dateFormatter.stringFromDate(desDate))
            break
        default:
            let desDate = today.dateByAddingTimeInterval(-24*60*60)
            arr.append(dateFormatter.stringFromDate(desDate))
            break
        }
        return arr
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(iBool){
            return arrHistorical.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: HistoricalCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HistoricalCell
        
        cell.lbDate.text = arrHistorical[indexPath.row].Date
        cell.lbOpen.text = String.localizedStringWithFormat(" %.02f", Float(arrHistorical[indexPath.row].Open!)!)
        cell.lbHigh.text = String.localizedStringWithFormat(" %.02f", Float(arrHistorical[indexPath.row].High!)!)
        cell.lbLow.text = String.localizedStringWithFormat(" %.02f", Float(arrHistorical[indexPath.row].Low!)!)
        cell.lbClose.text = String.localizedStringWithFormat(" %.02f", Float(arrHistorical[indexPath.row].Close!)!)
        cell.lbVolume.text = arrHistorical[indexPath.row].Volume
        cell.lbAdj_Close.text = String.localizedStringWithFormat(" %.02f", Float(arrHistorical[indexPath.row].Adj_Close!)!)
        return cell
    }
    
    func load(value: Int){
        var count: Int = 0
        indicator.hidden = false
        indicator.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            // do some task
            count = self.getData(value)
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                if(count > 0){
                    self.tableView.reloadData()
                }else{
                    print("khong co du lieu")
                    self.alertView()
                    self.arrHistorical = []
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    func getData(value: Int)-> Int{
        var arrDay:[String] = []
        arrDay = formatDay(value)
        arrHistorical = getHistorical.GetStockArray(self.code, dayS: arrDay[arrDay.count - 1], dayE: arrDay[0])
        iBool = true
        return arrHistorical.count
    }
//    func getPastDates(days: Int) -> [String] {
//        
//        var dates: [String] = []
//        
//        let cal = NSCalendar.currentCalendar()
//        
//        var today = cal.startOfDayForDate(NSDate())
//        
//        for i in 0 ... days {
//            let day = cal.component(.Day, fromDate: today)
//            let month = cal.component(.Month, fromDate: today)
//            let year = cal.component(.Year, fromDate: today)
//            let str: String = String(year) + "-" + String(month) + "-" + String(day)
//            dates.append(str)
//            // move back in time by one day:
//            today = cal.dateByAddingUnit(.Day, value: -1, toDate: today, options: NSCalendarOptions.WrapComponents)!
//        }
//        
//        return dates
//        
//    }
//    
    
}
