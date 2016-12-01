//
//  PlaybarView.swift
//  FreeMusic
//
//  Created by Enrik on 12/1/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import Foundation
import UIKit

let urlSong = "http://api.mp3.zing.vn/api/mobile/search/song?requestdata={\"q\":\"%@\", \"sort\":\"hot\", \"start\":\"0\", \"length\":\"10\"}"

class PlaybarView: UIView {
    var song: Song!
    
    @IBOutlet weak var imageSong: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelArtist: UILabel!
    

    func initPlay() {
        DownloadManager.shared.downloadImage(url: song.imageUrl) { (image) in
            self.labelName.text = self.song.name
            self.labelArtist.text = self.song.artist
            self.imageSong.image = image
            self.imageSong.layer.cornerRadius = self.imageSong.frame.width / 2
            self.imageSong.layer.masksToBounds = true
        }
        let searchText = self.song.name + " " + self.song.artist
        let urlString = String(format: urlSong, searchText)
        print(urlString)
        
        DownloadManager.shared.downloadSongLink(urlString: urlString)
    }
}
