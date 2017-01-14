//
//  OfflineSong.swift
//  FreeMusic
//
//  Created by Enrik on 12/14/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import Foundation
import RealmSwift

class OfflineSong: Object {
    dynamic var id = 0
    dynamic var data: Data?
    dynamic var name: String?
    dynamic var imageData: Data?
    dynamic var artist: String?

}
