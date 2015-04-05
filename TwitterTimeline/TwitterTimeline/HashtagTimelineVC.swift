//
//  HashtagTimelineVC.swift
//  TwitterTimeline
//
//  Created by Christian Wollny on 03.04.15.
//  Copyright (c) 2015 Christian Wollny. All rights reserved.
//

import UIKit
import Accounts
import Social

class HashtagTimelineVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // twitter timeline settings
//    let hashtag = "#Swift" // set the username here
    var hashtag: String?
    let number = "5" // set the number of tweets in the timeline here
    
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
//                self.getTwitterTimeline()
            }else{
                println(error.localizedDescription)
            }
        }
    }
    
    // Mark: - IBAction: loadTimelineForHashtag
    @IBAction func loadTimelineForHashtag(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: "Eingabe", message: "Bitte geben Sie einen Twitter Hashtag ein", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(){
            textField in
            textField.textAlignment = .Left
            textField.placeholder = "Hashtag"
            textField.becomeFirstResponder()
        }
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Hinzufügen", style: .Default, handler: {
            action in
            // do sth.
            self.hashtag = (alert.textFields![0] as UITextField).text
            self.getTwitterTimeline()
            self.navigationItem.title = "Tweets for \(self.hashtag!)"
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // Mark: - Twitter API Requests
    func getTwitterTimeline(){

        let url = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json")!
        
        if hashtag != nil { // unwrapping optional
        
            let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: ["q": hashtag!, "count": number])
            request.account = twitterAccount
            
            request.performRequestWithHandler { data, response, error in
                
                if response.statusCode == 200 {
                    
                    let stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    let json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as [String: AnyObject]
                    
                    let statuses = json["statuses"] as [[String: AnyObject]]
                    
                    for dict in statuses {
                        let text = dict["text"] as String
                        let user = dict["user"] as [String: AnyObject]
                        let username = user["screen_name"] as String
                        let retweet_count = dict["retweet_count"] as Int
                        let favorite_count = dict["favorite_count"] as Int
                        let lang = dict["lang"] as String
                        let neuerTweet = Tweet(text: text, user: username, retweet_count: retweet_count, favorite_count: favorite_count, lang: lang)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tweets.append(neuerTweet)
                            self.tableView.reloadData()
                        }
                    }
                }
                else {
                    println("\(response.statusCode): Verbindung zu Twitter fehlgeschlagen: \(error)")
                }
                
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
        let cell = tableView.dequeueReusableCellWithIdentifier("HashtagTweets", forIndexPath: indexPath) as UITableViewCell
        
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
