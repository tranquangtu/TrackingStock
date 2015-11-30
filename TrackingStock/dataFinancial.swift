//
//  dataFinancal.swift
//  parsingHTML
//
//  Created by Tatsumi on 11/29/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit

class dataFinancal: NSObject {
    var heading: String!
    var value1: String!
    var value2: String!
    var value3: String!
    init(heading: String, value1:String , value2: String, value3: String){
        self.heading = heading
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
    }
}
