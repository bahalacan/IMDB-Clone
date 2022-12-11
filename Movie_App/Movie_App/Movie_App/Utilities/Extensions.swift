//
//  Extensions.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 10.08.2022.
//

import Foundation
import UIKit

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = spinnerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        spinnerView.insertSubview(blurEffectView, at: 0)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
    }
}

