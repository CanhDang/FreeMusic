//
//  AppDelegate.swift
//  FreeMusic
//
//  Created by Enrik on 11/27/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var havingPlayBar: Bool = false
    
    var playbarView: PlaybarView!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        return true
    }
    
    func addPlaybarView() {
        playbarView = Bundle.main.loadNibNamed("PlaybarView", owner: nil, options: nil)?.first as! PlaybarView
        
        let rootView = self.window?.rootViewController?.view
        
        playbarView.frame = CGRect(x: 0, y: 0, width: (rootView?.frame.width)!, height: 50)
        playbarView.translatesAutoresizingMaskIntoConstraints = false
        rootView?.addSubview(playbarView)
        
        let horizontalConstraint = NSLayoutConstraint(item: playbarView, attribute: .centerX, relatedBy: .equal, toItem: rootView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: playbarView, attribute: .bottom, relatedBy: .equal, toItem: rootView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let heightConstraint =  playbarView.heightAnchor.constraint(equalToConstant: 50)
        let widthConstraint = playbarView.widthAnchor.constraint(equalToConstant: (rootView?.frame.width)!)
        
        rootView?.addConstraints([horizontalConstraint, bottomConstraint, heightConstraint, widthConstraint])
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

