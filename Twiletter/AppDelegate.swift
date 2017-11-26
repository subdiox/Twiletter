//
//  AppDelegate.swift
//  Twiletter
//
//  Created by subdiox on 2017/11/22.
//  Copyright © 2017年 Matt Donnelly. All rights reserved.
//

import UIKit
import KeychainAccess
import SwifteriOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let keychain = Keychain(service: "twiletter")
        let tokenData = keychain[data: "token"]
        if let safeToken = tokenData {
            Common.tokenList = NSKeyedUnarchiver.unarchiveObject(with: safeToken) as! [AccessToken]
            for token in Common.tokenList {
                Common.swifterList.append(Swifter(consumerKey: Consumer.iPhone.key.rawValue, consumerSecret: Consumer.iPhone.secret.rawValue, oauthToken: token.key, oauthTokenSecret: token.secret))
            }
        }
        if (Common.swifterList.count > 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            window?.rootViewController = mainViewController
        }
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        processParameters(of: url)
        return true
    }
    
    func application(_ app: UIApplication, handleOpen url: URL) -> Bool {
        processParameters(of: url)
        return true
    }
    
    func processParameters(of url: URL) {
        if let type = url.valueOf(key: "type") {
            if let link = url.valueOf(key: "link") {
                if type == "http://" {
                    print("Open\(link)")
                } else if type == "https://" {
                    print("Open \(link)")
                } else if type == "@" {
                    print("Open mention \(link)")
                } else if type == "#" {
                    print("Open hashtag \(link)")
                }
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
