//
//  Post.swift
//  CodepathInstagram
//
//  Created by Sarn Wattanasri on 3/1/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import Foundation
import UIKit
import Parse


class Post: PFObject, PFSubclassing {
    
    var id: Int?
    var author: User!
    var likesCount: Int!
    var commentsCount: Int!
    var caption: String?
    var media: PFFile?    
    
    //Conform to PFSubclassing
    class func parseClassName() -> String {
        return "Post"
    }
    
    /**
    Method to post user media to Parse by uploading image file
    
    - parameter image: Image that the user wants upload to parse
    - parameter caption: Caption text input by the user
    - parameter completion: Block to be executed after save operation is complete
    */
    class func postPFFileFromImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        
        let post = PFObject(className: "Post")
        
        // Prep data to be saved to Parse: add relevant fields to the object
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        post.saveInBackgroundWithBlock(completion)
    }
    
    class func allPosts( success: (posts: [Post]?) -> (), failure: ((error: NSError?) -> ())? )  {
        
        let query = PFQuery(className: "Post")
        query.whereKey("likesCount", greaterThanOrEqualTo: 0 )
        query.limit = 20
        
        //fetch data async and execute success or failure functions
        query.findObjectsInBackgroundWithBlock { ( posts: [PFObject]?, error: NSError? ) -> Void in
            if let posts = posts {
                let postArray = posts.map{ $0 as! Post }
                success(posts: postArray)
            } else {
                print(error?.localizedDescription)
                if let failure = failure {
                    failure(error: error)
                }
            }
        }
    }
    
    class func getPostWithId( id: Int, success: (post: Post?) -> () , failure: ((error: NSError?) -> ())? ) {
        
        let query = PFQuery(className: "Post")
        let idString = String(id)
        query.getObjectInBackgroundWithId(idString) { (post: PFObject?, error: NSError?) -> Void in
            if let post = post {
                success(post: post as? Post)
            } else {
                if let failure = failure {
                    failure(error: error)
                }
            }
        }
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
