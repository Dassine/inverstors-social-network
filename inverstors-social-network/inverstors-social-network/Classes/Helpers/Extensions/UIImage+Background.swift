//
//  UIImage+Background.swift
//  inverstors-social-network
//
//  Created by D. on 2018-01-23.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

extension UIImage {

     class func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
}
