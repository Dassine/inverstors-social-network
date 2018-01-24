//
//  InstrumentsTableViewController.swift
//  inverstors-social-network
//
//  Created by D. on 2018-01-19.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit
import CoreData

class InstrumentsTableViewController: UITableViewController {
    
    let cellIdentifier = "instrumentCell"
    
    var coreDataStack: CoreDataStack!
    
    let instruments = ["GOOGL" : "Alphabet Inc.", "AAPL" : "Apple Inc.", "TSLA" : "Tesla Inc.", "TWTR" : "Twitter Inc", "FB" : "Facebook, Inc."]
    var stockQuotePeriods : [StockQuotePeriod] = []
    
    
    var valueTotal : Float = 0
    var changeNetTotal : Float = 0
    var changePercentageTotal : Float = 0
    
    let notificationName = Notification.Name("QuandlError")
    
    @IBOutlet weak var indexValueTotal: UILabel!
    @IBOutlet weak var changeNetAndPercent: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    let loadingView : LoadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coreDataStack = CoreDataStack()
    
        //Remove seperators for empty cells
        tableView.tableFooterView = UIView()
        
        //Adde refresh control
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        //Add ManagedObjectContext Observer
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        
        //Request Quandl data for each instrument
        extractAllStockQuotes((Any).self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func resetAll() {
        
        //Flush all the data
        coreDataStack.deleteAllRecords()
        
        //Reset stockQuotePeriods and all totals
        stockQuotePeriods.removeAll()
        valueTotal = 0
        changeNetTotal = 0
        changePercentageTotal = 0
        
    }
    @objc func quandlErrorHandler() {
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.loadingView.hideOverlayView()
            self.tryAgainButton.isHidden = false
        })
    }
    
    @IBAction func extractAllStockQuotes(_ sender: Any) {
        //Reset all the data
        resetAll()
        
        loadingView.showLoading(view: self.tableView)
        self.tryAgainButton.isHidden = true
        
        //Add Quandl error observer
        NotificationCenter.default.addObserver(self, selector: #selector(quandlErrorHandler), name: notificationName, object: nil)
        
        if stockQuotePeriods.isEmpty {
            for (key, _) in instruments {
                self.extractQuandlInfo(for: key)
            }
        }
    }
    
    func extractQuandlInfo(for symbol: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: endDate)!
        
        QuandlAPIClient.sharedClient.performDataPersistAPIRequest(with: symbol, startDate: startDate, endDate: endDate)
    }
    
    func sort(allSummaries: [DailyQuoteSummary], ascending:Bool) -> [DailyQuoteSummary] {
        
        let expression = (!ascending) ? {($0 as AnyObject).date.timeIntervalSinceNow > (($1 as AnyObject).date?.timeIntervalSinceNow)!} :  {($0 as AnyObject).date.timeIntervalSinceNow < ($1 as AnyObject).date.timeIntervalSinceNow}
        
        return allSummaries.sorted(by:expression)
    }
    
    func changeNet(finalPrice: Float, openPrice: Float) -> Float {
        return (finalPrice - openPrice)
    }
    
    func changePercentage(finalPrice: Float, openPrice: Float) -> Float {
        return ((finalPrice - openPrice)/openPrice)*100
    }
    
    func update(withPrice: Float, changeNet: Float, changePercentage: Float) {
        valueTotal += withPrice
        indexValueTotal.text = "$\(valueTotal)"
        
        //update change net and percentage
        changeNetTotal += changeNet
        changePercentageTotal += changePercentage
        
        let changeNetTotalString = (changeNetTotal > 0) ? "+\(String(format: "%.2f", changeNetTotal))" : "\(String(format: "%.2f", changeNetTotal))"
        
        let changeNetPercentageTotal =  "\(changeNetTotalString) (\(String(format: "%.2f", changePercentageTotal))%)"
        changeNetAndPercent.text = "Today’s Gain / Loss: \(changeNetPercentageTotal)"
        changeNetAndPercent.colorString(text: changeNetAndPercent.text, coloredText: changeNetPercentageTotal, color: (changeNetTotal > 0) ? UIColor.FlatColor.Green.strongGreen : UIColor.FlatColor.Red.vividPinkRed)
        
    }
    @objc private func refresh() {
        
        refreshControl?.endRefreshing()
        extractAllStockQuotes((Any).self)
    }
    
    // MARK: - Observer
    
    @objc func contextDidSave(_ notification: Notification) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "QuandlError"), object: nil)
        
        if (notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>) != nil {
            
            let stockQuotePeriodFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "StockQuotePeriod")
            do {
                let fetchedStockQuotePeriods = try coreDataStack?.managedContext.fetch(stockQuotePeriodFetch)
                
                if (fetchedStockQuotePeriods?.count)! == instruments.count && stockQuotePeriods.isEmpty  {
                    fetchedStockQuotePeriods?.forEach({
                        stock in
                        stockQuotePeriods.append(stock as! StockQuotePeriod)
                    })
                    
                    tableView.beginUpdates()
                    
                    loadingView.hideOverlayView()
                    tableView.reloadData()
                    
                    tableView.endUpdates()
                }
            } catch {
                fatalError("Failed to fetch employees: \(error)")
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instruments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InstrumentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of InstrumentTableViewCell.")
        }
        
        if stockQuotePeriods.count > 0 {
            let stock = stockQuotePeriods[indexPath.row]
            
            //Sort all Instrument summaries
            let sortedAllSummaries =  self.sort(allSummaries: stock.dailyQuoteSummary?.allObjects as! [DailyQuoteSummary], ascending: false)
            
            //Calculate changes
            let changeNetValue = self.changeNet(finalPrice: sortedAllSummaries[0].close, openPrice: sortedAllSummaries[1].close)
            let changePercentValue = self.changePercentage(finalPrice: sortedAllSummaries[0].close, openPrice: sortedAllSummaries[1].close)
            
            //setup cell
            cell.setup(withName: instruments[stock.companyName!]!,
                       symbol: stock.companyName!,
                       indexValue: ((sortedAllSummaries.first)?.close)!,
                       changeNet: changeNetValue,
                       changePercentage: changePercentValue)
            
            //update index value total lable
            update(withPrice: sortedAllSummaries[0].close, changeNet: changeNetValue, changePercentage: changePercentValue)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInstrumentMarketPrice" {
            
            let cell = sender as! InstrumentTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let stock = stockQuotePeriods[(indexPath?.row)!]
            
            let sortedAllSummaries =  self.sort(allSummaries: stock.dailyQuoteSummary?.allObjects as! [DailyQuoteSummary], ascending: true)
            (segue.destination as! InstrumentMarketPriceViewController).dailyQuoteSummaries = sortedAllSummaries
            
            (segue.destination as! InstrumentMarketPriceViewController).companyName = cell.name.text
            (segue.destination as! InstrumentMarketPriceViewController).indexValue = cell.indexValue.text
            (segue.destination as! InstrumentMarketPriceViewController).changeNetValue = cell.changeNetValue
            (segue.destination as! InstrumentMarketPriceViewController).changePercentValue = cell.changePercentValue
        }
    }
}
