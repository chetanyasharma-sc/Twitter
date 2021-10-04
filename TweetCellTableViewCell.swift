//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by chetanya sharma on 9/28/21.
//  Copyright © 2021 Dan. All rights reserved.
//
import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    var favorited: Bool = false
    var tweetId: Int = -1
//    var retweeted:Bool = false

    
    @IBOutlet weak var tweetContent: UILabel!
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var retweetButton: UIButton!
    

    
    @IBOutlet weak var favButton: UIButton!

    
    
    @IBAction func favoriteTweet(_ sender: Any) {
        
        let toBeFavorited = !favorited
        if(toBeFavorited){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { Error
                in
                print("favorite did not succeed \(Error)")
            })
        }
        
        else {
            
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { Error in
                print("unfavorite did not succeed \(Error)")
            })
        }
        
        
    }
        
    
    
    
    @IBAction func retweet(_ sender: Any) {
        
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
            
        }, failure: { Error in
            print("Error is retweeting \(Error)")
        })
        
       
        
    }
    
    
    func setFavorite(_ isFavorited: Bool){
        
        favorited = isFavorited
        if(favorited){
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
            
        }
        
        else {
            
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
            
        }
    }
    
    
    
    func setRetweeted (_ isRetweeted:Bool){
        if(isRetweeted){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
            
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
