//
//  InstrumentMarketPriceViewController.swift
//  inverstors-social-network
//
//  Created by D. on 2018-01-19.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit
import SwiftChart

class InstrumentMarketPriceViewController: UIViewController, ChartDelegate {
    
    var selectedChart = 0
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var lastSharePrice: UILabel!
    @IBOutlet weak var changeNet: UILabel!
    @IBOutlet weak var changePercentage: UILabel!
    @IBOutlet weak var labelLeadingMarginConstraint: NSLayoutConstraint!
    
    fileprivate var labelLeadingMarginInitialConstant: CGFloat!
    
    var dailyQuoteSummaries : [DailyQuoteSummary] = []
    var companyName : String?
    var indexValue : String?
    var changeNetValue : Float = 0
    var changePercentValue : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.companyName
        
        labelLeadingMarginInitialConstant = labelLeadingMarginConstraint.constant
        
        initLabels()
        initChart()
    }
    
    func initLabels() {
        
        self.lastSharePrice.text = indexValue
        
        self.changeNet.text = (self.changeNetValue > 0) ? "+\(String(format: "%.2f", self.changeNetValue))" : "\(String(format: "%.2f", self.changeNetValue))"
        self.changeNet.colorString(text: self.changeNet.text, coloredText: self.changeNet.text, color: (self.changeNetValue > 0) ? UIColor.FlatColor.Green.strongGreen : UIColor.FlatColor.Red.vividPinkRed)
        
        self.changePercentage.text = "\(String(format: "%.2f", self.changePercentValue))%"
        self.changePercentage.colorString(text: self.changePercentage.text, coloredText: self.changePercentage.text, color: (self.changeNetValue > 0) ? UIColor.FlatColor.Green.strongGreen : UIColor.FlatColor.Red.vividPinkRed)
    }
    
    func initChart() {
        
        chart.delegate = self
        
        chart.highlightLineColor  = UIColor.FlatColor.Blue.strongCyan
        chart.gridColor = .clear
        
        // Initialize data series and labels
        let stockValues = getStockValues()
        
        var serieData: [Double] = []
        var labels: [Double] = []
        var labelsAsString: Array<String> = []
        
        // Date formatter to retrieve the month names
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        for (i, value) in stockValues.enumerated() {
            serieData.append(value["close"] as! Double)
            
            // Use only one label for each month
            let month = Int(dateFormatter.string(from: value["date"] as! Date))!
            let monthAsString:String = dateFormatter.shortMonthSymbols[month - 1]

            if((month % 2) == 0) {
                if (labels.count == 0 || !labelsAsString.contains(monthAsString)) {
                    labels.append(Double(i))
                    labelsAsString.append(monthAsString)
                }
            }
        }
        
        let series = ChartSeries(serieData)
        series.area = true
        series.color =  UIColor.FlatColor.Green.strongGreen
        
        // Configure chart layout
        chart.lineWidth = 0.5
        chart.labelFont = UIFont.systemFont(ofSize: 10)
        chart.xLabels = labels
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return labelsAsString[labelIndex]
        }
        chart.xLabelsTextAlignment = .center
        chart.yLabelsOnRightSide = true
        
        // Add some padding above the x-axis
        chart.minY = serieData.min()! - 5
        
        chart.add(series)
        
    }
    
    // Chart delegate
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
            label.text = "\(String(format: "%.2f", value))"
            
            // Align the label to the touch left position, centered
            var constant = labelLeadingMarginInitialConstant + left - (label.frame.width / 2)
            
            // Avoid placing the label on the left of the chart
            if constant < labelLeadingMarginInitialConstant {
                constant = labelLeadingMarginInitialConstant
            }
            
            // Avoid placing the label on the right of the chart
            let rightMargin = chart.frame.width - label.frame.width 
            if constant > rightMargin {
                constant = rightMargin
            }
            
            labelLeadingMarginConstraint.constant = constant
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        label.text = ""
        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    func getStockValues() -> Array<Dictionary<String, Any>> {
        
        // Parse data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var values : Array<Dictionary<String, Any>> = [[:]]
        values.removeAll()
        dailyQuoteSummaries.forEach({
            
            summary in
            
            let close = Double(summary.close)
            let date = summary.date
            
            values.append(["date": date!, "close": close])
        })
        
        return values
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
    }
}
