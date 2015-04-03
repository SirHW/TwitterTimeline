//
//  HashtagTimelineVC.swift
//  TwitterTimeline
//
//  Created by Christian Wollny on 03.04.15.
//  Copyright (c) 2015 Christian Wollny. All rights reserved.
//

import UIKit
import Accounts

class HashtagTimelineVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Twitter Account
    let accountStore = ACAccountStore()
    let twitterType = ACAccountStore().accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    var twitterAccount: ACAccount?
    
    // Array of Tweets
    var tweets = [Tweet]()

    // TableView
    @IBOutlet weak var tableView: UITableView!
    
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
    
    // MARK: - TableView methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTweets", forIndexPath: indexPath) as UITableViewCell
        
        let aktuellerTweet = tweets[indexPath.row]
        let titel = "\(aktuellerTweet.text)"
        let untertitel = aktuellerTweet.user
        
        cell.textLabel?.text = titel
        cell.detailTextLabel?.text = untertitel
        
        return cell
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
