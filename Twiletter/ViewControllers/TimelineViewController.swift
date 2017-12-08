//
//  HomeViewController.swift
//  Twiletter
//
//  Created by subdiox on 2017/11/22.
//  Copyright © 2017年 Matt Donnelly. All rights reserved.
//

import UIKit
import SwifteriOS
import AlamofireImage

class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameLabelWidth: NSLayoutConstraint!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var createdAtLabelWidth: NSLayoutConstraint!
    @IBOutlet var tweetTextView: UITextView!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favoriteButton: HeartButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var replyCountButton: UIButton!
    @IBOutlet var retweetCountButton: UIButton!
    @IBOutlet var favoriteCountButton: UIButton!
    @IBOutlet var userRetweetedButton: UIButton!
    @IBOutlet var userRetweetedLabel: UILabel!
    @IBOutlet var userRetweetedStackView: UIStackView!
    @IBOutlet var userRetweetedHeight: NSLayoutConstraint!
    @IBOutlet var userRetweetedSpace: NSLayoutConstraint!
}

class TimelineViewController: UITableViewController, UITextViewDelegate {

    var swifter = Common.swifterList[Common.currentAccount]
    var tweets: [Tweet] = []
    var timer: Timer!
    var latestID: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "pull_to_refresh".localized)
        refreshControl?.addTarget(self, action: #selector(refreshTweets), for: .valueChanged)
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshTweets()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshTimestamp), userInfo: nil, repeats: true)
//        timer.fire()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        timer.invalidate()
//    }
    
    @objc func refreshTweets() {
        swifter.getHomeTimeline(count: 100, sinceID: latestID, success: { json in
            let tweetsJsonArray = json.array!
            if (self.tweets.count == 0) {
                for tweetsJson in tweetsJsonArray {
                    self.tweets.append(Tweet(json: tweetsJson))
                }
            } else {
                for tweetsJson in tweetsJsonArray.reversed() {
                    self.tweets.insert(Tweet(json: tweetsJson), at: 0)
                }
                self.latestID = self.tweets.first?.id
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.refreshControl?.endRefreshing()
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tweetViewController = segue.destination as! TweetViewController
        if let row = tableView.indexPathForSelectedRow?.row {
            tweetViewController.tweet = tweets[row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell", for: indexPath) as! TimelineTableViewCell
        let row = indexPath.row
        refresh(cell: &cell, row: row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func refresh(cell: inout TimelineTableViewCell, row: Int) {
        let retweetImage = UIImage(named: "retweet")?.withRenderingMode(.alwaysTemplate)
        let replyImage = UIImage(named: "reply")?.withRenderingMode(.alwaysTemplate)
        
        cell.nameLabel.text = tweets[row].name
        cell.nameLabelWidth.constant = cell.nameLabel.sizeThatFits(CGSize(width: cell.nameLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)).width
        
        cell.screenNameLabel.text = "@\(tweets[row].screenName)"
        
        cell.tweetTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.linkLightBlue]
        cell.tweetTextView.attributedText = tweets[row].text.unescaped.attributed(size: 15)
        cell.tweetTextView.textContainerInset = .zero
        cell.tweetTextView.textContainer.lineFragmentPadding = 0
        cell.tweetTextView.delegate = self
        
        cell.profileImageButton.layer.cornerRadius = cell.profileImageButton.frame.width / 2
        cell.profileImageButton.clipsToBounds = true
        cell.profileImageButton.af_setImage(for: .normal, url: tweets[row].profileImage)
        
        cell.createdAtLabel.text = Common.subtractDate(from: tweets[row].createdAt, to: Date())
        cell.createdAtLabelWidth.constant = cell.createdAtLabel.sizeThatFits(CGSize(width: cell.createdAtLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)).width
        
        cell.replyButton.setImage(replyImage, for: .normal)
        cell.replyButton.tintColor = UIColor.gray
        cell.replyButton.tag = row
        cell.replyButton.addTarget(self, action: #selector(reply), for: .touchUpInside)
        cell.replyCountButton.tag = row
        cell.replyCountButton.addTarget(self, action: #selector(replyCount), for: .touchUpInside)
        cell.replyCountButton.isEnabled = false
        if (tweets[row].replyCount == 0) {
            cell.replyCountButton.setTitle("", for: .normal)
        } else {
            cell.replyCountButton.setTitle("\(tweets[row].replyCount)", for: .normal)
        }
        cell.replyCountButton.isEnabled = true
        
        cell.retweetButton.setImage(retweetImage, for: .normal)
        cell.retweetButton.tag = row
        cell.retweetButton.addTarget(self, action: #selector(retweet), for: .touchUpInside)
        cell.retweetCountButton.tag = row
        cell.retweetCountButton.addTarget(self, action: #selector(retweetCount), for: .touchUpInside)
        if (tweets[row].retweeted) {
            cell.retweetButton.tintColor = UIColor.retweetGreen
            cell.retweetCountButton.titleLabel?.textColor = UIColor.retweetGreen
        } else {
            cell.retweetButton.tintColor = UIColor.gray
            cell.retweetCountButton.titleLabel?.textColor = UIColor.gray
        }
        cell.retweetCountButton.isEnabled = false
        if (tweets[row].retweetCount == 0) {
            cell.retweetCountButton.setTitle("", for: .normal)
        } else {
            cell.retweetCountButton.setTitle("\(tweets[row].retweetCount)", for: .normal)
        }
        cell.retweetCountButton.isEnabled = true
        
        cell.favoriteButton.tag = row
        cell.favoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        cell.favoriteCountButton.tag = row
        cell.favoriteCountButton.addTarget(self, action: #selector(favoriteCount), for: .touchUpInside)
        if (tweets[row].favorited) {
            cell.favoriteButton.setSelected(selected: true, animated: false)
            cell.favoriteCountButton.titleLabel?.textColor = UIColor.heartRed
        } else {
            cell.favoriteButton.setSelected(selected: false, animated: false)
            cell.favoriteCountButton.titleLabel?.textColor = UIColor.gray
        }
        cell.favoriteCountButton.isEnabled = false
        if (tweets[row].favoriteCount == 0) {
            cell.favoriteCountButton.setTitle("", for: .normal)
        } else {
            cell.favoriteCountButton.setTitle("\(tweets[row].favoriteCount)", for: .normal)
        }
        cell.favoriteCountButton.isEnabled = true
        
        cell.shareButton.tag = row
        cell.shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        
        if (tweets[row].isRetweet) {
            cell.userRetweetedLabel.text = "\(tweets[row].retweetedUserInfo!.name) Retweeted"
            cell.userRetweetedStackView.isHidden = false
            cell.userRetweetedButton.isHidden = false
            cell.userRetweetedHeight.constant = 12
            cell.userRetweetedSpace.constant = 4
        } else {
            cell.userRetweetedStackView.isHidden = true
            cell.userRetweetedButton.isHidden = true
            cell.userRetweetedHeight.constant = 0
            cell.userRetweetedSpace.constant = 0
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
    
    /* objc functions */
    @objc func reply(_ sender: AnyObject) {
        //let row = sender.tag
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
    }
    
    @objc func replyCount(_ sender: AnyObject) {
        let row = sender.tag!
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! TimelineTableViewCell
        cell.replyButton.sendActions(for: .touchUpInside)
    }
    
    @objc func retweet(_ sender: AnyObject) {
        let row = sender.tag!
        var cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! TimelineTableViewCell
        if (tweets[row].retweeted) {
            tweets[row].retweeted = false
            tweets[row].retweetCount -= 1
            refresh(cell: &cell, row: row)
            swifter.unretweetTweet(forID: "\(tweets[row].id)", success: { json in
                print("unretweeted: \(self.tweets[row].id)")
            })
        } else {
            tweets[row].retweeted = true
            tweets[row].retweetCount += 1
            refresh(cell: &cell, row: row)
            swifter.retweetTweet(forID: "\(tweets[row].id)", success: { json in
                print("retweeted: \(self.tweets[row].id)")
            })
        }
    }
    
    @objc func retweetCount(_ sender: AnyObject) {
        let row = sender.tag!
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! TimelineTableViewCell
        cell.retweetButton.sendActions(for: .touchUpInside)
    }
    
    @objc func favorite(_ sender: HeartButton) {
        sender.toggle()
        let row = sender.tag
        var cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! TimelineTableViewCell
        if (tweets[row].favorited) {
            tweets[row].favorited = false
            tweets[row].favoriteCount -= 1
            refresh(cell: &cell, row: row)
            swifter.unfavoriteTweet(forID: "\(tweets[row].id)", success: { json in
                print("unfavorited: \(self.tweets[row].id)")
            })
        } else {
            tweets[row].favorited = true
            tweets[row].favoriteCount += 1
            refresh(cell: &cell, row: row)
            swifter.favoriteTweet(forID: "\(tweets[row].id)", success: { json in
                print("favorited: \(self.tweets[row].id)")
            })
        }
    }
    
    @objc func favoriteCount(_ sender: AnyObject) {
        let row = sender.tag!
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! TimelineTableViewCell
        cell.favoriteButton.sendActions(for: .touchUpInside)
    }
    
    @objc func share(_ sender: AnyObject) {
        //let row = sender.tag
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
    }
}



