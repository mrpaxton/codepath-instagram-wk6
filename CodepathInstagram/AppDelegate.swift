//
//  AppDelegate.swift
//  CodepathInstagram
//
//  Created by Sarn Wattanasri on 2/24/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil )
    var tabBarController: UITabBarController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //Parse.setApplicationId("CodepathInstagram", clientKey: "codepathatccsfiscool")
        
        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                User.registerSubclass()
                Post.registerSubclass()
                configuration.applicationId = "CodepathInstagramSW"
                configuration.clientKey = "codepathatccsfiscool"
                configuration.server = "https://codepath-instagram-sw.herokuapp.com/parse"
                
            })
        )
        
        //TODO: comment this out when user persist across app restart done
        PFUser.logOut()
        
        //setup and save the tabBarController as property
        initializeTabBar()
        
        //Bring the user to login if s/he is not in session
        if PFUser.currentUser() != nil {
            window?.rootViewController = tabBarController
            
        } else {
            let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            window?.rootViewController = loginVC
        }
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout",  name: userDidLogoutNotification, object: nil)
        
        return true
    }
    
    func userDidLogout() {
        //  print("Notification received")
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        window?.rootViewController = vc
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func initializeTabBar() {
        //first tab item
        let homeNavigationViewController = storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as! UINavigationController
        let homeViewController = homeNavigationViewController.topViewController as! HomeViewController
        homeViewController.tabBarItem.image = UIImage(named: "HomeIcon")
        
        //second tab item
        let cameraNavigationViewController = storyboard.instantiateViewControllerWithIdentifier("CameraNavigationController") as! UINavigationController
        let cameraViewController = cameraNavigationViewController.topViewController as! CameraViewController
        cameraViewController.tabBarItem.image = UIImage(named: "CameraIcon")
        
        //third tab item
        let profileNavigationViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
        let profileViewController = profileNavigationViewController.topViewController as! ProfileViewController
        profileViewController.tabBarItem.image = UIImage(named: "PersonIcon")
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationViewController, cameraNavigationViewController, profileNavigationViewController]
        tabBarController.tabBar.barTintColor = UIColor.yellowColor()
        self.tabBarController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    


}

