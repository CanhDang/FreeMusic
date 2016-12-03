//
//  DownloadManager.swift
//  FreeMusic
//
//  Created by Enrik on 11/27/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage
import ReachabilitySwift

class DownloadManager {
    
    static let shared = DownloadManager()
    
    let reachability = Reachability()
    
    
    func downloadGenre(url: String, completed: @escaping(_ string: String) -> Void) {
        
        guard let genreUrl = URL(string: url) else {
            return
        }
        
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                
                Alamofire.request(genreUrl).responseJSON { (response) in
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let feed = json["feed"]
                        let title = feed["title"]
                        guard let label = title["label"].string else {
                            return
                        }
                        let genreName = label.replacingOccurrences(of: "iTunes Store: Top Songs in " , with: "")
                        completed(genreName)
                    }
                    
                }
                
            }
            
        }
        
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                 print("not connect")
            }
        }
        
        try! reachability?.startNotifier()
        
    }
    
    func downloadImage(url: String, completed: @escaping(_ image: UIImage) -> Void) {
        print(url)
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                
                Alamofire.request(url).responseImage { (response) in
                    if let image = response.result.value {
                        print(image)
                        completed(image)
                    }
                }
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            print("not connect")
        }
        
        try! reachability?.startNotifier()
    }
    
    func downloadSong(url: String, completed: @escaping(_ songs: [Song]) -> Void) {
        
        guard let genreUrl = URL(string: url) else {
            return
        }
        
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                
                Alamofire.request(genreUrl).responseJSON { (response) in
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let feed = json["feed"]
                        guard let entry = feed["entry"].array else {
                            return
                        }
                        var listSong = [Song]()
                        for element in entry {
                            
                            guard let name = element["im:name"]["label"].string else {
                                return
                            }
                            
                            guard let imageArray = element["im:image"].array else {
                                return
                            }
                            
                            guard let imageUrl = imageArray[2]["label"].string else {
                                return
                            }
                            
                            guard let artist = element["im:artist"]["label"].string else {
                                return
                            }
                            
                            let song = Song(imageUrl: imageUrl, name: name, artist: artist)
                            listSong.append(song)
                            
                        }
                        
                        completed(listSong)
                        
                    }
                }
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            print("not connect")
        }
        
        try! reachability?.startNotifier()
    }
    
    func downloadSongLink(urlString: String, keyword: String, completed: @escaping(_ searchSong: SearchSong)->Void) {
        let fixedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: fixedUrlString!) else {
            return
        }
        
        print(url)
        var listSearch = [SearchSong]()
        var scoreMax: Double = -1
        
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                
                Alamofire.request(url).responseJSON { (response) in
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(json)
                        let docs = json["docs"].array
                        for doc in docs! {
                            let title = doc["title"].string
                            let artist = doc["artist"].string
                            let link_download = doc["link_download"]
                            let link = link_download["128"].string
                            
                            let text = title! + " " + artist!
                            let score = text.score(keyword, fuzziness: 1.0)
                            
                            let searchSong = SearchSong(title: title!, artist: artist!, link: link!, score: score)
                            listSearch.append(searchSong)
                            
                            if scoreMax < score {
                                scoreMax = score
                            }
                        }
                        
                        for searchSong in listSearch {
                            if searchSong.score == scoreMax {
                                completed(searchSong)
                                break
                            }
                        }
                        
                    }
                }
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            print("not connect")
        }
        
        try! reachability?.startNotifier()
    }
    
}
