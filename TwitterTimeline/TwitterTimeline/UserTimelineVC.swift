//
//  UserTimelineVC.swift
//  TwitterTimeline
//
//  Created by Christian Wollny on 03.04.15.
//  Copyright (c) 2015 Christian Wollny. All rights reserved.
//

import UIKit
import Accounts

class UserTimelineVC: UIViewController {
    
    // Twitter Account
    let accountStore = ACAccountStore()
    let twitterType = ACAccountStore().accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    var twitterAccount: ACAccount?
    
    // Array of Tweets
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get Twitter Account Access
        accountStore.requestAccessToAccountsWithType(twitterType, options: nil) {
            success, error in
            if success {
                let alleAccounts = self.accountStore.accountsWithAccountType(self.twitterType)
                if alleAccounts.count > 0 {
                    self.twitterAccount = alleAccounts.last as ACAccount?
                }
            }else{
                println(error.localizedDescription)
            }
        }

    }
    
    // MARK: - struct Tweet
    struct Tweet {
        var text: String
        var user: String
        var retweet_count: Int
        var favorite_count: Int
        var lang: String
    }

}
