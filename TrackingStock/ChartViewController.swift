//
//  ChartViewController.swift
//  Collection
//
//  Created by Tatsumi on 10/19/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    var menuView: BTNavigationDropdownMenu!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var btnMACD: UIButton!
    @IBOutlet var btnRSI: UIButton!
    @IBOutlet var btnP_SAR: UIButton!
    
    @IBOutlet var imageView: UIImageView!
    var image: UIImage!
    var code: String!
    
    @IBOutlet var stackView: UIStackView!
    var bMACD: Bool  = false
    var bRSI: Bool = false
    var bP_SAR: Bool = false
    let items = ["1-Day", "5-Day", "3-Month", "6-Month","1-Year"]
    let arrtimeSpan = ["1d","5d","3m","6m","1y"]
    var timeSpan: String!
    var iFull: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        timeSpan = arrtimeSpan[0]
        
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
            self.timeSpan = self.arrtimeSpan[indexPath]
            self.loadMain()
            
        }
        self.navigationItem.titleView = menuView
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    func imageTapped(img: AnyObject)
    {
        if(iFull){
            iFull = false
            self.navigationController?.navigationBarHidden = false
            self.stackView.hidden = false
        }else{
            iFull = true
            self.navigationController?.navigationBarHidden = true
            self.stackView.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        self.loadMain()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadMain(){
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            print("ngang")
            self.ScaleImage(1)
        }
        
        else if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("doc")
            self.ScaleImage(0)
        }
    }

    @IBAction func btnRefresh(sender: AnyObject) {
        self.loadMain()
       
    }
    @IBAction func aP_SAR(sender: AnyObject) {
        if(!bP_SAR){
            bP_SAR = true
            btnP_SAR.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        }else{
            bP_SAR = false
            btnP_SAR.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func aRSI(sender: AnyObject) {
        if(!bRSI){
            bRSI = true
            btnRSI.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        }else{
            bRSI = false
            btnRSI.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func aMACD(sender: AnyObject) {
        if(!bMACD){
            bMACD = true
            btnMACD.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        }else{
            bMACD = false
            btnMACD.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }

    }
    
    func ScaleImage(value: Int){
        let arrBool: [Bool] = [bMACD,bRSI,bP_SAR]
        var image: UIImage = UIImage()
        self.indicator.hidden = false
        self.indicator.isAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            if(value == 0){
//                if(!self.bP_SAR && !self.bRSI && !self.bMACD){
//                    self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height*0.3)
//                }else if((self.bMACD && !self.bRSI && !self.bP_SAR) || (!self.bMACD && self.bRSI && !self.bP_SAR) || (!self.bMACD && !self.bRSI && self.bP_SAR)){
//                    self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height*0.5)
//                }else if((self.bMACD && self.bRSI && !self.bP_SAR) || (self.bMACD && !self.bRSI && self.bP_SAR) || (!self.bMACD && self.bRSI && self.bP_SAR)){
//                    self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height*0.7)
//                }else{
//                    self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
//                }
//                
                image = self.loadImage(self.timeSpan, Symbol: self.code, size: "s", arrBool: arrBool)
                self.imageView.contentMode = UIViewContentMode.ScaleToFill
                
            }else{
//                self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
                image = self.loadImage(self.timeSpan, Symbol: self.code, size: "m", arrBool: arrBool)
                self.imageView.contentMode = UIViewContentMode.ScaleToFill
            }

            dispatch_async(dispatch_get_main_queue()) {
                self.image = image
                self.imageView.image = self.image
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                
            }
        }

        
    }
    func loadImage(timeSpan: String, Symbol: String, size: String, arrBool: [Bool])->UIImage{
        var temp: String = "&a="
        if(arrBool[0]){
            temp = temp + "m26-12-9,"
        }
        if(arrBool[1]){
            temp = temp + "r14,"
        }
        if(arrBool[2]){
            temp = temp + "p"
        }
        let  path: String  = "http://chart.finance.yahoo.com/z?s=" +  Symbol + "&t=" +  timeSpan + "&q=l&l=on&z=" + size + temp
        print(path)
        var image : UIImage = UIImage()
        let url:NSURL = NSURL(string: path.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        do{
            let data:NSData = try NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30), returningResponse: nil)
            image = UIImage(data: data)!
            
        } catch let error as NSError {
            print(error)
        }
        
        return image
    }
}
