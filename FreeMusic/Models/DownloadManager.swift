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
    
}
