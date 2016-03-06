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


class Post: PFObject {
    
    var author: User!
    var likesCount: Int!
    var commentsCount: Int!
    var caption: String?
    var media: UIImage?
    
    
    
    //TODO: other methods
    func enlargeImage() {
        
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
    
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
