//
//  CompareViewController.swift
//  TrackingStock
//
//  Created by Tatsumi on 11/11/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit
import Charts

class CompareViewController: UIViewController {

    @IBOutlet var stack: UIStackView!

    @IBOutlet var chartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart1()
    }
    func setChart1(){
        let dataPoints = ["AAPL","GOOG"]
        let dataAPPL = ["11","15","9","20"]
         let dataGOOG = ["14","5","7","5"]
        var unitsSold1: Array<ChartDataEntry> = []
        var unitsSold2: Array<ChartDataEntry> = []
        var unitsSold3: Array<ChartDataEntry> = []
        var unitsSold4: Array<ChartDataEntry> = []
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            // do some task
            // var dataEntries: [BarChartDataEntry] = []
            for i in 0..<dataPoints.count {
                if(i == 0){
                    unitsSold4.append(BarChartDataEntry(value: Double(dataAPPL[0])!, xIndex: i))
                    unitsSold1.append(BarChartDataEntry(value: Double(dataAPPL[1])!, xIndex: i))
                    unitsSold2.append(BarChartDataEntry(value: Double(dataAPPL[2])!, xIndex: i))
                    unitsSold3.append(BarChartDataEntry(value: Double(dataAPPL[3])!, xIndex: i))
                }else if(i == 1 ){
                    unitsSold4.append(BarChartDataEntry(value: Double(dataGOOG[0])!, xIndex: i))
                    unitsSold1.append(BarChartDataEntry(value: Double(dataGOOG[1])!, xIndex: i))
                    unitsSold2.append(BarChartDataEntry(value: Double(dataGOOG[2])!, xIndex: i))
                    unitsSold3.append(BarChartDataEntry(value: Double(dataGOOG[3])!, xIndex: i))
                }
                
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
                self.chartView.xAxis.labelPosition = .Bottom
                self.chartView.data = chartData
                self.chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                self.chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
                self.chartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
                self.chartView.setScaleEnabled(false)
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
