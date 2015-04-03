//
//  HashtagTimelineVC.swift
//  TwitterTimeline
//
//  Created by Christian Wollny on 03.04.15.
//  Copyright (c) 2015 Christian Wollny. All rights reserved.
//

import UIKit
import Accounts

class HashtagTimelineVC: UIViewController {
    
    // Twitter Account
    let accountStore = ACAccountStore()
    let twitterType = ACAccountStore().accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    var twitterAccount: ACAccount?

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

}
