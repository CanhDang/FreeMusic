//
//  PlayMusic.swift
//  FreeMusic
//
//  Created by Enrik on 12/3/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import MediaPlayer

class PlayMusic {
    static let shared = PlayMusic()
    
    var player = AVPlayer()
    var playerItem: AVPlayerItem!
    
    func playLink(url: String) {
        
        playerItem = AVPlayerItem(url: URL(string: url)!)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0
        player.play()
        
    }
    
    
}
