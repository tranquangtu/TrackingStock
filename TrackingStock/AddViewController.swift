//
//  AddViewController.swift
//  TrackingStock
//
//  Created by Tatsumi on 10/15/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UITableViewController, NSFetchedResultsControllerDelegate , UISearchBarDelegate{
    
    var stocks: [Stock] = []
    var iChoice: Int = -1
    var getStock: GetStock = GetStock()
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    var iSearch: Bool = false
    var queue: dispatch_queue_t  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    var timer: NSTimer  = NSTimer()
    var textSearch : String = ""
    
    // var stocks: Stocks? = nil
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var frc: NSFetchedResultsController = NSFetchedResultsController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //txtSearch.addTarget(self, action: "Searching", forControlEvents: .EditingChanged)

        // Do any additional setup after loading the view.
    }

    func searchBar(_searchBar: UISearchBar,textDidChange searchText: String){
        _searchBar.delegate = self
        self.textSearch = searchText
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "Search", userInfo: nil, repeats: false)
    }
    func Search(){
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            self.stocks = self.getStock.SearchStocks(self.textSearch)
            dispatch_sync(dispatch_get_main_queue()) {
                // update some UI
                self.tableView.reloadData()
            }
        }

    }


        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = stocks[indexPath.row].Symbol
        cell.detailTextLabel?.text = stocks[indexPath.row].Name
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        iChoice = indexPath.row
    }


    
    @IBAction func aSave(sender: AnyObject) {
            self.createNewStock()
        
    }
    
    func loadData1(str: String)->Int{
        let fetchRequest = NSFetchRequest(entityName: "StockData")
        fetchRequest.predicate = NSPredicate(format: "symbol = %@", str.uppercaseString)
        var num: Int = 0
        var formQuestions = [Stock]()
        do{
            formQuestions = try moc.executeFetchRequest(fetchRequest) as! [Stock]
            num = formQuestions.count
            
        }catch{
            return num
        }
        return num
        
    }
    
    
    
    func createNewStock(){
        if(iChoice > -1){
            if(loadData1(self.stocks[iChoice].Symbol!) == 0){
                let entityDescription = NSEntityDescription.entityForName("StockData", inManagedObjectContext: moc)
                let stock = StockData(entity: entityDescription!, insertIntoManagedObjectContext: moc)
                stock.symbol = self.stocks[iChoice].Symbol?.uppercaseString
                stock.name = self.stocks[iChoice].Name
                iChoice = -1
                do {
                    
                    try moc.save()
                    let alertView = UIAlertController(title: "Notify", message: "This Stock was Saved.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alertView, animated: true, completion: nil)
                    
                }catch{
                    
                    return
                    
                }
                
            }else{
                let alertView = UIAlertController(title: "Notify", message: "This Stock is Exist.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alertView, animated: true, completion: nil)
            }
            
        }else{
            let alertView = UIAlertController(title: "Notify", message: "No Stock being Choosen.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
            
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
