//
//  GetHistorical.swift
//  Collection
//
//  Created by Tatsumi on 10/18/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit

class GetHistorical: NSObject {
    var Symbol: String!
    let url : String  =  "https://query.yahooapis.com/v1/public/yql?q="
    
    func GetStockArray(Symbol: String, dayS: String, dayE: String)-> [Historical]{
        var stock: [Historical] = []
        var query: String = "select * from yahoo.finance.historicaldata where symbol ='" + Symbol + "' and startDate = '" + dayS + "' and endDate = '" + dayE + "' "
        query = query + "&format=json&env=store://datatables.org/alltableswithkeys&callback="
        let  url = self.url + query
        let endpoint = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        
        print(url)
        do {
            let data = try NSData(contentsOfURL: endpoint!)
            if(data != nil){
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                //print(jsonResult)
                if let jsonResult = jsonResult{
                    if let a = jsonResult["query"] as? NSDictionary{
                        if let b = a["results"] as? NSDictionary{
                            if let items = b["quote"] as? NSArray{
                                for item in items{
                                    let app = Historical(json: item as! NSDictionary)
                                    stock.append(app)
                                }
                            }
                            
                        }
                    }
                    
                }
                
            }
            
        } catch let error as NSError {
            //print(error)
        }
        print("success")
        
        return stock
        
    }
    
    
}
