//
//  CollectionViewCell.swift
//  FreeMusic
//
//  Created by Enrik on 11/27/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageGenre: UIImageView!
    
    @IBOutlet weak var labelGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(url: String, row: Int) {
        
        DownloadManager.shared.downloadGenre(url: url) { (title) in
            self.labelGenre.text = title
            self.imageGenre.image = UIImage(named: "genre-\(row)")
            print("genre-\(row)")
        }
    }
}
