//
//  ComposeViewController.swift
//  Twiletter
//
//  Created by subdiox on 2017/12/08.
//  Copyright © 2017年 subdiox. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var draftButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var textView: UITextView!
    @IBOutlet var keyboardConstraint: NSLayoutConstraint!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var photoLibraryButton: UIButton!
    @IBOutlet var tweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
        profileImageButton.setTemplate(color: .gray)
        draftButton.setTemplate(color: .gray)
        closeButton.setTemplate(color: .systemBlue)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        cameraButton.setTemplate(color: .gray)
        photoLibraryButton.setTemplate(color: .gray)
        tweetButton.layer.cornerRadius = 3
        tweetButton.addTarget(self, action: #selector(tweet), for: .touchUpInside)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        let height = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
        UIView.animate(withDuration: 0.25, animations: {
            self.keyboardConstraint.constant = -height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardHidden(notification: NSNotification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.keyboardConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func tweet(sender: AnyObject) {
        let swifter = Common.swifters[Common.currentAccount]
        swifter.postTweet(status: textView.text, success: { _ in
            self.dismiss(animated: true, completion: nil)
        }, failure: { _ in
            UIAlertController(title: "Error", message: "Failed to post your tweet.", preferredStyle: .alert)
                .addAction(title: "OK", style: .default)
                .show()
        })
    }
    
    @objc func close(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
