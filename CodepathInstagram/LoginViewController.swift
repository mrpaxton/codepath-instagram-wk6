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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onSignUp(sender: AnyObject) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                print("Yay, account created!")
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                print(error?.localizedDescription)
                if error?.code == 202 {
                    print("username already taken")
                }
            }
        }
        
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!, block: { (user: PFUser?, error: NSError?) in
            if let user = user {
                print("\(user) : You are logged in")
                self.performSegueWithIdentifier("loginSegue", sender: self)
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
