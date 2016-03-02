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


class Post: NSObject {
    
    //TODO: other methods
    func enlargeImage() {
        
    }
    
    
    /**
    Method to post user media to Parse by uploading image file
    
    - parameter image: Image that the user wants upload to parse
    - parameter caption: Caption text input by the user
    - parameter completion: Block to be executed after save operation is complete
    */
    class func getPFFileFromImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        
        let media = PFObject(className: "Post")
        
        media["media"] = getPFFileFromImage(image)
        media["author"] = PFUser.currentUser()
        media["caption"] = caption
        media["likesCount"] = 0
        media["commentsCount"] = 0
        
        media.saveInBackgroundWithBlock(completion)
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
