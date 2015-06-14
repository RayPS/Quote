//
//  ViewController.swift
//  Quote
//
//  Created by Ray on 6/11/15.
//  Copyright (c) 2015 RayPS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var QuoteView: SpringView!
    @IBOutlet weak var QuoteUITextView: UITextView!
    @IBOutlet weak var ShareButton: SpringButton!
    @IBOutlet weak var Bubble: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    func share() {
        let image = QuoteView.pb_takeSnapshot()
        let shareMenu = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        
        shareMenu.completionWithItemsHandler = { activity, success, items, error in
            
            if !success {
                println("cancelled")
                return
            } else {
                if activity == UIActivityTypeSaveToCameraRoll {
                    self.bubble("Saved")
                } else {
                    self.bubble("Done")
                }
            }
        }
        
        presentViewController(shareMenu, animated: true, completion: nil)
    }

    func loadRemoteQuote() {
        request(.GET, "http://s.rayps.com/files/quote.json")
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                } else {
                    var json = JSON(json!)
                    self.QuoteUITextView.text = json["quote"].string
                }
        }
    }
    
    func dissmiss(sender: UITextView) {
        sender.resignFirstResponder()
        QuoteView.y = 0
        QuoteView.animateTo()
    }
    
    
    func bubble(title: String) {
        self.Bubble.setTitle(title, forState: UIControlState.Normal)
        self.Bubble.animation = "fadeInDown"
        self.Bubble.animateNext {
            self.Bubble.delay = 1.0
            self.Bubble.y = -20
            self.Bubble.animation = "zoomOut"
            self.Bubble.animateTo()
        }
    }
    
    @IBAction func shareButtonTouchDown(sender: AnyObject) {
        ShareButton.scaleX = 1.5
        ShareButton.scaleY = 1.5
        ShareButton.duration = 0.4
        ShareButton.animateToNext{
            self.share()
        }
    }
    
    @IBAction func shareButtonTouchUp(sender: AnyObject) {
        ShareButton.scaleX = 1.0
        ShareButton.scaleY = 1.0
        ShareButton.delay = 0.2
        ShareButton.duration = 0.2
        ShareButton.animateTo()
    }
    @IBAction func dissmissButtonDidTouch(sender: AnyObject) {
        dissmiss(QuoteUITextView)
    }
}













extension ViewController: UITextViewDelegate {
    
    // Dissmiss keyboard
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            dissmiss(textView)
            return false
        }
        if textView.contentSize.height > 316 {
//            return false
        }
        
        textView.textContainer.maximumNumberOfLines = 9;
        textView.textContainer.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        return true
    }
    
//    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        println("textViewShouldBeginEditing")
//
//        return true
//    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        println("textViewDidBeginEditing")
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        QuoteView.y = -(screenSize.height * 0.5 - screenSize.width * 0.5)
        QuoteView.animateTo()
        
//        textView.becomeFirstResponder()
//        textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.endOfDocument)

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
