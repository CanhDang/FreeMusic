//
//  DetailDiscoverViewController.swift
//  FreeMusic
//
//  Created by Enrik on 11/28/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class DetailDiscoverViewController: UIViewController {

    @IBOutlet weak var imageGenre: UIImageView!
    
    @IBOutlet weak var labelGenre: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var genreIndex: Int!
    var genreName: String!
    
    var listSongs: Variable<[Song]> = Variable<[Song]>([])
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Discover"
        
        self.setupInit()
        
        self.tableView.delegate = self
        
        self.initListSong()
        
        setupTableView()
        
        self.navigationItem.hidesBackButton = true
        let tapOutGesture = UITapGestureRecognizer(target: self, action: #selector(popView))
        self.imageGenre.isUserInteractionEnabled = true
        self.imageGenre.addGestureRecognizer(tapOutGesture)
    }
    
    func popView() {
        navigationController!.popViewController(animated: true)
    }

    func setupInit() {
        let image = UIImage(named: "genre-\(genreIndex!)")
        print(image)
        self.imageGenre.image = image
        self.labelGenre.text = self.genreName
        
    }
    
    func setupTableView(){
        
        listSongs.asObservable().bindTo(
            self.tableView.rx.items(cellIdentifier: "TableViewCell", cellType: TableViewCell.self)
        ) { (row, url, cell) in
            
            cell.setupUI(song: self.listSongs.value[row])
            
        }.addDisposableTo(self.disposeBag)
    }
    
    
    func initListSong() {
        let genreUrl = String(format: url, self.genreIndex)
        print(genreUrl)
        
        DownloadManager.shared.downloadSong(url: genreUrl) { (songs) in
            for song in songs {
                self.listSongs.value.append(song)
            }
        }
        
    }
}

extension DetailDiscoverViewController: UITableViewDelegate {
    
}



