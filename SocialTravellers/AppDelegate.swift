//
//  AppDelegate.swift
//  SocialTravellers
//
//  Created by Emmanuel Sarella on 4/17/17.
//  Copyright © 2017 SocialTravellers. All rights reserved.
//

import UIKit
import Parse
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Facebook config - Initial setup
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Parse config
        let configuration = ParseClientConfiguration {
            $0.applicationId = Constants.APPLICATION_ID
            $0.server = Constants.SERVER_URL
        }
        Parse.initialize(with: configuration)
        
        if AccessToken.current != nil {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let hostViewController = storyBoard.instantiateViewController(withIdentifier: "HostViewController") as! HostViewController
            window?.rootViewController = hostViewController
            
        }
        print("AccessToken =\(String(describing: AccessToken.current))")

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil, queue: OperationQueue.main) {_ in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = loginViewController
        }
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Facebook config - Active users tracking
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Facebook config - Handle transition back from Safari
        let handled = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        
        return handled
    }
    
}

