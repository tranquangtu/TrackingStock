//
//  TotalChartViewController.swift
//  TrackingStock
//
//  Created by Tatsumi on 11/19/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit
import Charts

class TotalChartViewController: UIViewController {
    
    var menuView: BTNavigationDropdownMenu!
    let items = ["MarketCapitalization", "PriceSession", "3-Month", "6-Month","1-Year"]
    var arrayStock: [Stock]!
    var symbols : Array<String> = []
    var unitsSold : Array<String> = []

    @IBOutlet var barChart: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barChart.gridBackgroundColor = UIColor.darkGrayColor()
        for i in 0..<self.arrayStock.count{
            self.symbols.append(self.arrayStock[i].Symbol!)
            
            self.unitsSold.append(self.arrayStock[i].MC!)
        }
        setMenu()
       setMCchart(symbols)
    }
    func setMenu(){
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
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            switch(indexPath){
            case 0:
                self.setMCchart(self.symbols)
                break
            case 1:
                self.setgroupChart(self.symbols)
                break
            default:
                break
            }
            
        }
    }
    func suffixNumber(str: String) -> Double {
        if(str != "-"){
            var num: Double = Double(str)!
          //  let sign = ((num < 0) ? "-" : "" )
            
            num = fabs(num);
            
            if (num < 1000.0){
                return num
            }
            
            let exp:Int = Int(log10(num) / log10(1000))
            
            //let units:[String] = ["K","M","B"]
            
            let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10
            
            return roundedNum
        }
        
        return 0
    }
    func setMCchart(dataPoints: [String]){
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            // do some task

            var arrValues: Array<Double> = []
            for i in 0..<dataPoints.count{
                let temp = self.arrayStock[i].MC!.stringByReplacingOccurrencesOfString("B", withString: "")
                arrValues.append(Double(temp)!)
            }
            var dataEntries: [BarChartDataEntry] = []
            
            for i in 0..<dataPoints.count {
                let dataEntry = BarChartDataEntry(value: arrValues[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            
            let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Bilion")
            let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
           // chartData.setValueTextColor(UIColor.whiteColor())
            chartData.setValueFont(UIFont (name: "ChalkboardSE-Bold", size: 15))
            
            chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
            chartDataSet.colors = ChartColorTemplates.colorful()
            
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                self.barChart.xAxis.labelPosition = .Bottom
                self.barChart.data = chartData
                self.barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                self.barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
                self.barChart.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
                self.barChart.setScaleEnabled(false)
            }
        }

        
    }

    func setgroupChart(dataPoints: [String]){
        var unitsSold1: Array<ChartDataEntry> = []
        var unitsSold2: Array<ChartDataEntry> = []
        var unitsSold3: Array<ChartDataEntry> = []
        var unitsSold4: Array<ChartDataEntry> = []
          self.barChart.noDataText = "You need to provide data for the chart."
        self.barChart.descriptionText = ""
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            // do some task
           // var dataEntries: [BarChartDataEntry] = []
            print(self.arrayStock[0].PC)
            for i in 0..<dataPoints.count {
                unitsSold4.append(BarChartDataEntry(value: Double(self.arrayStock[i].PClose!)!, xIndex: i))
                unitsSold1.append(BarChartDataEntry(value: Double(self.arrayStock[i].LTP!)!, xIndex: i))
                unitsSold2.append(BarChartDataEntry(value: Double(self.arrayStock[i].DH!)!, xIndex: i))
                unitsSold3.append(BarChartDataEntry(value: Double(self.arrayStock[i].DL!)!, xIndex: i))
            }
            let chartDataSet4 = BarChartDataSet(yVals: unitsSold4, label: "PreviousClose")
            chartDataSet4.colors = [UIColor.blackColor()]
            let chartDataSet1 = BarChartDataSet(yVals: unitsSold1, label: "Current")
            chartDataSet1.colors = [UIColor.greenColor()]
            let chartDataSet2 = BarChartDataSet(yVals: unitsSold2, label: "High")
            chartDataSet2.colors = [UIColor.redColor()]
            let chartDataSet3 = BarChartDataSet(yVals: unitsSold3, label: "Low")
             chartDataSet3.colors = [UIColor.grayColor()]
            var dataset: Array<BarChartDataSet> = []
             dataset.append(chartDataSet4)
            dataset.append(chartDataSet1)
            dataset.append(chartDataSet2)
            dataset.append(chartDataSet3)
            let chartData = BarChartData(xVals: dataPoints, dataSets: dataset)
            chartData.setValueFont(UIFont (name: "ChalkboardSE-Bold", size: 8))
            chartData.groupSpace = 1
            

            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                self.barChart.xAxis.labelPosition = .Bottom
                self.barChart.data = chartData
                 self.barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                self.barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
                self.barChart.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
                self.barChart.setScaleEnabled(false)
                
            }
        }

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
