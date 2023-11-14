//
//  BaseUIViewController.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation
import UIKit

class BaseUIViewController: UIViewController {
    var activityIndicator: UIActivityIndicatorView!
    var activityIndicatorContainer: UIView!
    
    var currentViewController: UIViewController?
    
    func startLoading(isHidden: Bool) {
        if self.activityIndicatorContainer == nil {
            self.setActivityIndicator(viewController: self)
            return
        }
        showActivityIndicator(show: !isHidden)
    }
    
    func showActivityIndicator(show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.currentViewController?.view.addSubview(self.activityIndicatorContainer)
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.activityIndicatorContainer.removeFromSuperview()
            }
        }
    }
    
    func setActivityIndicator(viewController: UIViewController) {
        self.currentViewController = viewController
        DispatchQueue.main.async {
            self.activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            self.activityIndicatorContainer.center.x = viewController.view.center.x
            self.activityIndicatorContainer.center.y = viewController.view.center.y
            self.activityIndicatorContainer.backgroundColor = UIColor.black
            self.activityIndicatorContainer.alpha = 0.8
            self.activityIndicatorContainer.layer.cornerRadius = 10
            
            self.activityIndicator = UIActivityIndicatorView()
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.style = UIActivityIndicatorView.Style.large
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicatorContainer.addSubview(self.activityIndicator)
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.activityIndicatorContainer.centerXAnchor).isActive = true
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.activityIndicatorContainer.centerYAnchor).isActive = true
        }
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
