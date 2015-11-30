//
//  MainViewController.swift
//  TrackingStock
//
//  Created by Tatsumi on 10/15/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit
import CoreData


class MainViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,NSFetchedResultsControllerDelegate{
    
    
    @IBOutlet var btnFinancial: UIButton!
    @IBOutlet var btnTotalChart: UIButton!
    @IBOutlet var viewFunc: UIView!
    @IBOutlet var btnChart: UIButton!
    @IBOutlet var btnHistorical: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var scrollview: UIScrollView!
    let conn: Reachability = Reachability()
    var arrStock: [String] = []
    var viewchart:ChartView = ChartView()
    var viewdata: DataView = DataView()
    var getStock: GetStock = GetStock()
    var arrDataStock: [Stock] = []
    var ChoiceSymbol: String!
    var ChoiceTimeSpan: String!
    var iSelect : Bool = false
    var numSelect: Int = 0
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    ///
    var pageControl = UIPageControl()
    let BETWEEN_WIDTH = CGFloat(5)
    let NUMPAGES = 2
    var iBool: Bool = false
    var barColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
    let  moc  = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var iLoad: Bool = false

//    override func shouldAutorotate() -> Bool {
//        return true
//    }
    func btnDisable(){
        self.btnChart.enabled = false
        self.btnFinancial.enabled = false
        self.btnHistorical.enabled = false
        self.btnTotalChart.enabled = false
    }
    func btnEnable(){
        self.btnChart.enabled = true
        self.btnFinancial.enabled = true
        self.btnHistorical.enabled = true
        self.btnTotalChart.enabled = true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnDisable()
        iLoad = true
        scrollview.backgroundColor = UIColor.blackColor()
        pageControl.numberOfPages = NUMPAGES
        self.viewFunc.backgroundColor = self.barColor
        //
        self.navigationController?.navigationBar.barTintColor = UIColor(red: CGFloat(0x27)/255
            ,green: CGFloat(0x35)/255
            ,blue: CGFloat(0x4B)/255
            ,alpha: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "backgroundchart"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        scrollview.contentSize = CGSizeMake((self.view.frame.size.width)
            * CGFloat(NUMPAGES) , self.view.frame.size.height*0.3)
        
        scrollview.pagingEnabled = true // ページするオプションを有効にするための設定
        scrollview.scrollEnabled = true
        scrollview.directionalLockEnabled = true
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.showsVerticalScrollIndicator = true
        scrollview.bounces = true
        scrollview.scrollsToTop = false
        scrollview.delegate = self
        ///
        self.navigationItem.titleView = pageControl
        //
        viewchart = ChartView(frame: CGRect(x: 0, y: 0,
            width: self.view.frame.size.width , height: self.view.frame.size.height*0.3))
        //redView.backgroundColor = UIColor.redColor()
        viewchart.btn1D.addTarget(self, action: "ChoosingChart:", forControlEvents: UIControlEvents.TouchUpInside)
        viewchart.btn5D.addTarget(self, action: "ChoosingChart:", forControlEvents: UIControlEvents.TouchUpInside)
        viewchart.btn1M.addTarget(self, action: "ChoosingChart:", forControlEvents: UIControlEvents.TouchUpInside)
        viewchart.btn6M.addTarget(self, action: "ChoosingChart:", forControlEvents: UIControlEvents.TouchUpInside)
        viewchart.btn1Y.addTarget(self, action: "ChoosingChart:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollview.addSubview(viewchart)
        
        
        viewdata = DataView(frame: CGRect(x: self.view.frame.size.width, y: 0,
            width: self.view.frame.size.width, height: self.view.frame.size.height*0.3))
        viewdata.backgroundColor = UIColor.whiteColor()
        scrollview.addSubview(viewdata)
        let num = self.getCoreData()
        self.tableView.reloadData()
        if(conn.isConnectedToNetwork()){
            self.viewchart.loadbutton("1d")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
                // do some task
                self.loadFirst(num)
                let image: UIImage = self.loadImage("1d", Symbol: self.ChoiceSymbol)
                //self.getdata()
                dispatch_async(dispatch_get_main_queue()) {
                    // update some UI
                    self.viewchart.imageView.image =  image
                    self.loadDataView(0)
                    self.tableView.reloadData()
                    
                }
            }

        }else{
            self.alertView("No Internet Access!!")
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)){
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        }
    }
    override func viewDidAppear(animated: Bool) {
        print("2")
       // self.iBool = false
        
        if(self.conn.isConnectedToNetwork()){
            if(!iLoad){
                self.btnDisable()
                self.arrStock = []
                self.arrDataStock = []
                self.viewchart.loadbutton("1d")
                let num = self.getCoreData()
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
                    // do some task
                    self.loadFirst(num)
                    let image: UIImage = self.loadImage("1d", Symbol: self.ChoiceSymbol)
                    //self.getdata()
                    dispatch_async(dispatch_get_main_queue()) {
                        // update some UI
                        self.viewchart.imageView.image = image
                        self.tableView.reloadData()
                    }
                }
            }
        }else{
            self.alertView("No Internet Access!!")
        }
    }
    func suffixNumber(str: String) -> NSString {
        if(str != "-"){
            var num: Double = Double(str)!
            let sign = ((num < 0) ? "-" : "" )
            
            num = fabs(num);
            
            if (num < 1000.0){
                return "\(sign)\(num)"
            }
            
            let exp:Int = Int(log10(num) / log10(1000))
            
            let units:[String] = ["K","M","B"]
            
            let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10
            
            return "\(sign)\(roundedNum)\(units[exp-1])"
            
        }

        return "-"
    }
    
    func loadDataView(index: Int!){
        if(self.arrDataStock.count > 0 ){
            viewdata.lbName.text = arrDataStock[index].Name
            viewdata.lbAVG.text = suffixNumber(arrDataStock[index].ADV!) as String
            viewdata.lbCap.text = arrDataStock[index].MC
            viewdata.lbHigh.text = arrDataStock[index].DH
            viewdata.lbLow.text = arrDataStock[index].DL
            viewdata.lbOpen.text = arrDataStock[index].Open
            viewdata.lbVol.text = suffixNumber(arrDataStock[index].Vol!) as String
            viewdata.lbYH.text = arrDataStock[index].YH
            viewdata.lbYL.text = arrDataStock[index].YL

            
        }
    }
    func getCoreData() ->Int{
        let fetchRequest = NSFetchRequest(entityName: "StockData")
        fetchRequest.returnsObjectsAsFaults = false
        var num: Int = 0
        do{
            let results = try moc.executeFetchRequest(fetchRequest)
            num = results.count
            print(num)
            if(num > 0){
                for result in results as! [NSManagedObject] {
                    let stock = Stock(Symbol: result.valueForKey("symbol") as! String, Name: result.valueForKey("name") as! String)
                    self.arrDataStock.append(stock)
                }
                print(self.arrDataStock.count)

            }
            
        }catch{
            return 0
        }
        return num
        
    }
    func loadFirst(num : Int){
        
        if(num > 0){
            if(num == 1){
                self.arrStock.append(self.arrDataStock[0].Symbol!)
                self.arrDataStock = []
                self.arrDataStock.append(self.getStock.GetAStock(self.arrStock[0]))
            }else{
                for i in 0...(num - 1){
                    self.arrStock.append(self.arrDataStock[i].Symbol!)
                }
                self.arrDataStock = self.getStock.GetStockArray(self.arrStock)
            }
            self.ChoiceSymbol =  self.arrStock[0]
            self.iBool = true
        }
        
    }
    func getdata(){
            if(self.arrStock.count > 0){
                self.tableView.reloadData()
                if(self.arrStock.count == 1 ){
                    self.arrDataStock.append(self.getStock.GetAStock(self.arrStock[0]))
                }else{
                    self.arrDataStock = self.getStock.GetStockArray(self.arrStock)
                }
                self.iBool = true
            }
    }
    @IBAction func ChoosingChart(sender : UIButton){
        self.viewchart.imageView.image = UIImage(named: "loading.png")
        let btn = sender as UIButton
        let str = btn.titleLabel?.text!.lowercaseString
        self.viewchart.loadbutton(str!)
        dispatch_async(dispatch_get_global_queue(priority, 0)){
            // do some task
            let image : UIImage = self.loadImage(str!, Symbol: self.ChoiceSymbol)
            dispatch_async(dispatch_get_main_queue()) {
                self.viewchart.imageView.image = image
            }
        }
        
    }

    func loadImage(timeSpan: String, Symbol: String)->UIImage{
        
        let  path: String  = "http://chart.finance.yahoo.com/z?s=" +  Symbol + "&t=" +  timeSpan + "&q=l&l=on&z=s"
        print(path)
        var image : UIImage = UIImage()
        let url:NSURL = NSURL(string: path.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        do{
            let data:NSData = try NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30), returningResponse: nil)
            image = UIImage(data: data)!
            
        } catch let error as NSError {
            print(error)
            return UIImage(named: "loading.png")!
        }
        
        return image
    }
    
    func scrollViewDidScroll(scrollview: UIScrollView) {
        let pageWidth : CGFloat = self.scrollview.frame.size.width
        let fractionalPage : Double = Double(self.scrollview.contentOffset.x / pageWidth)
        let page : NSInteger = lround(fractionalPage)
        self.pageControl.currentPage = page;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///Tìm dấu
    func changeColor(str: String)->Bool{
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // if(iBool){
            return arrDataStock.count
       // }
       // return arrStock.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        if(iBool){
            cell.lbCode.text = arrDataStock[indexPath.row].Symbol
            cell.lbName.text = arrDataStock[indexPath.row].Name
            cell.lbPrice.text = arrDataStock[indexPath.row].LTP
            cell.lbMC.text = arrDataStock[indexPath.row].MC
            if(arrDataStock[indexPath.row].Change != nil){
                let temp : String  = arrDataStock[indexPath.row].Change!
                if(temp.containsString("+") == true){
                    cell.lbPercent.textColor = UIColor.greenColor()
                }else{
                    cell.lbPercent.textColor = UIColor.redColor()
                }
                cell.lbPercent.text = arrDataStock[indexPath.row].Change
            }else{
                cell.lbPercent.text = "-"
            }
        }else if(arrDataStock.count > 0){
            cell.lbCode.text = arrDataStock[indexPath.row].Symbol
            cell.lbName.text = arrDataStock[indexPath.row].Name
            cell.lbPrice.text = "-"
            cell.lbMC.text = "-"
            cell.lbPercent.text = "-"
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(self.iBool){
            self.btnEnable()
            self.numSelect = indexPath.row
            self.viewchart.loadbutton("1d")
            //var image: UIImage!
            self.viewchart.imageView.image = UIImage(named: "loading.png")
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                self.ChoiceSymbol = self.arrDataStock[indexPath.row].Symbol
                //image = self.loadImage("1d", Symbol: self.ChoiceSymbol)
                // do some task
                let image : UIImage = self.loadImage("1d", Symbol: self.ChoiceSymbol)
                dispatch_async(dispatch_get_main_queue()) {
                    self.viewchart.imageView.image = image
                    self.loadDataView(indexPath.row)
                }
            }

        }
        
    }
    // màu
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func alertView(str: String){
        let alertView = UIAlertController(title: "Warring!!!", message: str, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                 if segue.identifier == "historical"{
                    iLoad = true
                    if let destinationVC = segue.destinationViewController as? HistoricalViewController{
                        destinationVC.code = arrDataStock[self.numSelect].Symbol
                    }
                }else if segue.identifier == "chart"{
                    iLoad = true
                    if let destinationVC = segue.destinationViewController as? ChartViewController{
                        destinationVC.code = arrDataStock[self.numSelect].Symbol
                    }
                 }else if segue.identifier == "total"{
                    iLoad = true
                    if let destinationVC = segue.destinationViewController as? TotalChartViewController{
                        destinationVC.arrayStock = arrDataStock
                    }
                    
                 }else if(segue.identifier == "financial"){
                    iLoad = true
                    if let destinationVC = segue.destinationViewController as? FinancialViewController{
                        destinationVC.code = arrDataStock[self.numSelect].Symbol!
                    }
                    
                 }else{
                    iLoad = false
                }
        
        }
}
