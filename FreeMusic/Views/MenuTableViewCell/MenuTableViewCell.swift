//
//  MenuTableViewCell.swift
//  FreeMusic
//
//  Created by Enrik on 12/12/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {


    @IBOutlet weak var imageMenu: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
