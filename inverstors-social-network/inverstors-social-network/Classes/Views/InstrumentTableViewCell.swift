//
//  InstrumentTableViewCell.swift
//  inverstors-social-network
//
//  Created by D. on 2018-01-19.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

class InstrumentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var indexValue: UILabel!
    @IBOutlet weak var changeNet: UILabel!
    @IBOutlet weak var changePercent: UILabel!
    
    var changeNetValue : Float = 0
    var changePercentValue : Float = 0
    
    let separatorHeight : CGFloat = 2
    let xMargin : CGFloat = 18
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(withName: String, symbol: String, indexValue: Float, changeNet: Float, changePercentage: Float) {
        
        changeNetValue = changeNet
        changePercentValue = changePercentage
        
        self.name.text = withName
        self.symbol.text = symbol
        self.indexValue.text = "$\(indexValue)"
        
        self.changeNet.text = (changeNetValue > 0) ? "+\(String(format: "%.2f", changeNetValue))" : "\(String(format: "%.2f", changeNetValue))"
        self.changeNet.colorString(text: self.changeNet.text, coloredText: self.changeNet.text, color: (changeNetValue > 0) ? UIColor.FlatColor.Green.strongGreen : UIColor.FlatColor.Red.vividPinkRed)
        
        self.changePercent.text = "\(String(format: "%.2f", self.changePercentValue))%"
        self.changePercent.colorString(text: self.changePercent.text, coloredText: self.changePercent.text, color: (self.changeNetValue > 0) ? UIColor.FlatColor.Green.strongGreen : UIColor.FlatColor.Red.vividPinkRed)
    }
}
