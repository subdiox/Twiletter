//
//  Enum.swift
//  Twiletter
//
//  Created by subdiox on 2017/12/08.
//  Copyright © 2017年 subdiox. All rights reserved.
//

import Foundation

// Official Consumer Key / Secret (with full access of API)
enum Official {
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

enum Unofficial {
    enum TweetBoard: String {
        case key = "EJCN15HZpfnRxFoRvghXiUKTN"
        case secret = "8QrFG3L5MA2eSkIXjzwfU9WkOqBY4VCt05s4xHAdUb0wOO96WM"
    }
}

enum Constant: String {
    case keychainService = "TweetBoard"
}
