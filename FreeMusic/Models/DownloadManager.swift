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

class DownloadManager {
    
    static let shared = DownloadManager()
    
    func downloadGenre(url: String, completed: @escaping(_ string: String) -> Void) {

        guard let genreUrl = URL(string: url) else {
            return
        }
        
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
    
    func downloadImage(url: String, completed: @escaping(_ image: UIImage) -> Void) {
        print(url)
        Alamofire.request(url).responseImage { (response) in
            if let image = response.result.value {
                print(image)
                completed(image)
            }
        }
    }
    
    func downloadSong(url: String, completed: @escaping(_ songs: [Song]) -> Void) {
        
        guard let genreUrl = URL(string: url) else {
            return
        }
        
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
                    
                    guard let imageUrl = imageArray[0]["label"].string else {
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
