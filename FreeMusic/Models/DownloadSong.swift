//
//  DownloadSong.swift
//  FreeMusic
//
//  Created by Enrik on 12/14/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit
import ReachabilitySwift
import Alamofire
import ACPDownload
import RealmSwift
import AVFoundation
import SlideMenuControllerSwift

class DownloadSong {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let shared = DownloadSong()
    
    var realm: Realm?
    var reachability: Reachability?
    weak var request: DownloadRequest?
    
    func download(song: Song) {
        
        realm = try? Realm()
        
        self.reachability = Reachability()
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                    let documentURL = URL(fileURLWithPath: documentPath, isDirectory: true)
                    let fileURL = documentURL.appendingPathComponent("\(song.name).mp3")
                    print(fileURL.absoluteString)
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }
                
                
                
                let searchText = song.name + " " + song.artist
                let urlString = String(format: urlSong, searchText)
                
                DownloadManager.shared.downloadSongLink(urlString: urlString, keyword: searchText){
                    searchSong in
                    song.link = searchSong.link
                    let link = searchSong.link
                    self.request = Alamofire.download(link, to: destination)
                    
                    var playbarView = PlaybarView()
                    if self.appDelegate.havingPlayBar == true {
                        playbarView = self.appDelegate.playbarView
                        
                        playbarView.buttonDownload.isHidden = true
                        playbarView.downloadView.isHidden = false
                    }
                    
                    self.request?.downloadProgress(closure: { (progress) in
                        if self.appDelegate.havingPlayBar == true {
                            playbarView.downloadView.setIndicatorStatus(.running)
                            playbarView.downloadView.setProgress(Float(progress.fractionCompleted), animated: true)
                        }
                        
                    }).responseData(completionHandler: { (response) in
                        
                        if let error = response.result.error {
                            print("error: \(error)")
                        }
                        
                        song.isDownloaded = true
                        
                        if self.appDelegate.havingPlayBar == true {
                            playbarView.downloadView.isHidden = true 
                        }
                        
                        if let vc = UIApplication.topViewController() as? SlideMenuController {
                            
                            if let naviVC = vc.mainViewController as? UINavigationController {
                                
                                if let detailVC = naviVC.topViewController as? DetailDiscoverViewController {
                                    detailVC.tableView.reloadData()
                                }
                                else if let playVC = naviVC.topViewController as? PlayViewController {
                                    playVC.tableView.reloadData()
                                }
                                
                            }
                            
                        }
                        
                        
                        if let data = response.result.value {
                            let offlineSong = OfflineSong()
                            offlineSong.data = data
                            offlineSong.name = song.name
                            offlineSong.artist = song.artist
                            offlineSong.imageData = UIImagePNGRepresentation(song.image)
                            
                            do {
                                try self.realm?.write {
                                    self.realm?.add(offlineSong)
                                }
                                
                                print("completed")
                            } catch {
                                
                                print("error: \(error.localizedDescription)")
                            }
                        }
                    })
                    
                }

            }
            
        }
        
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                print("not connect")
                
            }
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
             print("error: " + error.localizedDescription)
        }
    }
    
}
