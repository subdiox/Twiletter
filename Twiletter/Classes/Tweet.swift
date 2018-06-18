//
//  Tweet.swift
//  Twiletter
//
//  Created by subdiox on 2017/12/08.
//  Copyright © 2017年 subdiox. All rights reserved.
//

import Foundation
import SwifteriOS

public class Tweet {
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
    public internal(set) var retweeterInfo: RetweeterInfo?
    public internal(set) var entities: Entities
    
    public init(json: JSON) {
        self.isRetweet = (json["retweeted_status"].object != nil)
        if (self.isRetweet) {
            self.id = json["retweeted_status"]["id_str"].string!
            self.text = json["retweeted_status"]["full_text"].string!.escaped
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
            self.retweeterInfo = RetweeterInfo(json: json)
            self.entities = Entities(json: json["retweeted_status"])
        } else {
            self.id = json["id_str"].string!
            self.text = json["full_text"].string!.escaped
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
            self.retweeterInfo = nil
            self.entities = Entities(json: json)
        }
    }
}

public class RetweeterInfo {
    public internal(set) var id: String
    public internal(set) var name: String
    public internal(set) var screenName: String
    public internal(set) var profileImage: URL
    public internal(set) var createdAt: Date
    public internal(set) var viaName: String
    public internal(set) var viaURL: URL
    
    public init(json: JSON) {
        self.id = json["id_str"].string!
        self.name = json["user"]["name"].string!.decoded
        self.screenName = json["user"]["screen_name"].string!
        self.profileImage = URL(string: json["user"]["profile_image_url_https"].string!.replacingOccurrences(of: "_normal", with: ""))!
        self.createdAt = json["created_at"].string!.toDate
        self.viaName = json["source"].string!.aName
        self.viaURL = json["source"].string!.aURL
    }
}

public class Indices {
    public internal(set) var from: Int
    public internal(set) var to: Int
    
    public init(json: JSON) {
        self.from = json[0].integer!
        self.to = json[1].integer!
    }
}

public class Entities {
    public internal(set) var media: [Media] = []
    public internal(set) var urls: [Url] = []
    public internal(set) var userMentions: [UserMention] = []
    public internal(set) var hashtags: [Hashtag] = []
    public internal(set) var symbols: [Symbol] = []
    
    public init(json: JSON) {
        if let array = json["extended_entities"]["media"].array {
            for mediaJson in array {
                self.media.append(Media(json: mediaJson))
            }
        }/* else if let array = json["entities"]["media"].array {
            for mediaJson in array {
                self.media.append(Media(json: mediaJson))
            }
        }*/
        if let array = json["entities"]["urls"].array {
            for urlJson in array {
                self.urls.append(Url(json: urlJson))
            }
        }
        if let array = json["entities"]["user_mentions"].array {
            for userMentionJson in array {
                self.userMentions.append(UserMention(json: userMentionJson))
            }
        }
        if let array = json["entities"]["hashtags"].array {
            for hashtagJson in array {
                self.hashtags.append(Hashtag(json: hashtagJson))
            }
        }
        if let array = json["entities"]["symbols"].array {
            for symbolJson in array {
                self.symbols.append(Symbol(json: symbolJson))
            }
        }
    }
}

public class Media {
    public internal(set) var id: String
    public internal(set) var mediaUrl: URL
    public internal(set) var url: String
    public internal(set) var displayUrl: String
    public internal(set) var expandedUrl: String
    public internal(set) var indices: Indices
    public internal(set) var sizes: Sizes
    
    public init(json: JSON) {
        self.id = json["id_str"].string!
        self.mediaUrl = URL(string: json["media_url_https"].string!)!
        self.url = json["url"].string!
        self.expandedUrl = json["expanded_url"].string!
        self.displayUrl = json["display_url"].string!
        self.indices = Indices(json: json["indices"])
        self.sizes = Sizes(json: json["sizes"])
    }
}

public class Sizes {
    public internal(set) var medium: Size
    public internal(set) var thumb: Size
    public internal(set) var small: Size
    public internal(set) var large: Size
    
    public init(json: JSON) {
        self.medium = Size(json: json["medium"])
        self.thumb = Size(json: json["thumb"])
        self.small = Size(json: json["small"])
        self.large = Size(json: json["large"])
    }
}

public class Size {
    public internal(set) var w: Int
    public internal(set) var h: Int
    public internal(set) var fit: Bool // otherwise crop
    
    public init(json: JSON) {
        self.w = json["w"].integer!
        self.h = json["h"].integer!
        self.fit = json["resize"].string! == "fit"
    }
}

public class Url {
    public internal(set) var url: String
    public internal(set) var expandedUrl: String
    public internal(set) var displayUrl: String
    public internal(set) var indices: Indices
    
    public init(json: JSON) {
        self.url = json["url"].string!
        self.expandedUrl = json["expanded_url"].string!
        self.displayUrl = json["display_url"].string!
        self.indices = Indices(json: json["indices"])
    }
}

public class UserMention {
    public internal(set) var screenName: String
    public internal(set) var name: String
    public internal(set) var id: String
    public internal(set) var indices: Indices
    
    public init(json: JSON) {
        self.screenName = json["screen_name"].string!
        self.name = json["name"].string!
        self.id = json["id_str"].string!
        self.indices = Indices(json: json["indices"])
    }
}

public class Hashtag {
    public internal(set) var text: String
    public internal(set) var indices: Indices
    
    public init(json: JSON) {
        self.text = json["text"].string!
        self.indices = Indices(json: json["indices"])
    }
}

public class Symbol {
    public internal(set) var text: String
    public internal(set) var indices: Indices
    
    public init(json: JSON) {
        self.text = json["text"].string!
        self.indices = Indices(json: json["indices"])
    }
}
