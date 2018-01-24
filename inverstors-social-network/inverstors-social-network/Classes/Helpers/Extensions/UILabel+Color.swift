//
//  UILabel+Color.swift
//  inverstors-social-network
//
//  Created by D. on 2018-01-21.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

extension UILabel {
    
    func colorString(text: String?, coloredText: String?, color: UIColor? = .red) {
        
        let attributedString = NSMutableAttributedString(string: text!)
        let range = (text! as NSString).range(of: coloredText!)
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor: color!],
                                       range: range)
        self.attributedText = attributedString
    }
    
}
