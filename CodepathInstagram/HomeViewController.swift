//
//  HomeViewController.swift
//  CodepathInstagram
//
//  Created by Sarn Wattanasri on 3/4/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import Parse
import SwiftMoment

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, CameraViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var medias: [Post]!
    
    let CellIdentifier = "TableViewCell"
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    // property for refresh control
    var refreshControl: UIRefreshControl!
    
    // pull to refresh
    func pullToRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func onRefresh(){
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        delay(3, closure: {
            Post.allPosts( { (posts) in
                if let posts = posts {
                    self.medias = posts
                    self.tableView.reloadData()
                    
                }
            } , failure: nil )
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        tableView.registerClass(UITableViewHeaderFooterView.self , forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        
        //set a row height to the table view
        tableView.rowHeight = 320
        
        // call the pull to refresh control function
        pullToRefreshControl()
        
        //use a closure to call the instagram Parse
        Post.allPosts( { (posts) in
            if let posts = posts {
                self.medias = posts
                self.tableView.reloadData()
                
            }
        } , failure: nil )
    }
    
    func delay(delay:Double, closure: () -> ()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure
        )
    }
    
    //to be modified to replace with Parse
    //func callInstagramAPI( success: ([NSDictionary]?) -> () ) {
        
        
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
//            completionHandler: { (dataOrNil, response, error) in
//                if let data = dataOrNil {
//                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
//                        data, options:[]) as? NSDictionary {
//                            self.delay(
//                                3.0,
//                                closure: {
//                                    MBProgressHUD.hideHUDForView(self.view, animated: true )
//                                }
//                            )
//                            
//                            success( responseDictionary["data"] as? [NSDictionary] )
//                    }
//                }
//        });
//        task.resume()
    //}
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return medias?.count ?? 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        let profileView = makeProfileView(section)
        headerView.addSubview(profileView!)
        return headerView
    }
    
    func makeProfileView(section: Int) -> UIView? {
        let profileView = UIView(frame: CGRect(x: 0, y: -5, width: 320, height: 50))
        let profileLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 320, height: 50))
        
        let media = medias[section]
        var author = media["author"] as? User
        let timeAgo = media.createdAt
        let momentAgo = durationString(timeAgo)
        
        do {
            try author!.fetchIfNeeded()
            profileLabel.text = "\(author!.username!), \(momentAgo)"
        } catch _ {
            author = nil
        }
        
        
        let profileImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 5;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        
        profileImageView.image =
            UIImage(named: "PersonIcon")//
        
        profileView.addSubview(profileImageView)
        profileView.addSubview(profileLabel)
        
        return profileView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MediaCell", forIndexPath: indexPath ) as? MediaCell
        
        cell?.feedImageView.image = UIImage(named: "CameraIcon")
        
        let media = medias[indexPath.section]
        let userImageFile = media["media"]
        userImageFile!.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    cell!.feedImageView.image = image
                }
            }
        }
        cell?.captionLabel.text = media["caption"] as? String
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        return cell!
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PhotoDetailsViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        vc.photoURL = NSURL( string: medias[indexPath!.section].valueForKeyPath("images.standard_resolution.url") as! String)//
    }
    
    func didSendPhoto(cameraViewController: CameraViewController) {
        self.tableView.reloadData()
    }
    
    func durationString(createdAt: NSDate?) -> String {
        let durationAgo = (moment() - moment(createdAt!))
        if durationAgo.hours >= 24 {
            return "\(Int(durationAgo.days))d"
        } else if durationAgo.minutes >= 60 {
            return "\(Int(durationAgo.hours))h"
        } else if durationAgo.seconds >= 60 {
            return "\(Int(durationAgo.minutes))m"
        } else {
            return "1m"
        }
    }
}
