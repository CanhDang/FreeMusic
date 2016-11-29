//
//  TableViewCell.swift
//  FreeMusic
//
//  Created by Enrik on 11/28/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageSong: UIImageView!
    
    @IBOutlet weak var labelSong: UILabel!
    
    @IBOutlet weak var labelArtist: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    override func layoutSubviews() {
        self.imageSong.layer.cornerRadius = 22.5
        self.imageSong.layer.masksToBounds = true
    }
    
    func setupUI(song: Song) {
        
        self.labelSong.text = song.name
        self.labelArtist.text = song.artist
        
        DownloadManager.shared.downloadImage(url: song.imageUrl) { (image) in
            self.imageSong.image = image
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
