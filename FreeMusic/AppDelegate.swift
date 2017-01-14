//
//  AppDelegate.swift
//  FreeMusic
//
//  Created by Enrik on 11/27/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit
import MediaPlayer
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var havingPlayBar: Bool = false
    
    var playbarView: PlaybarView!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        let naviVC = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        let slideVC = SlideMenuController(mainViewController: naviVC, leftMenuViewController: menuVC)
        slideVC.closeLeft()
        self.window?.rootViewController = slideVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func addPlaybarView(animationFrame: CGRect) {
        playbarView = Bundle.main.loadNibNamed("PlaybarView", owner: nil, options: nil)?.first as! PlaybarView
        
        let rootView = self.window?.rootViewController?.view
        
        playbarView.translatesAutoresizingMaskIntoConstraints = false
        
        rootView?.addSubview(playbarView)
        
        playbarView.frame = animationFrame
        
        let distanceToBottom = (rootView?.frame.height)! - animationFrame.origin.y - animationFrame.height

        
        let horizontalConstraint = NSLayoutConstraint(item: playbarView, attribute: .centerX, relatedBy: .equal, toItem: rootView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: playbarView, attribute: .bottom, relatedBy: .equal, toItem: rootView, attribute: .bottom, multiplier: 1.0, constant: -distanceToBottom)
        let heightConstraint =  playbarView.heightAnchor.constraint(equalToConstant: 50)
        let widthConstraint = playbarView.widthAnchor.constraint(equalToConstant: (rootView?.frame.width)!)
        
        rootView?.addConstraints([horizontalConstraint, bottomConstraint, heightConstraint, widthConstraint])
        
        rootView?.layoutIfNeeded()
        
        UIView.animate(withDuration: 1) {
            bottomConstraint.constant = 0
            rootView?.layoutIfNeeded()
        }
        
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        let receivedControl = event?.subtype
        
        switch receivedControl! {
        case .remoteControlPlay:
            AudioPlayer.shared.actionPlayPause()
        case .remoteControlPause:
            AudioPlayer.shared.actionPlayPause()
        case.remoteControlNextTrack:
            AudioPlayer.shared.actionNextSong()
        case .remoteControlPreviousTrack:
            AudioPlayer.shared.actionPreviousSong()
        default:
            break 
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: CMTimeGetSeconds((AudioPlayer.shared.player.currentTime())))    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ComeBackApp"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

