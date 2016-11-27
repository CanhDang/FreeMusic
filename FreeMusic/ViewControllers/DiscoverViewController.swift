//
//  DiscoverViewController.swift
//  FreeMusic
//
//  Created by Enrik on 11/27/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let url = "https://itunes.apple.com/us/rss/topsongs/limit=50/genre=%d/explicit=true/json"

class DiscoverViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var genreIndices = [2,3,4,5,6,7,9,10,11,12,14,15,16,17,18,19,20,21,22,24,34,50,51]
    
    var listUrl:Variable<[String]> = Variable<[String]>([])
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
    
        initListUrl()
        listUrl.asObservable().bindTo(
            self.collectionView.rx.items(cellIdentifier: "CollectionCell", cellType: CollectionViewCell.self)
            
        ) { (row, url, cell) in
            
            cell.setupUI(url: url, row: self.genreIndices[row])
        
        }.addDisposableTo(self.disposeBag)
        
    }

    func initListUrl() {
        for i in genreIndices {
            let string = String(format: url, i)
            listUrl.value.append(string)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    
    }
    

}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.width - 30) / 2, height: self.view.frame.height / 3 )
    }
    
}
