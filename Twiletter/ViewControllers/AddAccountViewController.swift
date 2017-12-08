//
//  AddAccountViewController.swift
//  Twiletter
//
//  Created by subdiox on 2017/11/23.
//  Copyright © 2017年 Matt Donnelly. All rights reserved.
//

import UIKit
import SwifteriOS
import KeychainAccess

class AddAccountViewController: UITableViewController, UITextFieldDelegate {
    
    var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
    }
    
    @IBAction func usernameDidChange(_ sender: Any) {
        if (usernameTextField.text?.count == 0) {
            usernameTextField.text = "@"
        }
        reloadView()
    }
    
    @IBAction func passwordDidChange(_ sender: Any) {
        reloadView()
    }
    
    func reloadView() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
        if (usernameTextField.text != "" && passwordTextField.text != "") {
            cell?.textLabel?.textColor = UIColor.systemBlue
            cell?.selectionStyle = .default
        } else {
            cell?.textLabel?.textColor = UIColor.lightGray
            cell?.selectionStyle = .none
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (usernameTextField.text?.count == 0) {
            usernameTextField.text = "@"
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (usernameTextField.text == "@") {
            usernameTextField.text = ""
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath == IndexPath(row: 0, section: 1)) {
            tableView.deselectRow(at: indexPath, animated: true)
            activityIndicator.startAnimating()
            Common.swifterList.append(Swifter(consumerKey: Consumer.iPhone.key.rawValue, consumerSecret: Consumer.iPhone.secret.rawValue))
            Common.swifterList[Common.currentAccount].authorizePIN(username: usernameTextField.text!, password: passwordTextField.text!, success: { token, _ in
                let token = token!
                var included = false
                for accessToken in Common.tokenList {
                    if (accessToken.userID == token.userID) {
                        included = true
                    }
                }
                if !included {
                    let accessToken = AccessToken(key: token.key, secret: token.secret, screenName: token.screenName!, userID: token.userID!)
                    Common.tokenList.append(accessToken)
                    let tokenData = NSKeyedArchiver.archivedData(withRootObject: Common.tokenList)
                    let keychain = Keychain(service: "twiletter")
                    do {
                        try keychain.set(tokenData, key: "token")
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                } else {
                    print("Error: Your account is already registered")
                }
                self.activityIndicator.stopAnimating()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                self.present(mainViewController, animated: true, completion: nil)
            })
        }
    }
}

