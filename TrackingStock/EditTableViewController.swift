//
//  EditTableViewController.swift
//  TrackingStock
//
//  Created by Tatsumi on 10/15/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit
import CoreData

class EditTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let  moc  = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var frc: NSFetchedResultsController = NSFetchedResultsController()
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    var iBool: Bool = false
    func fetchRequest() ->NSFetchRequest{
        let fetchRequest = NSFetchRequest(entityName: "StockData")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    func getFRC() -> NSFetchedResultsController{
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.frc = self.getFRC()
            self.frc.delegate = self
            do{
                try self.frc.performFetch()
                self.iBool = true
                
            }catch{
                print("Failed to  perform initial fetch.")
                return
            }
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                self.tableView.reloadData()
            }
        }

        
    }
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.frc = self.getFRC()
            self.frc.delegate = self
            do{
                try self.frc.performFetch()
                self.iBool = true
                
            }catch{
                print("Failed to  perform initial fetch.")
                return
            }
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(iBool){
            let num = frc.sections?.count
            return num!
            
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let num = frc.sections?[section].numberOfObjects
        return num!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let stocks = frc.objectAtIndexPath(indexPath) as! StockData
        cell.textLabel?.text = stocks.symbol
        cell.detailTextLabel?.text = stocks.name
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject: NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
        moc.deleteObject(managedObject)
        do{
            try moc.save()
            frc = getFRC()
            try frc.performFetch()
            tableView.reloadData()
            
            
        }catch{
            print("Failed to save")
            return
        }
        
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        if segue.identifier == "addd"{
        //            let cell = sender as! UITableViewCell
        //            let indexPath = tableView.indexPathForCell(cell)
        //            let stockController: ViewDataController = segue.destinationViewController as! ViewDataController
        //            let stocks: Stocks = frc.objectAtIndexPath(indexPath!) as! Stocks
        //            //stockController.stocks = stocks
        //        }
        
    }
}
