//
//  AlertViewController.swift
//  FreeMusic
//
//  Created by Enrik on 12/13/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    
    @IBOutlet weak var imageSong: UIImageView!
    
    @IBOutlet weak var labelSongName: UILabel!
    
    @IBOutlet weak var labelArtist: UILabel!
    
    var song: Song!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageSong.image = song.image
        
        self.labelSongName.text = song.name
        self.labelArtist.text = song.artist
        
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidLayoutSubviews() {
        self.imageSong.layer.cornerRadius = self.imageSong.frame.width / 2
        self.imageSong.layer.masksToBounds = true
    }


    @IBAction func actionCancel(_ sender: AnyObject) {

        self.dismiss(animated: true) { 
            UIApplication.topViewController()?.view.alpha = 1
        }
    }

    @IBAction func actionDownload(_ sender: AnyObject) {
        
        DownloadSong.shared.download(song: self.song)
        self.dismiss(animated: true) {
            UIApplication.topViewController()?.view.alpha = 1
        }
        
    }
    
    
}
