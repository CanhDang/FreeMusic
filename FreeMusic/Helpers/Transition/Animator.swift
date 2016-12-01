//
//  Animator.swift
//  FreeMusic
//
//  Created by Enrik on 12/1/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import Foundation
import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var selectedCellFrame: CGRect? = nil
    private var originalTableViewY: CGFloat? = nil
    
    var animationFrame: CGRect?
    
    var pushDuration: TimeInterval = 2
    var popDuration: TimeInterval = 2
    
    var image: UIImage?
    
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    

    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        // push
        if let discoverVC = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? DiscoverViewController,
            let detailVC = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? DetailDiscoverViewController {
            moveFromCategories(discoverVC: discoverVC, toList: detailVC, withContext: context)
        }
            
            // pop
        else if let discoverVC = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? DiscoverViewController,
            let detailVC = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? DetailDiscoverViewController {
            moveFromList(detailVC: detailVC, toDiscover: discoverVC, withContext: context)
        }
    }
    
    private func moveFromCategories(discoverVC: DiscoverViewController, toList detailVC: DetailDiscoverViewController, withContext context: UIViewControllerContextTransitioning) {
        let containerView = context.containerView
        let bgView = UIView(frame: discoverVC.view.frame)
        bgView.backgroundColor = UIColor.black
        containerView.addSubview(detailVC.view)
        detailVC.view.addSubview(bgView)
        
        let imageView = UIImageView(frame: animationFrame!)
        imageView.image = self.image
        
        let destinationFrame = CGRect(x: 18, y: 74, width: 80, height: 80)
        containerView.addSubview(imageView)
        
        UIView.animate(withDuration: self.pushDuration, animations: {
            imageView.frame = destinationFrame
            }) { (completed) in
                UIView.animate(withDuration: 0.3, animations: { 
                    bgView.alpha = 0
                    imageView.alpha = 0
                    }, completion: { (done) in
                        imageView.removeFromSuperview()
                        bgView.removeFromSuperview()
                        context.completeTransition(true)
                })
        }
    }
    
    private func moveFromList(detailVC: DetailDiscoverViewController, toDiscover discoverVC: DiscoverViewController, withContext context: UIViewControllerContextTransitioning) {
        
        let containerView = context.containerView
        let bgView = UIView(frame: containerView.frame)
        bgView.backgroundColor = UIColor.black
        containerView.addSubview(discoverVC.view)
        containerView.addSubview(detailVC.view)
        containerView.addSubview(bgView)
        
        let imageView = UIImageView(frame: CGRect(x: 18, y: 74, width: 80, height: 80))
        imageView.image = self.image
        containerView.addSubview(imageView)
        
        UIView.animate(withDuration: self.popDuration, animations: { 
            imageView.frame = self.animationFrame!
            detailVC.view.alpha = 0
            }) { (completed) in
                UIView.animate(withDuration: 0.3, animations: {
                    bgView.alpha = 0
                    
                    }, completion: { (done) in
                        detailVC.view.removeFromSuperview()
                        imageView.removeFromSuperview()
                        bgView.removeFromSuperview()
                        context.completeTransition(true)
                        
                })
        }
    }
    
    

}
