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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func setupUI(song: Song) {
        
        DownloadManager.shared.downloadImage(url: song.imageUrl) { (image) in
            self.labelSong.text = song.name
            self.labelArtist.text = song.artist
            self.imageSong.image = image
            self.imageSong.layer.cornerRadius = self.imageSong.frame.width / 2
            self.imageSong.layer.masksToBounds = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
