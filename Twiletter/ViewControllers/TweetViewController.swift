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
    @IBOutlet var favoriteButton: StarButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var viaButton: UIButton!
    @IBOutlet var replyCountButton: UIButton!
    @IBOutlet var retweetCountButton: UIButton!
    @IBOutlet var favoriteCountButton: UIButton!
    
    @IBOutlet var userRetweetedLabel: UILabel!
    @IBOutlet var userRetweetedButton: UIButton!
    @IBOutlet var userRetweetedStackView: UIStackView!
    @IBOutlet var userRetweetedHeight: NSLayoutConstraint!
    @IBOutlet var countStackViewHeight: NSLayoutConstraint!
    @IBOutlet var lineViewHeight: NSLayoutConstraint!
    @IBOutlet var mediaView: UIView!
    @IBOutlet var mediaViewAspectConstraint: NSLayoutConstraint!
    @IBOutlet var mediaViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var mediaViewSpaceConstraint: NSLayoutConstraint!
    
}

class TweetViewController: UITableViewController, UITextViewDelegate {
    
    var swifter = Common.swifters[Common.currentAccount]
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        let row = indexPath.row
        refresh(cell: &cell, row: row)
        return cell
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
    
    func refresh(cell: inout TweetTableViewCell, row: Int, update: Bool = false) {
        
        if (tweet.entities.media.count > 0) {
            cell.mediaViewHeightConstraint.isActive = false
            cell.mediaViewAspectConstraint.isActive = true
            cell.mediaViewSpaceConstraint.constant = 8
            cell.mediaView.removeAllSubviews()
            self.add(mediaTweet: tweet, to: cell.mediaView, index: Common.skphotoimages.count)
        } else {
            cell.mediaView.removeAllSubviews()
            cell.mediaViewAspectConstraint.isActive = false
            cell.mediaViewHeightConstraint.isActive = true
            cell.mediaViewSpaceConstraint.constant = 0
        }
        
        cell.nameLabel.text = tweet.name
        
        cell.screenNameLabel.text = "@\(tweet.screenName)"
        
        cell.tweetTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.linkLightBlue]
        cell.tweetTextView.attributedText = tweet.text.unescaped.attributed(size: 19, entities: tweet.entities, preview: true)
        cell.tweetTextView.textContainerInset = .zero
        cell.tweetTextView.textContainer.lineFragmentPadding = 0
        cell.tweetTextView.delegate = self
        
        cell.profileImageButton.layer.cornerRadius = cell.profileImageButton.frame.width / 2
        cell.profileImageButton.clipsToBounds = true
        cell.profileImageButton.af_setImage(for: .normal, url: tweet.profileImage)
        
        cell.createdAtLabel.text = tweet.createdAt.toString
        
        cell.viaButton.setTitle(tweet.viaName, for: .normal)
        cell.viaButton.addTarget(self, action: #selector(showVia), for: .touchUpInside)
        
        cell.replyButton.setTemplate(color: .gray)
        cell.replyButton.tag = row
        cell.replyButton.addTarget(self, action: #selector(reply), for: .touchUpInside)
        cell.replyCountButton.tag = row
        cell.replyCountButton.addTarget(self, action: #selector(replyCount), for: .touchUpInside)
        if (tweet.replyCount == 0) {
            cell.replyCountButton.isHidden = true
        } else {
            cell.replyCountButton.isHidden = false
            cell.replyCountButton.isEnabled = false
            cell.replyCountButton.setAttributedTitle("\(tweet.replyCount) Replies".countAttributed, for: .normal)
            cell.replyCountButton.isEnabled = true
        }
        
        cell.retweetButton.tag = row
        cell.retweetButton.addTarget(self, action: #selector(retweet), for: .touchUpInside)
        cell.retweetCountButton.tag = row
        cell.retweetCountButton.addTarget(self, action: #selector(retweetCount), for: .touchUpInside)
        if (tweet.retweeted) {
            cell.retweetButton.setTemplate(color: .retweetGreen)
        } else {
            cell.retweetButton.setTemplate(color: .gray)
        }
        if (tweet.retweetCount == 0) {
            cell.retweetCountButton.isHidden = true
        } else {
            cell.retweetCountButton.isHidden = false
            cell.retweetCountButton.isEnabled = false
            cell.retweetCountButton.setAttributedTitle("\(tweet.retweetCount) Retweets".countAttributed, for: .normal)
            cell.retweetCountButton.isEnabled = true
        }
        
        cell.favoriteButton.tag = row
        cell.favoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        cell.favoriteCountButton.tag = row
        cell.favoriteCountButton.addTarget(self, action: #selector(favoriteCount), for: .touchUpInside)
        if (tweet.favorited) {
            cell.favoriteButton.isSelected = true
            //cell.favoriteButton.setSelected(selected: true, animated: false)
            cell.favoriteCountButton.titleLabel?.textColor = UIColor.heartRed
        } else {
            cell.favoriteButton.isSelected = false
            //cell.favoriteButton.setSelected(selected: false, animated: false)
            cell.favoriteCountButton.titleLabel?.textColor = UIColor.gray
        }
        if (tweet.favoriteCount == 0) {
            cell.favoriteCountButton.isHidden = true
        } else {
            cell.favoriteCountButton.isHidden = false
            cell.favoriteCountButton.isEnabled = false
            cell.favoriteCountButton.setAttributedTitle("\(tweet.favoriteCount) Favorites".countAttributed, for: .normal)
            cell.favoriteCountButton.isEnabled = true
        }
        
        if (tweet.replyCount == 0 && tweet.retweetCount == 0 && tweet.favoriteCount == 0) {
            cell.countStackViewHeight.constant = 0
            cell.lineViewHeight.constant = 0
        } else {
            cell.countStackViewHeight.constant = 32
            cell.lineViewHeight.constant = 1
        }
        
        cell.shareButton.tag = row
        cell.shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        
        if (tweet.isRetweet) {
            cell.userRetweetedLabel.text = "\(tweet.retweeterInfo!.name) Retweeted"
            cell.userRetweetedStackView.isHidden = false
            cell.userRetweetedButton.isHidden = false
            cell.userRetweetedHeight.constant = 18
        } else {
            cell.userRetweetedStackView.isHidden = true
            cell.userRetweetedButton.isHidden = true
            cell.userRetweetedHeight.constant = 0
        }
        if (update) {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    /* UITextViewDelegate */
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let string = URL.absoluteString.decoded
        if string.starts(with: "http://") || string.starts(with: "https://") {
            
        } else if string.starts(with: "#") {
            
        } else if string.starts(with: "@") {
            
        }
        print(string)
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
        return false
    }
    
    @objc func reply(_ sender: AnyObject) {
        //let row = sender.tag
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
    }
    
    @objc func replyCount(_ sender: AnyObject) {
        //let row = sender.tag
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
    }
    
    @objc func retweet(_ sender: AnyObject) {
        let row = sender.tag!
        var cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! TweetTableViewCell
        if tweet.retweeted {
            tweet.retweeted = false
            tweet.retweetCount -= 1
            refresh(cell: &cell, row: row, update: true)
            swifter.unretweetTweet(forID: "\(tweet.id)", success: { json in
                print("unretweeted: \(self.tweet.id)")
            })
        } else {
            tweet.retweeted = true
            tweet.retweetCount += 1
            refresh(cell: &cell, row: row, update: true)
            swifter.retweetTweet(forID: "\(tweet.id)", success: { json in
                print("retweeted: \(self.tweet.id)")
            })
        }
    }
    
    @objc func retweetCount(_ sender: AnyObject) {
        //let row = sender.tag
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
    }
    
    @objc func favorite(_ sender: StarButton) {
        sender.toggle()
        let row = sender.tag
        var cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! TweetTableViewCell
        if tweet.favorited {
            tweet.favorited = false
            tweet.favoriteCount -= 1
            refresh(cell: &cell, row: row, update: true)
            swifter.unfavoriteTweet(forID: "\(tweet.id)", success: { json in
                print("unfavorited: \(self.tweet.id)")
            })
        } else {
            tweet.favorited = true
            tweet.favoriteCount += 1
            refresh(cell: &cell, row: row, update: true)
            swifter.favoriteTweet(forID: "\(tweet.id)", success: { json in
                print("favorited: \(self.tweet.id)")
            })
        }
    }
    
    @objc func favoriteCount(_ sender: AnyObject) {
        //let row = sender.tag
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
    }
    
    @objc func showVia(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(tweet.viaURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(tweet.viaURL)
        }
    }
}
