//
//  JSONReader.swift
//  inverstors-social-network
//
//  Created by D. on 2018-01-20.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit
import CoreData

class JSONReader{
    
    var coreDataStack: CoreDataStack!
    var modelName: String?
    
    lazy var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    init(){
        self.coreDataStack = CoreDataStack()
    }
    
    func saveDailyQuote(forStockQuotePeriod stockQuotePeriod: StockQuotePeriod, dailyQuote: [Any]){
        //Parse  JSON data
        let dailyQuoteSummary = DailyQuoteSummary(context: self.coreDataStack.managedContext)
        
        if let dateStr = (dailyQuote[0] as? String), let date = dateFormatter.date(from: dateStr){
            dailyQuoteSummary.date = date as NSDate
        }
        
        dailyQuoteSummary.open = (dailyQuote[1] as! NSNumber).floatValue
        dailyQuoteSummary.high = (dailyQuote[2] as! NSNumber).floatValue
        dailyQuoteSummary.low = (dailyQuote[3] as! NSNumber).floatValue
        dailyQuoteSummary.close = (dailyQuote[4] as! NSNumber).floatValue
        dailyQuoteSummary.volume = (dailyQuote[5] as! NSNumber).int64Value
        dailyQuoteSummary.exDividend = (dailyQuote[6] as! NSNumber).int64Value
        dailyQuoteSummary.splitRatio = (dailyQuote[7] as! NSNumber).floatValue
        dailyQuoteSummary.adjustedOpen = (dailyQuote[8] as! NSNumber).floatValue
        dailyQuoteSummary.adjustedHigh = (dailyQuote[9] as! NSNumber).floatValue
        dailyQuoteSummary.adjustedLow = (dailyQuote[10] as! NSNumber).floatValue
        dailyQuoteSummary.adjustedClose = (dailyQuote[11] as! NSNumber).floatValue
        dailyQuoteSummary.adjustedVolume = (dailyQuote[12] as! NSNumber).int64Value
        
        stockQuotePeriod.addToDailyQuoteSummary(dailyQuoteSummary)
    }
    
    func saveQuandlData(forCompanyName companyName: String, forJSONResponseDict jsonResponseDict: [String: Any]){
        
        DispatchQueue.main.async {
            guard let dataDict = jsonResponseDict["dataset_data"] as? [String: Any] else {
                print("Error: unable to save data due to inability to extract data dictionary  from JSON response")
                return
            }
            
            //Save Stock Quote Period
            let stockQuotePeriod = StockQuotePeriod(context: self.coreDataStack.managedContext)
            
            let startDateStr = dataDict["start_date"] as! String
            let endDateStr = dataDict["end_date"] as! String
            
            stockQuotePeriod.startDate = self.dateFormatter.date(from: startDateStr)! as NSDate
            stockQuotePeriod.endDate = self.dateFormatter.date(from: endDateStr)! as NSDate
            
            stockQuotePeriod.companyName = companyName
            
            self.coreDataStack.saveContext()
            
            //Save Daily Quote Summaries
            guard let dailyQuotes = dataDict["data"] as? [[Any]] else {
                print("Error: unable to retrieve daily quotes from JSON data")
                return
            }
            
            dailyQuotes.forEach({
                dailyQuote in
                self.saveDailyQuote(forStockQuotePeriod: stockQuotePeriod, dailyQuote: dailyQuote)
            })
            
            self.coreDataStack.saveContext()
        }
    }
}

