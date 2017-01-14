//
//  TableViewCell.swift
//  FreeMusic
//
//  Created by Enrik on 12/1/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageSong: UIImageView!
    
    @IBOutlet weak var labelSong: UILabel!
    
    @IBOutlet weak var labelArtist: UILabel!
    
    @IBOutlet weak var imageChosen: UIImageView!
    
    @IBOutlet weak var buttonDownload: UIButton!
    
    
    var song: Song!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
    }
    
    func setupUI(song: Song) {
        
        DownloadManager.shared.downloadImage(url: song.imageUrl) { (image) in
            self.labelSong.text = song.name
            self.labelArtist.text = song.artist
            self.imageSong.image = image
            self.imageSong.layer.cornerRadius = self.imageSong.frame.width / 2
            self.imageSong.layer.masksToBounds = true
            
            song.image = image
            
            self.song = song
            if song.isChosen == false {
                self.imageChosen.isHidden = true
            } else {
                self.imageChosen.isHidden = false 
            }
            
            if song.isDownloaded == true {
                self.buttonDownload.isHidden = true
            } else {
                self.buttonDownload.isHidden = false 
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func actionDownloadSong(_ sender: AnyObject) {
        let vc = UIApplication.topViewController()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        
        alertVC.song = self.song
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        vc?.present(alertVC, animated: true, completion: {
            vc?.view.alpha = 0.5
        })
    }
    
    
}
