//
//  Historical.swift
//  Collection
//
//  Created by Tatsumi on 10/18/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit

class Historical: NSObject {
    var Date: String?
    var Open: String?
    var High: String?
    var Low: String?
    var Close: String?
    var Volume: String?
    var Adj_Close: String?
    
    init(json: NSDictionary){
        if let Date = json["Date"] as? String {
            self.Date = Date
        }else{
            self.Date = "-"
        }
        
        if let Open = json["Open"] as? String {
            self.Open = Open
        }else{
            self.Open = "-"
        }
        
        if let High = json["High"] as? String {
            self.High = High
        }else{
            self.High = "-"
        }
        
        if let Low = json["Low"] as? String {
            self.Low = Low
        }else{
            self.Low = "-"
        }
        
        if let Close = json["Close"] as? String {
            self.Close = Close
        }else{
            self.Close = "-"
        }
        
        if let Volume = json["Volume"] as? String {
            self.Volume = Volume
        }else{
            self.Volume = "-"
        }
        
        if let Adj_Close = json["Adj_Close"] as? String {
            self.Adj_Close = Adj_Close
        }else{
            self.Adj_Close = "-"
        }
        
        
    }
    
}
