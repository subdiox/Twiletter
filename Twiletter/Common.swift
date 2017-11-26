//
//  Common.swift
//  Twiletter
//
//  Created by subdiox on 2017/11/23.
//  Copyright © 2017年 Matt Donnelly. All rights reserved.
//

import UIKit
import SwifteriOS

class Common {
    static var swifterList: [Swifter] = []
    static var tokenList: [AccessToken] = []
    static var currentAccount: Int = 0
    
    class func subtractDate(from: Date, to: Date) -> String {
        let comp1 = Calendar.current.dateComponents([.second], from: from, to: to)
        if (comp1.second! < 60) {
            return "\(comp1.second!)s"
        } else {
            let comp2 = Calendar.current.dateComponents([.minute], from: from, to: to)
            if (comp2.minute! < 60) {
                return "\(comp2.minute!)m"
            } else {
                let comp3 = Calendar.current.dateComponents([.hour], from: from, to: to)
                if (comp3.hour! < 24) {
                    return "\(comp3.hour!)h"
                } else {
                    let comp4 = Calendar.current.dateComponents([.day], from: from, to: to)
                    if (comp4.day! < 7) {
                        return "\(comp4.day!)d"
                    } else {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy/MM/dd"
                        return dateFormatter.string(from: to)
                    }
                }
            }
        }
    }
}

public class AccessToken: NSObject, NSCoding {
    
    public internal(set) var key: String
    public internal(set) var secret: String
    public internal(set) var screenName: String
    public internal(set) var userID: String
    
    public init(key: String, secret: String, screenName: String, userID: String) {
        self.key = key
        self.secret = secret
        self.screenName = screenName
        self.userID = userID
    }
    
    required convenience public init?(coder decoder: NSCoder) {
        let key = decoder.decodeObject(forKey: "key") as! String
        let secret = decoder.decodeObject(forKey: "secret") as! String
        let screenName = decoder.decodeObject(forKey: "screenName") as! String
        let userID = decoder.decodeObject(forKey: "userID") as! String
        
        self.init(key: key, secret: secret, screenName: screenName, userID: userID)
    }
    
    // Here you need to set properties to specific keys in archive
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.key, forKey: "key")
        aCoder.encode(self.secret, forKey: "secret")
        aCoder.encode(self.screenName, forKey: "screenName")
        aCoder.encode(self.userID, forKey: "userID")
    }
}

public class Tweet: NSObject {
    
    public internal(set) var id: String
    public internal(set) var isRetweet: Bool
    public internal(set) var text: String
    public internal(set) var name: String
    public internal(set) var screenName: String
    public internal(set) var profileImage: URL
    public internal(set) var createdAt: Date
    public internal(set) var viaName: String
    public internal(set) var viaURL: URL
    public internal(set) var replyCount: Int
    public internal(set) var retweetCount: Int
    public internal(set) var favoriteCount: Int
    public internal(set) var retweeted: Bool
    public internal(set) var favorited: Bool
    public internal(set) var retweetedUserInfo: Tweet?
    
    public init(json: JSON) {
        self.isRetweet = (json["retweeted_status"].object != nil)
        if (self.isRetweet) {
            self.id = json["retweeted_status"]["id_str"].string!
            self.text = json["retweeted_status"]["text"].string!.decoded
            self.name = json["retweeted_status"]["user"]["name"].string!.decoded
            self.screenName = json["retweeted_status"]["user"]["screen_name"].string!
            self.profileImage = URL(string: json["retweeted_status"]["user"]["profile_image_url_https"].string!.replacingOccurrences(of: "_normal", with: ""))!
            self.createdAt = json["retweeted_status"]["created_at"].string!.toDate
            self.viaName = json["retweeted_status"]["source"].string!.aName
            self.viaURL = json["retweeted_status"]["source"].string!.aURL
            self.replyCount = json["retweeted_status"]["reply_count"].integer!
            self.retweetCount = json["retweeted_status"]["retweet_count"].integer!
            self.favoriteCount = json["retweeted_status"]["favorite_count"].integer!
            self.retweeted = json["retweeted_status"]["retweeted"].bool!
            self.favorited = json["retweeted_status"]["favorited"].bool!
            self.retweetedUserInfo = Tweet(retweetedJson: json)
        } else {
            self.id = json["id_str"].string!
            self.text = json["text"].string!.decoded
            self.name = json["user"]["name"].string!.decoded
            self.screenName = json["user"]["screen_name"].string!
            self.profileImage = URL(string: json["user"]["profile_image_url_https"].string!.replacingOccurrences(of: "_normal", with: ""))!
            self.createdAt = json["created_at"].string!.toDate
            self.viaName = json["source"].string!.aName
            self.viaURL = json["source"].string!.aURL
            self.replyCount = json["reply_count"].integer!
            self.retweetCount = json["retweet_count"].integer!
            self.favoriteCount = json["favorite_count"].integer!
            self.retweeted = json["retweeted"].bool!
            self.favorited = json["favorited"].bool!
            self.retweetedUserInfo = nil
        }
    }
    
    public init(retweetedJson json: JSON) {
        self.id = json["id_str"].string!
        self.isRetweet = false
        self.text = json["text"].string!.decoded
        self.name = json["user"]["name"].string!.decoded
        self.screenName = json["user"]["screen_name"].string!
        self.profileImage = URL(string: json["user"]["profile_image_url_https"].string!.replacingOccurrences(of: "_normal", with: ""))!
        self.createdAt = json["created_at"].string!.toDate
        self.viaName = json["source"].string!.aName
        self.viaURL = json["source"].string!.aURL
        self.replyCount = json["reply_count"].integer!
        self.retweetCount = json["retweet_count"].integer!
        self.favoriteCount = json["favorite_count"].integer!
        self.retweeted = json["retweeted"].bool!
        self.favorited = json["favorited"].bool!
        
        self.retweetedUserInfo = nil
    }
}

// Official Consumer Key / Secret (with full access of API)
enum Consumer {
    enum iPhone: String {
        case key = "IQKbtAYlXLripLGPWd0HUA"
        case secret = "GgDYlkSvaPxGxC4X8liwpUoqKwwr3lCADbz8A7ADU"
    }
    
    enum iPad: String {
        case key = "CjulERsDeqhhjSme66ECg"
        case secret = "IQWdVyqFxghAtURHGeGiWAsmCAGmdW3WmbEx6Hck"
    }
    
    enum Android: String {
        case key = "3nVuSoBZnx6U4vzUxf5w"
        case secret = "Bcs59EFbbsdF6Sl9Ng71smgStWEGwXXKSjYvPVt7qys"
    }
    
    enum Mac: String {
        case key = "3rJOl1ODzm9yZy63FACdg"
        case secret = "5jPoQ5kQvMJFDYRNE8bQ4rHuds4xJqhvgNJM4awaE8"
    }
    
    enum WindowsPhone: String {
        case key = "yN3DUNVO0Me63IAQdhTfCA"
        case secret = "c768oTKdzAjIYCmpSNIdZbGaG0t6rOhSFQP0S5uC79g"
    }
    
    enum GoogleTV: String {
        case key = "iAtYJ4HpUVfIUoNnif1DA"
        case secret = "172fOpzuZoYzNYaU3mMYvE8m8MEyLbztOdbrUolU"
    }
}

extension UIColor {
    class var systemBlue: UIColor {
        return UIColor.rgbColor(rgbValue: 0x007aff)
    }
    
    class var systemGreen: UIColor {
        return UIColor.rgbColor(rgbValue: 0x4cd964)
    }
    
    class var systemRed: UIColor {
        return UIColor.rgbColor(rgbValue: 0xff3b30)
    }
    
    class var systemLightGray: UIColor {
        return UIColor.rgbColor(rgbValue: 0xf5f5f7)
    }
    
    class var systemGray: UIColor {
        return UIColor.rgbColor(rgbValue: 0xefeff4)
    }
    
    class var retweetGreen: UIColor {
        return UIColor.rgbColor(rgbValue: 0x2ecc71)
    }
    
    class var heartRed: UIColor {
        return UIColor.rgbColor(rgbValue: 0xe74c3c)
    }
    
    class var starYellow: UIColor {
        return UIColor.rgbColor(rgbValue: 0xFFFF00)
    }
    
    class var linkLightBlue: UIColor {
        return UIColor.rgbColor(rgbValue: 0x1b95e0)
    }
    
    class var linkBlue: UIColor {
        return UIColor.rgbColor(rgbValue: 0x1da1f2)
    }
    
    class func rgbColor(rgbValue: UInt) -> UIColor{
        return UIColor(
            red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >>  8) / 255.0,
            blue:  CGFloat( rgbValue & 0x0000FF)        / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var encoded: String {
        if let encodedString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return encodedString
        } else {
            return self
        }
    }
    
    var decoded: String {
        if let decodedString = self.removingPercentEncoding {
            return decodedString
        } else {
            return self
        }
    }
    
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM dd HH:mm:ss xx yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.date(from: self)!
    }
    
    var aName: String {
        return self.components(separatedBy: ">")[1].components(separatedBy: "<")[0]
    }
    
    var aURL: URL {
        return URL(string: self.components(separatedBy: "\"")[1])!
    }
    
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
    
    func attributed(size: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        var index = self.unicodeScalars.startIndex
        for wordWithBigSpace in self.components(separatedBy: .whitespacesAndNewlines) {
            for word in wordWithBigSpace.components(separatedBy: "　") {
                for keyword in ["http://", "https://", "@", "#"] {
                    if word.contains(keyword) {
                        let custom = word.unicodeScalars.distance(from: word.unicodeScalars.startIndex, to: word.range(of: keyword, options: .backwards)!.lowerBound)
                        let from = self.unicodeScalars.index(index, offsetBy: custom)
                        let to = self.unicodeScalars.index(index, offsetBy: word.unicodeScalars.count)
                        let range = NSRange(from ..< to, in: self)
                        attributedString.addAttribute(.link, value: "twiletter://?type=\(keyword)&link=\(self.substring(with: range)!)".encoded, range: range)
                    }
                }
                index = self.unicodeScalars.index(index, offsetBy: word.unicodeScalars.count + 1)
            }
        }
        attributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)], range: NSRange(self.startIndex ..< self.endIndex, in: self))
        return attributedString
    }
}

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
}

extension UIApplication {
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    var topNavigationController: UINavigationController? {
        return topViewController as? UINavigationController
    }
}

extension UIAlertController {
    
    func addAction(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        let okAction = UIAlertAction(title: title, style: style, handler: handler)
        addAction(okAction)
        return self
    }
    
    func addActionWithTextFields(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction, [UITextField]) -> Void)? = nil) -> Self {
        let okAction = UIAlertAction(title: title, style: style) { [weak self] action in
            handler?(action, self?.textFields ?? [])
        }
        addAction(okAction)
        return self
    }
    
    func configureForIPad(sourceRect: CGRect, sourceView: UIView? = nil) -> Self {
        popoverPresentationController?.sourceRect = sourceRect
        if let sourceView = UIApplication.shared.topViewController?.view {
            popoverPresentationController?.sourceView = sourceView
        }
        return self
    }
    
    func configureForIPad(barButtonItem: UIBarButtonItem) -> Self {
        popoverPresentationController?.barButtonItem = barButtonItem
        return self
    }
    
    func addTextField(handler: @escaping (UITextField) -> Void) -> Self {
        addTextField(configurationHandler: handler)
        return self
    }
    
    func show(on: UIViewController = UIApplication.shared.topViewController!) {
        on.present(self, animated: true, completion: nil)
    }
}

extension URL {
    func valueOf(key: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == key })?.value?.decoded
    }
}
