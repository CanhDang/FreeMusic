//
//  Song.swift
//  FreeMusic
//
//  Created by Enrik on 11/29/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import Foundation
import UIKit

class Song {
    var imageUrl: String
    var name: String
    var artist: String
    var image: UIImage!
    
    init(imageUrl: String, name: String, artist: String) {
        self.imageUrl = imageUrl
        self.name = name
        self.artist = artist
    }
}
