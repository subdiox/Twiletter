//
//  TweetViewController.swift
//  Twiletter
//
//  Created by subdiox on 2017/11/25.
//  Copyright © 2017年 subdiox. All rights reserved.
//

import UIKit
import SwifteriOS

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var tweetTextView: UITextView!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var retweetImageView: UIImageView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var viaButton: UIButton!
    @IBOutlet var replyCountLabel: UILabel!
    @IBOutlet var retweetCountLabel: UILabel!
    @IBOutlet var favoriteCountLabel: UILabel!
    
    @IBOutlet var userRetweetedLabel: UILabel!
    @IBOutlet var userRetweetedButton: UIButton!
    @IBOutlet var userRetweetedStackView: UIStackView!
    @IBOutlet var userRetweetedHeight: NSLayoutConstraint!
}

class TweetViewController: UITableViewController {
    
    var swifter = Common.swifterList[Common.currentAccount]
    var selectedTweet: Tweet? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        
        if let tweet = selectedTweet {
            cell.profileImageButton.layer.cornerRadius = cell.profileImageButton.frame.width / 2
            cell.profileImageButton.clipsToBounds = true
            cell.profileImageButton.af_setImage(for: .normal, url: tweet.profileImage)
            cell.nameLabel.text = tweet.name
            cell.screenNameLabel.text = "@\(tweet.screenName)"
            cell.createdAtLabel.text = tweet.createdAt.toString
            cell.tweetTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.linkLightBlue]
            cell.tweetTextView.attributedText = tweet.text.attributed(size: 19)
            cell.tweetTextView.textContainerInset = .zero
            cell.tweetTextView.textContainer.lineFragmentPadding = 0
            cell.replyButton.addTarget(self, action: #selector(reply), for: .touchUpInside)
            cell.retweetButton.addTarget(self, action: #selector(retweet), for: .touchUpInside)
            cell.favoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
            cell.shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
            if (tweet.retweeted) {
                cell.retweetImageView.image = UIImage(named: "retweet_filled_green")
                cell.retweetCountLabel.textColor = UIColor.retweetGreen
            } else {
                cell.retweetImageView.image = UIImage(named: "retweet_gray")
                cell.retweetCountLabel.textColor = UIColor.gray
            }
            if (tweet.favorited) {
                cell.favoriteImageView.image = UIImage(named: "heart_filled_red")
                cell.favoriteCountLabel.textColor = UIColor.heartRed
            } else {
                cell.favoriteImageView.image = UIImage(named: "heart_gray")
                cell.favoriteCountLabel.textColor = UIColor.gray
            }
            cell.viaButton.setTitle("via \(tweet.viaName)", for: .normal)
            
            if (tweet.replyCount == 0) {
                cell.replyCountLabel.text = ""
            } else {
                cell.replyCountLabel.text = "\(tweet.replyCount)"
            }
            if (tweet.retweetCount == 0) {
                cell.retweetCountLabel.text = ""
            } else {
                cell.retweetCountLabel.text = "\(tweet.retweetCount)"
            }
            if (tweet.favoriteCount == 0) {
                cell.favoriteCountLabel.text = ""
            } else {
                cell.favoriteCountLabel.text = "\(tweet.favoriteCount)"
            }
            
            if (tweet.isRetweet) {
                cell.userRetweetedLabel.text = "\(tweet.retweetedUserInfo!.name) Retweeted"
                cell.userRetweetedStackView.isHidden = false
                cell.userRetweetedButton.isHidden = false
                cell.userRetweetedHeight.constant = 18
            } else {
                cell.userRetweetedStackView.isHidden = true
                cell.userRetweetedButton.isHidden = true
                cell.userRetweetedHeight.constant = 0
            }
        }
        
        return cell
    }
    
    @objc func refreshState() {
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    
    @objc func reply(_ sender: AnyObject) {
        //let row = sender.tag
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
    }
    
    @objc func retweet(_ sender: AnyObject) {
        if let tweet = selectedTweet {
            if tweet.retweeted {
                tweet.retweeted = false
                tweet.retweetCount -= 1
                refreshState()
                swifter.unretweetTweet(forID: "\(tweet.id)", success: { json in
                    print("unretweeted: \(tweet.id)")
                })
            } else {
                tweet.retweeted = true
                tweet.retweetCount += 1
                refreshState()
                swifter.retweetTweet(forID: "\(tweet.id)", success: { json in
                    print("retweeted: \(tweet.id)")
                })
            }
        }
    }
    
    @objc func favorite(_ sender: AnyObject) {
        if let tweet = selectedTweet {
            if tweet.favorited {
                tweet.favorited = false
                tweet.favoriteCount -= 1
                refreshState()
                swifter.unfavoriteTweet(forID: "\(tweet.id)", success: { json in
                    print("unfavorited: \(tweet.id)")
                })
            } else {
                tweet.favorited = true
                tweet.favoriteCount += 1
                refreshState()
                swifter.favoriteTweet(forID: "\(tweet.id)", success: { json in
                    print("favorited: \(tweet.id)")
                })
            }
        }
    }
    
    @objc func share(_ sender: AnyObject) {
        //let row = sender.tag
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
}
