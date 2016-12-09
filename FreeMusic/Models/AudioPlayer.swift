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


let urlSong = "http://api.mp3.zing.vn/api/mobile/search/song?requestdata={\"q\":\"%@\", \"sort\":\"hot\", \"start\":\"0\", \"length\":\"10\"}"


class AudioPlayer {
    static let shared = AudioPlayer()
    
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    
    var title = ""
    var artist = ""
    
    var duration: Float!
    var currentTiem: Float!
    
    var repeating : Int = Constant.RepeatAll
    var playing = false
    
    var shuffle: Bool = false
    
    var songPosition: Int!
    var song: Song!
    var listSong: [Song]!
    
    var isLinkLoaded = false
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func playLink(url: String) {
        
        self.initRemoteControl()
        
        if self.player != nil {
            self.player.pause()
        }
        
        playerItem = AVPlayerItem(url: URL(string: url)!)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0
        player.play()
        playing = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    @objc func playerItemDidPlayToEnd(_ notification: Notification){
        if self.repeating == 0 {
            self.playing = false
        } else if self.repeating == 1 {
            self.player.seek(to: kCMTimeZero)
            self.player.play()
        } else if self.repeating == 2 {
            if self.isLinkLoaded == true {
                self.song.isChosen = false
                
                self.actionNextSong()
                
                self.isLinkLoaded = false
            }
            
        }
    }
    
    func setup() {
        if self.player != nil {
            self.player.pause()
        }
        self.song = self.listSong[songPosition]
        self.song.isChosen = true
        
        let searchText = self.song.name + " " + self.song.artist
        let urlString = String(format: urlSong, searchText)
        print(urlString)

        DownloadManager.shared.downloadSongLink(urlString: urlString, keyword: searchText){
            searchSong in

            self.playLink(url: searchSong.link)
            
            self.setupInfoCenter()
            //self.setupCommandCener()
            
            self.isLinkLoaded = true
            
            self.appDelegate.playbarView.song = self.song
            self.appDelegate.playbarView.initPlay()
        }
    }
    
    
    // MARK: Action
    func actionPlayShuffle() {
        let random = arc4random_uniform(UInt32(self.listSong.count))
        self.songPosition = Int(random)
        self.setup()
    }
    
    func actionRepeatSong(repeating: Int!){
        self.repeating = repeating
    }
    
    func actionShuffle(_ shuffle: Bool){
        self.shuffle = shuffle
    }
    
    @objc func actionPlayPause() {
        if self.playing == true {
            self.player.pause()
            self.playing = false
        } else {
            self.player.play()
            self.playing = true
        }
    }
    
    func actionSliderDuration(_ value: Float) {
        duration = Float(CMTimeGetSeconds(playerItem.duration))
        let timeToSeek = value * duration
        let time = CMTimeMake(Int64(timeToSeek), 1)
        self.player.seek(to: time)
    }
    
    func playForward(_ time: Double) {
        let nextTime = CMTime(seconds: time, preferredTimescale: 1)
        self.player.seek(to: self.player.currentTime() + nextTime)
    }
    
    func playBackward(_ time: Double) {
        let backTime = CMTime(seconds: time, preferredTimescale: 1)
        self.player.seek(to: self.player.currentTime() - backTime)
    }
    
    
    @objc func actionNextSong() {
        self.song.isChosen = false
        if shuffle == true {
            self.actionPlayShuffle()
        } else {
            if songPosition < listSong.count - 1 {
                songPosition = songPosition + 1
            } else {
                songPosition = 0
            }
            self.setup()
        }
        
    }
    
    @objc func actionPreviousSong() {
        self.song.isChosen = false
        if shuffle == true {
            self.actionPlayShuffle()
        } else {
            if songPosition > 0 {
                songPosition = songPosition - 1
            } else {
                songPosition = listSong.count - 1
            }
            self.setup()
        }
        
    }
    
    // MARK: Remote Control Center
    func setupInfoCenter() {

        if self.song.image != nil {
            let image = MPMediaItemArtwork(image: self.song.image)
            self.setInfoCenterWithImage(image: image)
        } else {
            DownloadManager.shared.downloadImage(url: self.song.imageUrl, completed: { (image) in
                self.song.image = image
                let image = MPMediaItemArtwork(image: self.song.image)
                self.setInfoCenterWithImage(image: image)
            })
        }
        
        
    }
    
    func setInfoCenterWithImage(image: MPMediaItemArtwork) {
        let item = AudioPlayer.shared.playerItem
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtist: song.artist,
            MPMediaItemPropertyTitle: song.name,
            MPMediaItemPropertyArtwork: image,
            MPMediaItemPropertyPlaybackDuration: NSNumber(value: CMTimeGetSeconds((item?.asset.duration)!)),
            MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1)
        ]
    }
    
    func initRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        //self.becomeFirstResponder()
        
        
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
    
    func setupCommandCener() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(AudioPlayer.actionPlayPause))
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(self.actionNextSong))
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(self.actionPreviousSong))
        
    }
    
    
}


