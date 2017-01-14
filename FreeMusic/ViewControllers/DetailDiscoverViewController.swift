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
import ReachabilitySwift

class DetailDiscoverViewController: UIViewController {

    @IBOutlet weak var imageGenre: UIImageView!
    
    @IBOutlet weak var labelGenre: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var genreIndex: Int!
    var genreName: String!
    
    var listSongs: Variable<[Song]> = Variable<[Song]>([])
    
    var disposeBag = DisposeBag()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Discover"
        
        self.setupInit()
        
        self.tableView.delegate = self
       
        self.tableView.register( UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        self.initListSong()
        
        setupTableView()
        
        self.navigationItem.hidesBackButton = true
        let tapOutGesture = UITapGestureRecognizer(target: self, action: #selector(popView))
        self.imageGenre.isUserInteractionEnabled = true
        self.imageGenre.addGestureRecognizer(tapOutGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveToPlayView), name: NSNotification.Name(rawValue: "moveToPlayView"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        
        self.selectCell()
        
    }
    
    func selectCell() {
        var indexRow: Int = -1
        if AudioPlayer.shared.song != nil {
            for (index,song) in listSongs.value.enumerated() {
                if song.name == AudioPlayer.shared.song.name {
                    indexRow = index
                    break
                }
            }
        }
        if indexRow > 0 {
            let indexPath = IndexPath(row: indexRow, section: 0)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
    }
    
    func moveToPlayView() {
        let playVC = self.storyboard?.instantiateViewController(withIdentifier: "PlayViewController")
        self.present(playVC!, animated: true, completion: nil)
    }
    
    func popView() {
        navigationController!.popViewController(animated: true)
    }

    func setupInit() {
        let image = UIImage(named: "genre-\(genreIndex!)")
        print(genreIndex)
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
                if AudioPlayer.shared.song != nil {
                    if song.name == AudioPlayer.shared.song.name {
                        song.isChosen = AudioPlayer.shared.song.isChosen
                    }
                }
                self.listSongs.value.append(song)
            }
            self.selectCell()
        }
        
    }
}

extension DetailDiscoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        cell.imageChosen.isHidden = false
        cell.song = listSongs.value[indexPath.row]
        cell.song.isChosen = true
        
        if appDelegate.havingPlayBar == false {
    
            appDelegate.havingPlayBar = true
            let cellRect = tableView.rectForRow(at: indexPath)
            let animationFrame = tableView.convert(cellRect, to: tableView.superview)
            appDelegate.addPlaybarView(animationFrame:animationFrame)
        }

        let audioPlayer = AudioPlayer.shared
        audioPlayer.listSong = self.listSongs.value
        audioPlayer.songPosition = indexPath.row
        audioPlayer.setup()
        
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        cell.imageChosen.isHidden = true
        cell.song.isChosen = false
    }
}



