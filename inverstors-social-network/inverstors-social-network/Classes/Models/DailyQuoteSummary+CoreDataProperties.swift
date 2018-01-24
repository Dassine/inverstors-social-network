//
//  DailyQuoteSummary+CoreDataProperties.swift
//  
//
//  Created by D. on 2018-01-22.
//
//

import Foundation
import CoreData


extension DailyQuoteSummary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyQuoteSummary> {
        return NSFetchRequest<DailyQuoteSummary>(entityName: "DailyQuoteSummary")
    }

    @NSManaged public var adjustedClose: Float
    @NSManaged public var adjustedHigh: Float
    @NSManaged public var adjustedLow: Float
    @NSManaged public var adjustedOpen: Float
    @NSManaged public var adjustedVolume: Int64
    @NSManaged public var close: Float
    @NSManaged public var date: NSDate?
    @NSManaged public var exDividend: Int64
    @NSManaged public var high: Float
    @NSManaged public var low: Float
    @NSManaged public var open: Float
    @NSManaged public var splitRatio: Float
    @NSManaged public var volume: Int64
    @NSManaged public var stockQuotePeriod: StockQuotePeriod?

}
