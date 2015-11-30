//
//  StockData+CoreDataProperties.swift
//  TrackingStock
//
//  Created by Tatsumi on 10/15/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension StockData {

    @NSManaged var symbol: String?
    @NSManaged var name: String?

}
