//
//  LoginViewController.swift
//  CodepathInstagram
//
//  Created by Sarn Wattanasri on 2/24/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    var currentUser: User?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onSignUp(sender: AnyObject) {
        currentUser = User()
        currentUser!.signup(username: usernameField.text!, password: passwordField.text!)
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!, block: { (user: PFUser?, error: NSError?) in
            if let user = user {
                print("\(user) : You are logged in")
                //self.performSegueWithIdentifier("loginSegue", sender: self)
                
                //Get an instance of AppDelegate via UIApplication.sharedApplication().delegate
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //set its rootViewController to tabBarController(already setup in AppDelegate)
                appDelegate.window?.rootViewController = appDelegate.tabBarController
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
