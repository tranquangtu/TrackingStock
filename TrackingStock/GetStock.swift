//
//  GetStock.swift
//  GetJson
//
//  Created by MICHELE on 10/7/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit

class GetStock: NSObject {
    //var Url: String!
    var Symbol: String!
    let url : String  =  "https://query.yahooapis.com/v1/public/yql?q="
    
    // Lấy thông tin về Các Mã cổ phiếu có sẵn
    func GetStockArray(Symbols: NSArray)-> [Stock]{
        var stock: [Stock] = []
        var query: String = "select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20("
        for i in 0...(Symbols.count - 1){
            if i == (Symbols.count - 1){
                query = query + "%22" + (Symbols[i] as! String) + "%22)"
            }else{
                query = query + "%22" + (Symbols[i] as! String) + "%22%2C"
            }
        }
        query = query + "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
        let  url = self.url + query
        let endpoint = NSURL(string: url)
        let data = NSData(contentsOfURL: endpoint!)
        print(url)
        do {
            if(data != nil){
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                if let jsonResult = jsonResult{
                    if let a = jsonResult["query"] as? NSDictionary{
                        if let b = a["results"] as? NSDictionary{
                            if let items = b["quote"] as? NSArray{
                                for item in items{
                                    let app = Stock(json: item as! NSDictionary)
                                    stock.append(app)
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            
        } catch{
        }
        print("success")
        
        return stock
        
    }
    func GetAStock(Symbol: String)-> Stock{
        var stock: Stock!
        let query = "select%20*%20from%20yahoo.finance.quote%20where%20symbol%20=%20%22" + Symbol + "%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
        let url = self.url + query
        let endpoint = NSURL(string: url)
        let data = NSData(contentsOfURL: endpoint!)
        do {
            if(data != nil){
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                //print(jsonResult)
                if let jsonResult = jsonResult{
                    if let a = jsonResult["query"] as? NSDictionary{
                        if let b = a["results"] as? NSDictionary{
                            if let item = b["quote"] as? NSDictionary{
                                stock = Stock(json: item )
                            }
                            
                        }
                    }
                    
                }
                
            }
            
        } catch {
        }
        return stock
        
    }
    func SearchStock(Symbol: String)-> String{
        var stock: Stock!
        let query = "select%20*%20from%20yahoo.finance.quote%20where%20symbol%20=%20%22" + Symbol + "%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
        let url = self.url + query
        let endpoint = NSURL(string: url)
        let data = NSData(contentsOfURL: endpoint!)
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            //print(jsonResult)
            if let jsonResult = jsonResult{
                if let a = jsonResult["query"] as? NSDictionary{
                    if let b = a["results"] as? NSDictionary{
                        if let item = b["quote"] as? NSDictionary{
                            if item["Name"] == nil {
                                return "Không có"
                            }else{
                                stock = Stock(json: item )
                            }
                        }
                        
                    }
                }
                
            }
            
        } catch{
        }
        
        return stock.Name!
    }
    func SearchStocks(Symbol: String)-> [Stock]{
        var stocks: [Stock] = []
        let query = "select * from yahoo.finance.quote where symbol = '" + Symbol + "'&format=json&env=store://datatables.org/alltableswithkeys&callback="
        let url = self.url + query
        let endpoint = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        
        do {
            let data:NSData = try NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: endpoint!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30), returningResponse: nil)
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            //print(jsonResult)
            if let jsonResult = jsonResult{
                if let a = jsonResult["query"] as? NSDictionary{
                    if  a["count"] as! Int == 0{
                        return stocks
                    }else{
                        if let b = a["results"] as? NSDictionary{
                            if let item = b["quote"] as? NSDictionary{
                                let stock: Stock = Stock(json: item )
                                if stock.Name != "-"{
                                    stocks.append(stock)
                                    return stocks
                                }
                            }
                                
                            else if let items = b["quote"] as? NSArray{
                                for item in items{
                                    let app: Stock = Stock(json: item as! NSDictionary)
                                    if app.Name != "-" {
                                        stocks.append(app)
                                    }
                                    
                                }
                                return stocks
                            }
                            
                        }
                        
                    }
                }
                
            }
            
            
        } catch let error as NSError{
            print(error)
        }
        
        
        return stocks
    }

    
    
}
