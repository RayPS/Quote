//
//  ViewController.swift
//  GoldenQuote
//
//  Created by Ray on 6/11/15.
//  Copyright (c) 2015 RayPS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var QuoteView: SpringView!
    @IBOutlet weak var QuoteUITextView: UITextView!
    
    var QuoteFakeUITextView: UITextView!
    
    var gradient = CAGradientLayer()
    var maskTextView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuoteFakeUITextView = UITextView(frame: CGRectZero)
        QuoteFakeUITextView.font = UIFont(name: "HiraKakuProN-W3", size: 20)
        QuoteFakeUITextView.autocorrectionType = UITextAutocorrectionType.No
        QuoteFakeUITextView.spellCheckingType = UITextSpellCheckingType.No
        QuoteFakeUITextView.textAlignment = .Center
        QuoteFakeUITextView.backgroundColor = UIColor.clearColor()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    @IBAction func shareButtonDidTouch(sender: AnyObject) {
        
        let image = QuoteView.pb_takeSnapshot()
        let shareMenu = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        presentViewController(shareMenu, animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !maskTextView {
            
            gradient.frame = QuoteUITextView.frame
            QuoteFakeUITextView.frame = QuoteUITextView.bounds
            QuoteFakeUITextView.text = QuoteUITextView.text
            
            gradient.colors = [UIColor(red:0, green:0.46, blue:1, alpha:1.0).CGColor, UIColor(red:0.91, green:0.28, blue:0.5, alpha:1.0).CGColor]
            gradient.locations = [0.0,1.0];
            gradient.mask =  QuoteFakeUITextView.layer
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            
            QuoteView.layer.addSublayer(gradient)
            
        }
        
    }
    
}

extension ViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        
        if text == "\n" {
            textView.resignFirstResponder()
            QuoteView.y = 0
            QuoteView.animateTo()
            return false
        }
        return true
    }
    
    func textViewDidChange(newtextView: UITextView) {
        
        println("text did change")
        
        QuoteFakeUITextView.text = QuoteUITextView.text
        gradient.frame = QuoteUITextView.frame
        QuoteFakeUITextView.bounds = QuoteUITextView.bounds
        
        
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        QuoteView.y = -200
        QuoteView.animateTo()
    }
    
    
}







































extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
