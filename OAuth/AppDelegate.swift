//
//  AppDelegate.swift
//  OAuth
//
//  Created by Dheepthaa Anand on 11/12/17.
//  Copyright © 2017 Dheepthaa Anand. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import FBSDKCoreKit
import Firebase
import FBSDKLoginKit
import TwitterKit
import GoogleSignIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Twitter.sharedInstance().start(withConsumerKey:"MTlxPXxh3WXibQKuwyy6TQvUc", consumerSecret:"KMnVvEgQAk9gxlyKC2PtpcllevhqI72rZIouGDL38racclxvj7")
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController = UIViewController()
        
        if UserDefaults.standard.string(forKey: "App") == nil
        {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "n1")
        }
        else if UserDefaults.standard.string(forKey: "App") == "fb"
        {
            
            initialViewController = 
                storyboard.instantiateViewController(withIdentifier: "n2")
        }
        else if UserDefaults.standard.string(forKey: "App") == "twit"
        {
            initialViewController =
                storyboard.instantiateViewController(withIdentifier: "n3")
            
        }
        else
        {
            initialViewController =
                storyboard.instantiateViewController(withIdentifier: "n4")
        }
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        Twitter.sharedInstance().application(app, open: url, options: options)
        GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
       return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //AppEventsLogger.activate(application)
    }
    
    
   
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

}

