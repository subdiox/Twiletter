//
//  AccessToken.swift
//  Twiletter
//
//  Created by subdiox on 2017/12/08.
//  Copyright © 2017年 subdiox. All rights reserved.
//

import Foundation

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
