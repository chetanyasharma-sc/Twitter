//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by chetanya sharma on 9/28/21.
//  Copyright © 2021 Dan. All rights reserved.
//
import UIKit

class HomeTableViewController: UITableViewController {

    
    var tweetArray = [NSDictionary]()
    var numberOfTweets : Int!
    let myRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
     
        
        
        
        loadTweets()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadTweets()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadTweets()
    }
    
    
    @objc func loadTweets(){
        numberOfTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myparams = ["count": numberOfTweets]
        
       
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myparams, success: { (tweets: [NSDictionary]) in
            
            
            self.tweetArray.removeAll( )
            for tweet in tweets{
                
                self.tweetArray.append(tweet)
            }
            
            
            self.tableView.reloadData()
            
            self.myRefreshControl.endRefreshing()
            
        }, failure: { Error in
            print("could not retreive tweets !!!")
            
        })
    }
    
    
    
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberOfTweets = numberOfTweets + 20
        let myparams = ["count": numberOfTweets]
        
         TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myparams, success: { (tweets: [NSDictionary]) in
             
             
             self.tweetArray.removeAll( )
             for tweet in tweets{
                 
                 self.tweetArray.append(tweet)
             }
             
             
             self.tableView.reloadData()
             
            
             
         }, failure: { Error in
             print("could not retreive tweets !!!!")
             
         })
    }
    
    
    
    
    override func   tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            
            loadMoreTweets()
        }
    }
    
    
    
    
    
    @IBAction func OnLogout(_ sender: Any) {
        
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        
        UserDefaults.standard.set(false, forKey: "userLoggedin")
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath)as! TweetCellTableViewCell
        
        
        
        let user = tweetArray[indexPath.row]["user"]as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        
        
        
        let imageUrl = URL(string: (user["profile_image_url_https"]) as! String)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data{
            cell.profileImageView.image = UIImage(data:imageData)
           
        }
        
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"]as!Bool)
        
        
        return cell
    }
    
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    
    
    
    

}
