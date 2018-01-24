//
//  StockQuotePeriod+CoreDataProperties.swift
//  
//
//  Created by D. on 2018-01-22.
//
//

import Foundation
import CoreData


extension StockQuotePeriod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockQuotePeriod> {
        return NSFetchRequest<StockQuotePeriod>(entityName: "StockQuotePeriod")
    }

    @NSManaged public var companyName: String?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var dailyQuoteSummary: NSSet?

}

// MARK: Generated accessors for dailyQuoteSummary
extension StockQuotePeriod {

    @objc(addDailyQuoteSummaryObject:)
    @NSManaged public func addToDailyQuoteSummary(_ value: DailyQuoteSummary)

    @objc(removeDailyQuoteSummaryObject:)
    @NSManaged public func removeFromDailyQuoteSummary(_ value: DailyQuoteSummary)

    @objc(addDailyQuoteSummary:)
    @NSManaged public func addToDailyQuoteSummary(_ values: NSSet)

    @objc(removeDailyQuoteSummary:)
    @NSManaged public func removeFromDailyQuoteSummary(_ values: NSSet)

}
