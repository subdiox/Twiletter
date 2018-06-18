//
//  Common.swift
//  Twiletter
//
//  Created by subdiox on 2017/11/23.
//  Copyright © 2017年 Matt Donnelly. All rights reserved.
//

import UIKit
import SwifteriOS
import SKPhotoBrowser

class Common {
    static var swifters: [Swifter] = []
    static var tokens: [AccessToken] = []
    static var currentAccount: Int = 0
    static var skphotoimages: [[SKPhoto]] = []
}

class Replace: Comparable {
    public internal(set) var indices: Indices
    public internal(set) var to: String
    
    public init(indices: Indices, to: String) {
        self.indices = indices
        self.to = to
    }
}

extension Replace {
    static func ==(x: Replace, y: Replace) -> Bool {
        if x.indices.from == y.indices.from && x.indices.to == y.indices.to && x.to == y.to {
            return true
        }
        return false
    }
    
    static func <(x: Replace, y: Replace) -> Bool {
        if x.indices.from < y.indices.from {
            return true
        } else if x.indices.from > y.indices.from {
            return false
        }
        
        if x.indices.to < y.indices.to {
            return true
        } else if x.indices.to > y.indices.to {
            return false
        }
        return false
    }
}
