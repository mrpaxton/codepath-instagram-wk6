//
//  User.swift
//  CodepathInstagram
//
//  Created by Sarn Wattanasri on 3/4/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import Foundation
import Parse


class User: PFUser {
    
    var post: Post?
    var profilePhoto: UIImage?
    
    func signup(username username: String, password: String) {
        self.username = username
        self.password = password
        self.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                print("Yay, account created!")
                //self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                print(error?.localizedDescription)
                if error?.code == 202 {
                    print("username already taken")
                }
            }
        }
        
    }
    
    func login() {
        
    }
    
    func signout() {
        PFUser.logOut()
        //go back to the login page
        //let loginViewController = UIStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
    }
    
    func forgetPassword() {
        
    }
}
