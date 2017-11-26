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
    @IBOutlet var retweetImageView: UIImageView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var replyCountLabel: UILabel!
    @IBOutlet var retweetCountLabel: UILabel!
    @IBOutlet var favoriteCountLabel: UILabel!
    @IBOutlet var userRetweetedButton: UIButton!
    @IBOutlet var userRetweetedLabel: UILabel!
    @IBOutlet var userRetweetedStackView: UIStackView!
    @IBOutlet var userRetweetedHeight: NSLayoutConstraint!
    @IBOutlet var userRetweetedSpace: NSLayoutConstraint!
}

class TimelineViewController: UITableViewController {

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshTimestamp), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
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
    
    @objc func refreshTimestamp() {
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tweetViewController = segue.destination as! TweetViewController
        if let row = tableView.indexPathForSelectedRow?.row {
            tweetViewController.selectedTweet = tweets[row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell", for: indexPath) as! TimelineTableViewCell
        
        let row = indexPath.row
        cell.nameLabel.text = tweets[row].name
        cell.screenNameLabel.text = "@\(tweets[row].screenName)"
        cell.tweetTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.linkLightBlue]
        cell.tweetTextView.attributedText = tweets[row].text.attributed(size: 15)
                cell.tweetTextView.textContainerInset = .zero
        cell.tweetTextView.textContainer.lineFragmentPadding = 0
        cell.profileImageButton.layer.cornerRadius = cell.profileImageButton.frame.width / 2
        cell.profileImageButton.clipsToBounds = true
        cell.profileImageButton.af_setImage(for: .normal, url: tweets[row].profileImage)
        cell.createdAtLabel.text = Common.subtractDate(from: tweets[row].createdAt, to: Date())
        cell.replyButton.tag = row
        cell.replyButton.addTarget(self, action: #selector(reply), for: .touchUpInside)
        cell.retweetButton.tag = row
        cell.retweetButton.addTarget(self, action: #selector(retweet), for: .touchUpInside)
        cell.favoriteButton.tag = row
        cell.favoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        if (tweets[row].retweeted) {
            cell.retweetImageView.image = UIImage(named: "retweet_filled_green")
            cell.retweetCountLabel.textColor = UIColor.retweetGreen
        } else {
            cell.retweetImageView.image = UIImage(named: "retweet_gray")
            cell.retweetCountLabel.textColor = UIColor.gray
        }
        if (tweets[row].favorited) {
            cell.favoriteImageView.image = UIImage(named: "heart_filled_red")
            cell.favoriteCountLabel.textColor = UIColor.heartRed
        } else {
            cell.favoriteImageView.image = UIImage(named: "heart_gray")
            cell.favoriteCountLabel.textColor = UIColor.gray
        }
        cell.shareButton.tag = row
        cell.shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        
        if (tweets[row].replyCount == 0) {
            cell.replyCountLabel.text = ""
        } else {
            cell.replyCountLabel.text = "\(tweets[row].replyCount)"
        }
        if (tweets[row].retweetCount == 0) {
            cell.retweetCountLabel.text = ""
        } else {
            cell.retweetCountLabel.text = "\(tweets[row].retweetCount)"
        }
        if (tweets[row].favoriteCount == 0) {
            cell.favoriteCountLabel.text = ""
        } else {
            cell.favoriteCountLabel.text = "\(tweets[row].favoriteCount)"
        }
        
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
        
        let nameRect: CGSize = cell.nameLabel.sizeThatFits(CGSize(width: cell.nameLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let createdAtRect: CGSize = cell.createdAtLabel.sizeThatFits(CGSize(width: cell.createdAtLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        cell.nameLabelWidth.constant = nameRect.width
        cell.createdAtLabelWidth.constant = createdAtRect.width
        
        return cell
    }
    
    @objc func reply(_ sender: AnyObject) {
        //let row = sender.tag
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
    }
    
    @objc func retweet(_ sender: AnyObject) {
        let row = sender.tag!
        if (tweets[row].retweeted) {
            tweets[row].retweeted = false
            tweets[row].retweetCount -= 1
            refreshTimestamp()
            swifter.unretweetTweet(forID: "\(tweets[row].id)", success: { json in
                print("unretweeted: \(self.tweets[row].id)")
            })
        } else {
            tweets[row].retweeted = true
            tweets[row].retweetCount += 1
            refreshTimestamp()
            swifter.retweetTweet(forID: "\(tweets[row].id)", success: { json in
                print("retweeted: \(self.tweets[row].id)")
            })
        }
    }
    
    @objc func favorite(_ sender: AnyObject) {
        let row = sender.tag!
        if (tweets[row].favorited) {
            tweets[row].favorited = false
            tweets[row].favoriteCount -= 1
            refreshTimestamp()
            swifter.unfavoriteTweet(forID: "\(tweets[row].id)", success: { json in
                print("unfavorited: \(self.tweets[row].id)")
            })
        } else {
            tweets[row].favorited = true
            tweets[row].favoriteCount += 1
            refreshTimestamp()
            swifter.favoriteTweet(forID: "\(tweets[row].id)", success: { json in
                print("favorited: \(self.tweets[row].id)")
            })
        }
    }
    
    @objc func share(_ sender: AnyObject) {
        //let row = sender.tag
        UIAlertController(title: "Error", message: "This function isn't implemented.", preferredStyle: .alert)
            .addAction(title: "OK", style: .default)
            .show()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

