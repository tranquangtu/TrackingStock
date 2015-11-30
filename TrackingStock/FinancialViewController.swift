//
//  FinancialViewController.swift
//  TrackingStock
//
//  Created by Tatsumi on 11/30/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit
import Kanna

class FinancialViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //
    var code: String = ""
    // Menu
    var menuView: BTNavigationDropdownMenu!
    let items = ["Income Statement", "Balance Sheet", "Cash Flow"]
    //
    var arrDataIS: Array<dataFinancal> = Array<dataFinancal>()
    var arrData: Array<dataFinancal> = Array<dataFinancal>()
    var arrDataCF: Array<dataFinancal> = Array<dataFinancal>()
    var html = NSString()
    var nodes: XMLNodeSet!
    ///
    @IBOutlet var btnCode: UIBarButtonItem!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var lbHeading: UILabel!
    @IBOutlet var lbTime1: UILabel!
    @IBOutlet var lbTime2: UILabel!
    @IBOutlet var lbTime3: UILabel!
    @IBOutlet var tableView: UITableView!
    //
    var iBoolIS: Bool = false
    var iBoolBS: Bool = false
    var iBoolCF: Bool = false
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        self.btnCode.title = self.code
        menuView = BTNavigationDropdownMenu(title: items.first!, items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            if(indexPath == 0){
                self.parsingis()
            }else if(indexPath == 1){
                self.parsingbs()
                
            }else{
                self.parsingcf()
            }
            
        }
        self.navigationItem.titleView = menuView
        parsingis()
        
    }
    override func viewWillAppear(animated: Bool) {
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func startIndicator(){
        self.indicator.hidden = false
        self.indicator.startAnimating()
        
    }
    func stopIndicator(){
        self.indicator.stopAnimating()
        
    }
    func fixData(str: String)->String{
        var temp: String!
        temp = str.stringByReplacingOccurrencesOfString(" ", withString: "")
        temp = temp.stringByReplacingOccurrencesOfString("\n", withString: "")
        temp = temp.stringByReplacingOccurrencesOfString(",000", withString: "k")
        return temp
    }
    func parsingcf(){
        self.startIndicator()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            self.iBoolBS = false
            self.iBoolIS = false
            let url = "http://finance.yahoo.com/q/cf?s=" + self.code + "+Cash+Flow&annual"
            let path = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
            do {
                self.html = try NSString(contentsOfURL: path!, encoding: NSUTF8StringEncoding)
            } catch{print(error)}
            if let doc = Kanna.HTML(html: self.html as String, encoding: NSUTF8StringEncoding){
                //print(doc.title)
                self.nodes = doc.xpath("//table[@class='yfnc_tabledata1']/tr/td/table/tr")
                for i in 0...29{
                    if(i == 0 || i == 1){
                        var temp: Array<String> = Array<String>()
                        for node in self.nodes[i].css("td"){
                            temp.append(node.text!)
                        }
                        self.arrDataCF.append(dataFinancal(heading: self.fixData(temp[0]), value1: self.fixData(temp[1]), value2: self.fixData(temp[2]), value3: self.fixData(temp[3])))
                    }else if(i == 3 || i == 13 || i == 20){
                        for node in self.nodes[i].css("td"){
                            self.arrDataCF.append(dataFinancal(heading: node.text!, value1: "", value2: "", value3: ""))
                        }
                        
                    }else if((i > 3 && i < 10) || i == 11 || (i > 13 && i < 17 ) || i == 18 || (i > 20 && i < 25 ) || i == 26 || i == 27 || i == 29){
                        var temp: Array<String> = Array<String>()
                        for node in self.nodes[i].css("td"){
                            temp.append(node.text!)
                        }
                        self.arrDataCF.append(dataFinancal(heading: self.fixData(temp[0]), value1: self.fixData(temp[1]), value2: self.fixData(temp[2]), value3: self.fixData(temp[3])))
                    }
                    
                }
                self.iBoolCF = true
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.lbHeading.text = self.arrDataCF[0].heading
                self.lbTime1.text = self.arrDataCF[0].value1
                self.lbTime2.text = self.arrDataCF[0].value2
                self.lbTime3.text = self.arrDataCF[0].value3
                
                self.tableView.reloadData()
                self.stopIndicator()
                
            }
        }

       
        
    }
    
    ///
    func parsingis(){
        self.startIndicator()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            self.iBoolBS = false
            self.iBoolCF = false
            let url = "http://finance.yahoo.com/q/is?s=" + self.code + "+Income+Statement&annual"
            let path = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
            do {
                self.html = try NSString(contentsOfURL: path!, encoding: NSUTF8StringEncoding)
            } catch{print(error)}
            if let doc = Kanna.HTML(html: self.html as String, encoding: NSUTF8StringEncoding){
                //print(doc.title)
                self.nodes = doc.xpath("//table[@class='yfnc_tabledata1']/tr/td/table/tr")
                for i in 0...37{
                    if(i == 0){
                        var temp: Array<String> = Array<String>()
                        for node in self.nodes[i].css("td"){
                            temp.append(node.text!)
                        }
                        for node in self.nodes[i].css("th"){
                            temp.append(node.text!)
                        }
                        self.arrDataIS.append(dataFinancal(heading: self.fixData(temp[0]), value1: self.fixData(temp[1]), value2: self.fixData(temp[2]), value3: self.fixData(temp[3])))
                    }else if(i == 6 || i == 17 || i == 27){
                        for node in self.nodes[i].css("td"){
                            self.arrDataIS.append(dataFinancal(heading: node.text!, value1: "", value2: "", value3: ""))
                        }
                        
                    }else if(i == 1 || i == 2 || i == 4 || i == 15 || i == 34 || i == 35 || i == 37){
                        var temp: Array<String> = Array<String>()
                        for node in self.nodes[i].css("td"){
                            temp.append(node.text!)
                        }
                        self.arrDataIS.append(dataFinancal(heading: self.fixData(temp[0]), value1: self.fixData(temp[1]), value2: self.fixData(temp[2]), value3: self.fixData(temp[3])))
                        
                    }else if((i > 6 && i < 11) || i == 12 || (i > 17 && i < 24 ) || i == 25 || (i > 27 && i < 32 )){
                        var temp: Array<String> = Array<String>()
                        for node in self.nodes[i].css("td"){
                            temp.append(node.text!)
                        }
                        self.arrDataIS.append(dataFinancal(heading: self.fixData(temp[1]), value1: self.fixData(temp[2]), value2: self.fixData(temp[3]), value3: self.fixData(temp[4])))
                        //
                    }
                    
                }
            }

            
            dispatch_async(dispatch_get_main_queue()) {
                self.iBoolIS = true
                self.lbHeading.text = self.arrDataIS[0].heading
                self.lbTime1.text = self.arrDataIS[0].value1
                self.lbTime2.text = self.arrDataIS[0].value2
                self.lbTime3.text = self.arrDataIS[0].value3
                self.tableView.reloadData()
                self.stopIndicator()
            }
        }
        
    }
    
    //
    
    func parsingbs(){
        self.startIndicator()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            self.iBoolIS = false
            self.iBoolCF = false
            let url = "http://finance.yahoo.com/q/bs?s=" + self.code + "+Balance+Sheet&annual"
            let path = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
            do {
                self.html = try NSString(contentsOfURL: path!, encoding: NSUTF8StringEncoding)
            } catch{print(error)}
            if let doc = Kanna.HTML(html: self.html as String, encoding: NSUTF8StringEncoding){
                self.nodes = doc.xpath("//table[@class='yfnc_tabledata1']/tr/td/table/tr")
                for i in 0...48{
                    if(i == 0){
                        var temp: Array<String> = Array<String>()
                        for node in self.nodes[i].css("td"){
                            temp.append(node.text!)
                        }
                        self.arrData.append(dataFinancal(heading: self.fixData(temp[0]), value1: self.fixData(temp[1]), value2: self.fixData(temp[2]), value3: self.fixData(temp[3])))
                    }else if(i == 2 || i == 3 || i == 21 || i == 22 || i == 36 ){
                        for node in self.nodes[i].css("td"){
                            self.arrData.append(dataFinancal(heading: node.text!, value1: "", value2: "", value3: ""))
                        }
                        
                    }else if((i > 3 && i < 9) || (i > 22 && i < 26 )){
                        var temp: Array<String> = Array<String>()
                        for node in self.nodes[i].css("td"){
                            temp.append(node.text!)
                        }
                        self.arrData.append(dataFinancal(heading: self.fixData(temp[1]), value1: self.fixData(temp[2]), value2: self.fixData(temp[3]), value3: self.fixData(temp[4])))
                        
                    }else if((i > 9 && i < 18) || (i > 26 && i < 33 ) || (i > 36 && i < 45 ) || i == 19 || i == 34 || i == 46 || i == 48){
                        var temp: Array<String> = Array<String>()
                        for node in self.nodes[i].css("td"){
                            temp.append(node.text!)
                            print(node.text)
                        }
                        self.arrData.append(dataFinancal(heading: self.fixData(temp[0]), value1: self.fixData(temp[1]), value2: self.fixData(temp[2]), value3: self.fixData(temp[3])))
                        
                    }
                    
                }
            }

            
            dispatch_async(dispatch_get_main_queue()) {
                self.iBoolBS = true
                self.lbHeading.text = self.arrData[0].heading
                self.lbTime1.text = self.arrData[0].value1
                self.lbTime2.text = self.arrData[0].value2
                self.lbTime3.text = self.arrData[0].value3
                self.tableView.reloadData()
                self.stopIndicator()
                
            }
        }
        
    }
    ///
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(iBoolBS){
            return arrData.count
        }else if(iBoolIS){
            return arrDataIS.count
        }else if (iBoolCF){
            return arrDataCF.count
        }
        return 0
    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellData : celldata = tableView.dequeueReusableCellWithIdentifier("celldata", forIndexPath: indexPath) as! celldata
        
        let temp = indexPath.row
        if(iBoolBS){
            cellData.heading.text = arrData[temp].heading
            cellData.value1.text = arrData[temp].value1
            cellData.value2.text = arrData[temp].value2
            cellData.value3.text = arrData[temp].value3
            if(temp == 0 || temp == 1 || temp == 8 || temp == 16 || temp == 17 || temp == 22 || temp == 28 || temp == 29 || temp == 38 || temp == 39){
                cellData.heading.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                cellData.value1.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                cellData.value2.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                cellData.value3.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                
            }else{
                cellData.heading.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
                cellData.value1.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
                cellData.value2.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
                cellData.value3.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
            }
            if(temp == 0){
                cellData.heading.backgroundColor = UIColor.redColor()
                cellData.value1.backgroundColor = UIColor.redColor()
                cellData.value2.backgroundColor = UIColor.redColor()
                cellData.value3.backgroundColor = UIColor.redColor()
            }
            else if(temp == 1 || temp == 17 || temp == 29){
                cellData.heading.backgroundColor = UIColor.blueColor()
                cellData.value1.backgroundColor = UIColor.blueColor()
                cellData.value2.backgroundColor = UIColor.blueColor()
                cellData.value3.backgroundColor = UIColor.blueColor()
            }else{
                cellData.heading.backgroundColor = UIColor.whiteColor()
                cellData.value1.backgroundColor = UIColor.whiteColor()
                cellData.value2.backgroundColor = UIColor.whiteColor()
                cellData.value3.backgroundColor = UIColor.whiteColor()
            }
            
        }else if(iBoolIS){
            cellData.heading.text = arrDataIS[temp].heading
            cellData.value1.text = arrDataIS[temp].value1
            cellData.value2.text = arrDataIS[temp].value2
            cellData.value3.text = arrDataIS[temp].value3
            if(temp == 0 || temp == 1 || temp == 3 || temp == 5 || temp == 11 || temp == 13 || temp == 22 || temp == 27 || temp == 29){
                cellData.heading.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                cellData.value1.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                cellData.value2.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                cellData.value3.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                
            }else{
                cellData.heading.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
                cellData.value1.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
                cellData.value2.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
                cellData.value3.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
            }
            if(temp == 0){
                cellData.heading.backgroundColor = UIColor.redColor()
                cellData.value1.backgroundColor = UIColor.redColor()
                cellData.value2.backgroundColor = UIColor.redColor()
                cellData.value3.backgroundColor = UIColor.redColor()
            }
            else if(temp == 5 || temp == 13 || temp == 22){
                cellData.heading.backgroundColor = UIColor.blueColor()
                cellData.value1.backgroundColor = UIColor.blueColor()
                cellData.value2.backgroundColor = UIColor.blueColor()
                cellData.value3.backgroundColor = UIColor.blueColor()
            }else{
                cellData.heading.backgroundColor = UIColor.whiteColor()
                cellData.value1.backgroundColor = UIColor.whiteColor()
                cellData.value2.backgroundColor = UIColor.whiteColor()
                cellData.value3.backgroundColor = UIColor.whiteColor()
            }
        }else if(iBoolCF){
            cellData.heading.text = arrDataCF[temp].heading
            cellData.value1.text = arrDataCF[temp].value1
            cellData.value2.text = arrDataCF[temp].value2
            cellData.value3.text = arrDataCF[temp].value3
            if(temp == 0 || temp == 1 || temp == 2 || temp == 9 || temp == 10 || temp == 14 || temp == 15 || temp == 20 || temp == 22){
                cellData.heading.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                cellData.value1.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                cellData.value2.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                cellData.value3.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
                
            }else{
                cellData.heading.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
                cellData.value1.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
                cellData.value2.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
                cellData.value3.font = UIFont (name: "GILLSANSCE-ROMAN", size: 15)
            }
            if(temp == 0){
                cellData.heading.backgroundColor = UIColor.redColor()
                cellData.value1.backgroundColor = UIColor.redColor()
                cellData.value2.backgroundColor = UIColor.redColor()
                cellData.value3.backgroundColor = UIColor.redColor()
            }
            else if(temp == 2 || temp == 10 || temp == 15){
                cellData.heading.backgroundColor = UIColor.blueColor()
                cellData.value1.backgroundColor = UIColor.blueColor()
                cellData.value2.backgroundColor = UIColor.blueColor()
                cellData.value3.backgroundColor = UIColor.blueColor()
            }else{
                cellData.heading.backgroundColor = UIColor.whiteColor()
                cellData.value1.backgroundColor = UIColor.whiteColor()
                cellData.value2.backgroundColor = UIColor.whiteColor()
                cellData.value3.backgroundColor = UIColor.whiteColor()
            }
        }
        return cellData
        
    }





}
