//
//  MenuViewController.swift
//  FreeMusic
//
//  Created by Enrik on 12/11/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self 
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        if indexPath.row == 0 {
            cell.imageMenu.image = UIImage(named: "menu-discovery")
            cell.labelTitle.text = "Discover"
        } else {
            cell.imageMenu.image = UIImage(named: "menu-playlist")
            cell.labelTitle.text = "Playlist"
        }
        
        return cell
    }
}
