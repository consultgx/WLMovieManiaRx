//
//  Utility.swift
//  WLMovieMania
//
//  Created by Dhall, Gautam on 4/21/17.
//  Copyright © 2017 GD. All rights reserved.
//

import Foundation
import UIKit

class OverlayProgress{
    
    let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)

    var isShowing = false
    
    class var shared: OverlayProgress {
        struct Static {
            static let instance: OverlayProgress = OverlayProgress()
        }
        return Static.instance
    }
    
    func show(_ view: UIViewController) {
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        
        view.present(alert, animated: true, completion: nil)
        
        isShowing = true
    }
    
    func hide(_ view: UIViewController){
        
        alert.dismiss(animated: false, completion: nil)
        isShowing = false
    }
    
    func refresh(_ view: UIViewController) {
        if isShowing
        {
            self.hide(view)
            self.show(view)
        }
        
    }
}
