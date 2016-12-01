//
//  NavDelegate.swift
//  FreeMusic
//
//  Created by Enrik on 12/1/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import Foundation
import UIKit

class NavDelegate: NSObject, UINavigationControllerDelegate {
    
    private let animator = Animator()
    
    func navigationController(navigationController: UINavigationController,
                              animationControllerForOperation operation: UINavigationControllerOperation,
                              fromViewController fromVC: UIViewController,
                              toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}
