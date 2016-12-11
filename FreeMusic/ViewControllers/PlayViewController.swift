//
//  PlayViewController.swift
//  FreeMusic
//
//  Created by Enrik on 12/4/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class PlayViewController: UIViewController {

    @IBOutlet weak var imageSong: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelCurrentTime: UILabel!
    
    @IBOutlet weak var labelRemainingTime: UILabel!
    
    @IBOutlet weak var buttonRepeat: UIButton!
    
    @IBOutlet weak var buttonPlay: UIButton!
    
    @IBOutlet weak var buttonShuffle: UIButton!
    
    @IBOutlet weak var buttonPrevious: UIButton!
    
    @IBOutlet weak var buttonNext: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var previousView: UIView!
    
    @IBOutlet weak var topConstraintSlider: NSLayoutConstraint!
    

    var listSong : Variable<[Song]> = Variable<[Song]>([])
    
    var audioPlayer = AudioPlayer.shared
    
    var disposeBag = DisposeBag()
    
    var pressPrevious = false
    
    var pressNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listSong.value = audioPlayer.listSong
        
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        self.setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
 
        let pressForward = UITapGestureRecognizer(target: self, action: #selector(self.actionNextSong))
        self.buttonNext.addGestureRecognizer(pressForward)
        
        let pressBackward = UITapGestureRecognizer(target: self, action: #selector(self.actionPreviousSong))
        self.buttonPrevious.addGestureRecognizer(pressBackward)
        
        NotificationCenter.default.addObserver(self, selector: #selector(initPlayView), name: NSNotification.Name(rawValue: "ComeBackApp"), object: nil)
        
        
    }

    
    func playerItemDidPlayToEnd(_ notification: Notification){
        if audioPlayer.repeating == 0 {
            self.buttonPlay.setImage(UIImage(named: "img-player-play"), for: .normal)
        } else {
            self.initPlayView()
        }
    }
    
    func moveCellTable() {
        let index = audioPlayer.songPosition
        let indexPath = IndexPath(row: index!, section: 0)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }
    
    func initPlayView() {
        self.pressPrevious = false
        self.pressNext = false
        self.tableView.reloadData()
        
        self.moveCellTable()

        self.buttonPlay.setImage(UIImage(named: "img-player-pause"), for: .normal)

        
        if audioPlayer.song.image != nil {
            self.imageSong.image = audioPlayer.song.image
        } else {
            DownloadManager.shared.downloadImage(url: audioPlayer.song.imageUrl, completed: { (image) in
                self.imageSong.image = image
                self.audioPlayer.song.image = image
            })
        }
        self.labelCurrentTime.text = "0:00"
        self.labelRemainingTime.text = "-0:00"
        self.slider.value = 0
        self.updateTime()
         _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    
    
    func setupTableView() {
        
        self.listSong.asObservable().bindTo(
            self.tableView.rx.items(cellIdentifier: "TableViewCell", cellType: TableViewCell.self)
        ) {(row, url, cell) in
            
            cell.setupUI(song: self.listSong.value[row])
            
        }.addDisposableTo(self.disposeBag)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.slider.setThumbImage(UIImage(named: "img-slider-thumb"), for: .normal)
        self.imageSong.image = audioPlayer.song.image

        self.topConstraintSlider.constant = -4
        
        if audioPlayer.playing == false {
            self.buttonPlay.setImage(UIImage(named: "img-player-play"), for: .normal)
        }
        
        switch audioPlayer.repeating {
        case 0:
            self.buttonRepeat.setImage(UIImage(named: "img-player-repeat-none"), for: .normal)
        case 1:
             self.buttonRepeat.setImage(UIImage(named: "img-player-repeat-1"), for: .normal)
        case 2:
            self.buttonRepeat.setImage(UIImage(named: "img-player-repeat"), for: .normal)
        default:
            break
        }
        
        if audioPlayer.shuffle == false {
            self.buttonShuffle.setImage(UIImage(named: "img-player-shuffle-off"), for: .normal)
        } else {
            self.buttonShuffle.setImage(UIImage(named: "img-player-shuffle"), for: .normal)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
       self.initPlayView()
        
    }
    
    func updateTime(){
        
        if audioPlayer.playing {
            self.buttonPlay.setImage(UIImage(named: "img-player-pause"), for: .normal)
        } else {
            self.buttonPlay.setImage(UIImage(named: "img-player-play"), for: .normal)
        }
        
            let duration = CMTimeGetSeconds(AudioPlayer.shared.playerItem.duration)
            
            let currentTime = Float(CMTimeGetSeconds(self.audioPlayer.player.currentTime()))
        
            self.slider.value =  currentTime/Float(duration)
        
            if duration > 0 {
                let currentMinute = Int(currentTime / 60)
                let currentSecond = Int(round(currentTime - Float(currentMinute * 60)))
                self.labelCurrentTime.text = String(format:"%d",currentMinute) + ":" + String(format:"%02d",currentSecond)
                
                let remainingTime = Float(duration) - currentTime
                
                let remainingMinute = Int(remainingTime / 60)
                let remainingSecond = Int(round(remainingTime - Float(remainingMinute * 60)))
                self.labelRemainingTime.text = String(format: "- %d", remainingMinute) + ":" + String(format: "%02d", remainingSecond)
            }

        if self.pressPrevious == true {
            if currentTime > 5 {
                audioPlayer.playBackward(5)
            }
        }
        
        if self.pressNext == true {
            if currentTime < Float(duration) {
                audioPlayer.playForward(5)
            }
        }
    }
    
    
    @IBAction func actionRepeat(_ sender: AnyObject) {
        var number: Int!
        switch audioPlayer.repeating {
        case Constant.RepeatNone:
            number = Constant.RepeatOne
            self.buttonRepeat.setImage(UIImage(named: "img-player-repeat-1"), for: .normal)
        case Constant.RepeatOne:
            number = Constant.RepeatAll
            self.buttonRepeat.setImage(UIImage(named: "img-player-repeat"), for: .normal)
        case Constant.RepeatAll:
            number = Constant.RepeatNone
            self.buttonRepeat.setImage(UIImage(named: "img-player-repeat-none"), for: .normal)
        default:
            break
        }
        audioPlayer.actionRepeatSong(repeating: number)
    }
    
    @IBAction func actionSlider(_ sender: UISlider) {
        audioPlayer.actionSliderDuration(sender.value)
    }
    
    @IBAction func actionPlay(_ sender: AnyObject) {
        audioPlayer.actionPlayPause()
        if audioPlayer.playing  {
            self.buttonPlay.setImage(UIImage(named: "img-player-pause"), for: .normal)
        } else {
            self.buttonPlay.setImage(UIImage(named: "img-player-play"), for: .normal)
        }
    }
    
    @IBAction func touchUpInsidePrevious(_ sender: AnyObject) {
        print("touchupInside")
        self.pressPrevious = false
    }
    
    @IBAction func touchUpInsideNext(_ sender: AnyObject) {
        print("touchUpInsideNext")
        self.pressNext = false
    }
    @IBAction func touchDownNext(_ sender: AnyObject) {
        print("touchDownNext")
        self.pressNext = true
    }

    func actionNextSong() {
        print("actionNextSong")
        
        audioPlayer.actionNextSong()
        initPlayView()
        
        self.pressNext = false
    }
    
    func actionPreviousSong() {
        print("backward")

        audioPlayer.actionPreviousSong()
        initPlayView()
   
        self.pressPrevious = false
    }
    
    @IBAction func touchDownPrevious(_ sender: AnyObject) {
        print("*************")
        print("touchDownPrevious")

        self.pressPrevious = true

    }

    @IBAction func actionShuffle(_ sender: AnyObject) {
        if audioPlayer.shuffle == true {
            audioPlayer.shuffle = false
            self.buttonShuffle.setImage(UIImage(named: "img-player-shuffle-off"), for: .normal)
        } else {
            audioPlayer.shuffle = true
            self.buttonShuffle.setImage(UIImage(named: "img-player-shuffle"), for: .normal)
        }
    }
    
    @IBAction func actionDismissView(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    
}

extension PlayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        audioPlayer.song.isChosen = false
        audioPlayer.songPosition = indexPath.row
        audioPlayer.setup()
        self.initPlayView()
    }
}
