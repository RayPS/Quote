//
//  AlertViewController.swift
//  Quote
//
//  Created by Ray on 6/15/15.
//  Copyright (c) 2015 RayPS. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    var afterDismissAction: (() -> Void)?
    
    @IBOutlet weak var AlertView: DesignableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func noButtonDidTouch(sender: AnyObject) {
        dissmissAlert(false)
    }
    
    @IBAction func yesButtonDidTouch(sender: AnyObject) {
        dissmissAlert(true)
        
    }
    
    
    func dissmissAlert(clear: Bool) {
        AlertView.animation = "fall"
        AlertView.animateNext{
            self.dismissViewControllerAnimated(true, completion: {
                if clear {
                    self.afterDismissAction?()
                }
            })
        }
    }
}
