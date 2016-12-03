//
//  PlaybarView.swift
//  FreeMusic
//
//  Created by Enrik on 12/1/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

let urlSong = "http://api.mp3.zing.vn/api/mobile/search/song?requestdata={\"q\":\"%@\", \"sort\":\"hot\", \"start\":\"0\", \"length\":\"10\"}"

class PlaybarView: UIView {
    var song: Song!
    
    @IBOutlet weak var imageSong: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelArtist: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    

    func initPlay() {
        
        if self.song.image != nil {
            DispatchQueue.main.async {
                self.imageSong.image = self.song.image
                self.labelName.text = self.song.name
                self.labelArtist.text = self.song.artist
                self.imageSong.layer.cornerRadius = self.imageSong.frame.width / 2
                self.imageSong.layer.masksToBounds = true
            }
        } else {
            DownloadManager.shared.downloadImage(url: song.imageUrl) { (image) in
                self.imageSong.image = image
                self.song.image = image
                self.labelName.text = self.song.name
                self.labelArtist.text = self.song.artist
                self.imageSong.layer.cornerRadius = self.imageSong.frame.width / 2
                self.imageSong.layer.masksToBounds = true
            }
        }
        
        

        let searchText = self.song.name + " " + self.song.artist
        let urlString = String(format: urlSong, searchText)
        print(urlString)
        
        DownloadManager.shared.downloadSongLink(urlString: urlString, keyword: searchText){
            searchSong in
            self.initRemoteControl()
            
            PlayMusic.shared.playLink(url: searchSong.link)
            
            self.setupInfoCenter()
            
            PlayMusic.shared.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/30, Int32(NSEC_PER_SEC)), queue: nil) { (time) in
                let duration = CMTimeGetSeconds(PlayMusic.shared.playerItem.duration)
                self.progressView.progress = Float(CMTimeGetSeconds(time)/duration)
            }
        }

    }
    
    func initRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        do  {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }

    func setupInfoCenter() {
        let item = PlayMusic.shared.playerItem
            
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtist: song.artist,
            MPMediaItemPropertyTitle: song.name,
            //MPMediaItemPropertyArtwork: song.image,
            MPMediaItemPropertyPlaybackDuration: NSNumber(value: CMTimeGetSeconds((item?.asset.duration)!)),
            MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1)
        ]
    }
    
    func setupCommandCenter() {
        //let commandCenter = MPRemoteCommandCenter.shared()
        
    }
    
}
