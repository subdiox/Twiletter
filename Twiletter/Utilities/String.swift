//
//  String.swift
//  Twiletter
//
//  Created by subdiox on 2017/12/08.
//  Copyright © 2017年 subdiox. All rights reserved.
//

import UIKit

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
    
    var escaped: String {
        var newString = self
        let char_dictionary = [
            "&" : "&amp;",
            "<" : "&lt;",
            ">" : "&gt;",
            "\"" : "&quot;",
            "'" : "&apos;"
        ]
        for (unescaped_char, escaped_char) in char_dictionary {
            newString = newString.replacingOccurrences(of: unescaped_char, with: escaped_char, options: NSString.CompareOptions.literal, range: nil)
        }
        return newString
    }
    
    var unescaped: String {
        var newString = self
        let char_dictionary = [
            "&amp;" : "&",
            "&lt;" : "<",
            "&gt;" : ">",
            "&quot;" : "\"",
            "&apos;" : "'"
        ]
        for (escaped_char, unescaped_char) in char_dictionary {
            newString = newString.replacingOccurrences(of: escaped_char, with: unescaped_char, options: NSString.CompareOptions.literal, range: nil)
        }
        return newString
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
    
    var countAttributed: NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let len = self.split(separator: " ")[0].count
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSMakeRange(0, len))
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSMakeRange(len, self.count - len))
        return attributedString
    }
    
//    func attributed(size: CGFloat) -> NSMutableAttributedString {
//        let attributedString = NSMutableAttributedString(string: self)
//        var index = self.unicodeScalars.startIndex
//        for wordWithBigSpace in self.components(separatedBy: .whitespacesAndNewlines) {
//            for word in wordWithBigSpace.components(separatedBy: "　") {
//                for keyword in ["http://", "https://", "@", "#"] {
//                    if word.contains(keyword) {
//                        let custom = word.unicodeScalars.distance(from: word.unicodeScalars.startIndex, to: word.range(of: keyword, options: .backwards)!.lowerBound)
//                        let from = self.unicodeScalars.index(index, offsetBy: custom)
//                        let to = self.unicodeScalars.index(index, offsetBy: word.unicodeScalars.count)
//                        let range = NSRange(from ..< to, in: self)
//                        attributedString.addAttribute(.link, value: "\(self.substring(with: range)!)".encoded, range: range)
//                    }
//                }
//                index = self.unicodeScalars.index(index, offsetBy: word.unicodeScalars.count + 1)
//            }
//        }
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineBreakMode = .byWordWrapping
//        attributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: size), NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSRange(self.startIndex ..< self.endIndex, in: self))
//        return attributedString
//    }
    
    func attributed(size: CGFloat, entities: Entities, preview: Bool) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)], range: NSRange(attributedString.string.startIndex ..< attributedString.string.endIndex, in: self))
        var replaces: [Replace] = []
        for media in entities.media {
            if (preview) {
                replaces.append(Replace(indices: media.indices, to: ""))
            } else {
                attributedString.addLink(indices: media.indices, link: media.expandedUrl)
                replaces.append(Replace(indices: media.indices, to: media.displayUrl))
            }
            break
        }
        for url in entities.urls {
            attributedString.addLink(indices: url.indices, link: url.expandedUrl)
            replaces.append(Replace(indices: url.indices, to: url.displayUrl))
        }
        for userMention in entities.userMentions {
            attributedString.addLink(indices: userMention.indices, link: "@\(userMention.screenName)")
        }
        for hashtag in entities.hashtags {
            attributedString.addLink(indices: hashtag.indices, link: "#\(hashtag.text)")
        }
        for symbol in entities.symbols {
            attributedString.addLink(indices: symbol.indices, link: "$\(symbol.text)")
        }
        replaces.sort()
        var offset = 0
        for replace in replaces {
            attributedString.replace(indices: replace.indices, string: replace.to, offset: &offset)
        }
        return attributedString.unescaped
    }
}

extension NSMutableAttributedString {
    func addLink(indices: Indices, link: String) {
        let start = self.string.unicodeScalars.startIndex
        let from = self.string.unicodeScalars.index(start, offsetBy: indices.from)
        let to = self.string.unicodeScalars.index(start, offsetBy: indices.to)
        let range = NSRange(from ..< to, in: self.string)
        self.addAttribute(.link, value: link.encoded, range: range)
    }
    
    func replace(indices: Indices, string: String, offset: inout Int) {
        let start = self.string.unicodeScalars.startIndex
        let from = self.string.unicodeScalars.index(start, offsetBy: indices.from + offset)
        let to = self.string.unicodeScalars.index(start, offsetBy: indices.to + offset)
        let range = NSRange(from ..< to, in: self.string)
        self.mutableString.replaceCharacters(in: range, with: string)
        offset += string.count - (indices.to - indices.from)
    }
    
    var escaped: NSMutableAttributedString {
        let char_dictionary = [
            "&" : "&amp;",
            "<" : "&lt;",
            ">" : "&gt;",
            "\"" : "&quot;",
            "'" : "&apos;"
        ]
        for (unescaped_char, escaped_char) in char_dictionary {
            while self.mutableString.contains(unescaped_char) {
                let range = self.mutableString.range(of: unescaped_char)
                self.replaceCharacters(in: range, with: escaped_char)
            }
        }
        return self
    }
    
    var unescaped: NSMutableAttributedString {
        let char_dictionary = [
            "&amp;" : "&",
            "&lt;" : "<",
            "&gt;" : ">",
            "&quot;" : "\"",
            "&apos;" : "'"
        ]
        for (escaped_char, unescaped_char) in char_dictionary {
            while self.mutableString.contains(escaped_char) {
                let range = self.mutableString.range(of: escaped_char)
                self.replaceCharacters(in: range, with: unescaped_char)
            }
        }
        return self
    }
}

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
    
    func format(until: Date) -> String {
        let comp1 = Calendar.current.dateComponents([.second], from: self, to: until)
        if (comp1.second! < 60) {
            return "\(comp1.second!)s"
        } else {
            let comp2 = Calendar.current.dateComponents([.minute], from: self, to: until)
            if (comp2.minute! < 60) {
                return "\(comp2.minute!)m"
            } else {
                let comp3 = Calendar.current.dateComponents([.hour], from: self, to: until)
                if (comp3.hour! < 24) {
                    return "\(comp3.hour!)h"
                } else {
                    let comp4 = Calendar.current.dateComponents([.day], from: self, to: until)
                    if (comp4.day! < 7) {
                        return "\(comp4.day!)d"
                    } else {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy/MM/dd"
                        return dateFormatter.string(from: until)
                    }
                }
            }
        }
    }
}

extension URL {
    func valueOf(key: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == key })?.value?.decoded
    }
}

