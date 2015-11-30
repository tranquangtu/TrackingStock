//
//  Stock.swift
//  Test
//
//  Created by Tatsumi on 10/12/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

//
//  Stock.swift
//  GetJson
//
//  Created by MICHELE on 10/6/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit

class Stock: NSObject {
    var ADV: String?
    var Change: String?
    var DH: String?
    var DL: String?
    var LTP: String?
    var MC: String?
    var Name: String?
    var Symbol: String?
    var Open: String?
    var PClose: String?
    var PC: String?
    var Vol: String?
    var YH: String?
    var YL: String?
    init(Symbol: String, Name: String){
        self.Name = Name
        self.Symbol = Symbol
    }
    init(json: NSDictionary){
        if let PClose = json["PreviousClose"] as? String {
            self.PClose = PClose
        }else{
            self.PClose = "-"
        }
        if let Open = json["Open"] as? String {
            self.Open = Open
        }else{
            self.Open = "-"
        }

        if let Vol = json["Volume"] as? String {
            self.Vol = Vol
        }else{
            self.Vol = "-"
        }

        if let ADV = json["AverageDailyVolume"] as? String {
            self.ADV = ADV
        }else{
            self.ADV = "-"
        }
        if let Change = json["Change"] as? String {
            self.Change = Change
        }else{
            self.Change = "-"
        }
        if let DL = json["DaysLow"] as? String {
            self.DL = DL
        }else{
            self.DL = "-"
        }
        if let DH = json["DaysHigh"] as? String {
            self.DH = DH
        }else{
            self.DH = "-"
        }
        if let YL = json["YearLow"] as? String {
            self.YL = YL
        }else{
            self.YL = "-"
        }
        if let YH = json["YearHigh"] as? String {
            self.YH = YH
        }else{
            self.YH = "-"
        }

        if let LTP = json["LastTradePriceOnly"] as? String {
            self.LTP = LTP
        }else{
            self.LTP = "-"
        }
        if let Name = json["Name"] as? String {
            self.Name = Name
        }else{
            self.Name = "-"
        }
        if let MC = json["MarketCapitalization"] as? String {
            self.MC = MC
        }else{
            self.MC = "-"
        }
        if let Symbol = json["Symbol"] as? String {
            self.Symbol = Symbol
        }
        
        
    }
    
}

