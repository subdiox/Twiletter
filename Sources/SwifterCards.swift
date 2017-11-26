//
//  SwifterCards.swift
//  Swifter
//
//  Created by subdiox on 2017/11/20.
//  Copyright © 2017年 Matt Donnelly. All rights reserved.
//

import Foundation

public extension Swifter {
    
    /**
        GET capi/passthrough/1

        Get cards information.
     **/
    public func getCards(cardUri: String, cardsPlatform: String = "iPhone-13", responseCardName: String = "poll4choice_text_only", success: SuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path: String = "capi/passthrough/1"
        
        var parameters = Dictionary<String, Any>()
        parameters["cards_platform"] = cardsPlatform
        parameters["include_cards"] = 1
        parameters["twitter:string:card_uri"] = cardUri
        parameters["twitter:string:cards_platform"] = cardsPlatform
        parameters["twitter:string:response_card_name"] = responseCardName
        
        self.getJSON(path: path, baseURL: .caps, parameters: parameters, success: { json, _ in success?(json) }, failure: failure)
    }
    
    /**
        POST    capi/passthrough/1
 
        Vote on the specified cards.
     **/
    public func selectCards(originalTweetId: String, cardUri: String, cardsPlatform: String = "iPhone-13", responseCardName: String = "poll4choice_text_only", selectedChoice: String, success: SuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path: String = "capi/passthrough/1"
        
        var parameters = Dictionary<String, Any>()
        parameters["cards_platform"] = cardsPlatform
        parameters["include_cards"] = 1
        parameters["twitter:long:original_tweet_id"] = originalTweetId
        parameters["twitter:string:card_uri"] = cardUri
        parameters["twitter:string:cards_platform"] ??= cardsPlatform
        parameters["twitter:string:response_card_name"] ??= responseCardName
        parameters["twitter:string:selected_choice"] = selectedChoice
        
        self.postJSON(path: path, baseURL: .caps, parameters: parameters, success: { json, _ in success?(json) }, failure: failure)
    }
    
    /**
        Convenience function for creating cards and tweet it.
     **/
    public func createAndPostCards(status: String, cards: [String], durationMinutes: Int = 1440, success: SuccessHandler? = nil, failure: FailureHandler? = nil) {
        self.createCards(cards: cards, durationMinutes: durationMinutes, success: { json in
            let cardUri = json["card_uri"].string!
            self.postCards(status: status, cardUri: cardUri, success: { json in success?(json) }, failure: failure)
        }, failure: failure)
    }
    
    /**
        POST    cards/create (Private API)
    
        Create cards.
     **/
    public func createCards(cards: [String], durationMinutes: Int = 1440, success: SuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path: String = "cards/create.json"
        
        var parameters = Dictionary<String, Any>()
        var cardData = Dictionary<String, Any>()
        cardData["twitter:api:api:endpoint"] = "1"
        cardData["twitter:long:duration_minutes"] = durationMinutes
        cardData["twitter:card"] = "poll\(cards.count)choice_text_only"
        for (index, string) in cards.enumerated() {
            cardData["twitter:string:choice\(index + 1)_label"] = string
        }
        parameters["card_data"] = cardData
        
        self.postJSON(path: path, baseURL: .caps, parameters: parameters, success: { json, _ in success?(json) }, failure: failure)
    }
    
    /**
        POST    statuses/update.json (Private API)
 
        Tweet with created cards.
     **/
    public func postCards(status: String, cardUri: String, cardsPlatform: String = "iPhone-13", success: SuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path: String = "statuses/update.json"
        
        var parameters = Dictionary<String, Any>()
        parameters["auto_populate_reply_metadata"] = true
        parameters["batch_mode"] = "off"
        parameters["card_uri"] = cardUri
        parameters["cards_platform"] = cardsPlatform
        parameters["contributor_details"] = 1
        parameters["enable_dm_commands"] = false
        parameters["ext"] = Ext.official.stringValue
        parameters["include_cards"] = 1
        parameters["include_carousels"] = 1
        parameters["include_entities"] = 1
        parameters["include_ext_media_color"] = true
        parameters["include_media_features"] = true
        parameters["include_my_retweet"] = 1
        parameters["include_profile_interstitial_type"] = true
        parameters["include_profile_location"] = true
        parameters["include_reply_count"] = 1
        parameters["include_user_entities"] = true
        parameters["include_user_hashtag_entities"] = true
        parameters["include_user_mention_entities"] = true
        parameters["include_user_symbol_entities"] = true
        parameters["status"] = status
        parameters["tweet_mode"] = "extended"

        self.postJSON(path: path, baseURL: .api, parameters: parameters, success: { json, _ in success?(json) }, failure: failure)
    }
    
}
