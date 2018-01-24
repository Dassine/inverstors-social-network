//
//  LoadingView.swift
//  inverstors-social-network
//
//  Created by D. on 2018-01-23.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView


public class LoadingView: UIView, NVActivityIndicatorViewable {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var activityIndicatorView : NVActivityIndicatorView!
    var tryAgainButton : UIButton!
    
    var shared: LoadingView {
        struct Static {
            static let instance: LoadingView = LoadingView()
        }
        return Static.instance
    }
    
    public func showLoading(view: UIView!) {
        //Set overlay view
        overlayView = UIView(frame: UIScreen.main.bounds)
        let colors = [UIColor.FlatColor.Blue.vividCyanBlue, UIColor.FlatColor.Blue.strongCyan]
        overlayView.layer.addGradient(colors: colors)
        overlayView.alpha = 0.75
        
        //set activity indicator
        let frame = CGRect(x: view.center.x-20, y: view.center.y-20, width: 40, height: 40)
        activityIndicatorView = NVActivityIndicatorView(frame: frame,type: NVActivityIndicatorType(rawValue: 19)!)
        overlayView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        activityIndicatorView.stopAnimating()
        overlayView.removeFromSuperview()
    }

}
