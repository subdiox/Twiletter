//
//  AuthViewController.swift
//  SwifterDemoiOS
//
//  Copyright (c) 2014 Matt Donnelly.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import Accounts
import Social
import SwifteriOS
import SafariServices

class AuthViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var swifter: Swifter

    required init?(coder aDecoder: NSCoder) {
        // consumer key/secret of "Twitter for iPhone"
        self.swifter = Swifter(consumerKey: "IQKbtAYlXLripLGPWd0HUA", consumerSecret: "GgDYlkSvaPxGxC4X8liwpUoqKwwr3lCADbz8A7ADU")
        super.init(coder: aDecoder)
    }

    @IBAction func didTouchUpInsideLoginButton(_ sender: AnyObject) {
        swifter.authorizePIN(username: "yukitansuko", password: "exiv8888", success: { _, _ in
            self.fetchTwitterHomeStream()
        })
    }

    func fetchTwitterHomeStream() {
        /*self.swifter.getHomeTimeline(count: 20, success: { json in
            let tweets = json.array!
            let id = tweets[10]["id_str"].string!
            print(tweets[10]["text"].string!)
            self.swifter.getTweetFavoritedBy(forID: id, cursor: "-1", success: { json2, _, _ in
                print(json2)
            })
        })*/
        
        
        /*let status = "Twitter for iPhoneになったかな？2"
        self.swifter.postTweet(status: status, success: { status in
            print(status)
        })*/
        self.swifter.createAndPostCards(status: "API Test", cards: ["1", "2", "3", "4"], durationMinutes: 10080, success: { json in
            print(json)
        })
        /*
        self.swifter.getHomeTimeline(count: 20, success: { json in
            // Successfully fetched timeline, so lets create and push the table view
            
            let tweetsViewController = self.storyboard!.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
            guard let tweets = json.array else { return }
            tweetsViewController.tweets = tweets
            self.navigationController?.pushViewController(tweetsViewController, animated: true)
            
            }, failure: failureHandler)*/
    }

    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
