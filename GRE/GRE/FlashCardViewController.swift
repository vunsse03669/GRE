//
//  FlashCardViewController.swift
//  GRE
//
//  Created by Mr.Vu on 7/9/16.
//  Copyright © 2016 Mr.Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FlashCardViewController: UIViewController {
    @IBOutlet weak var vFlashCard: UIView!
    var frontFlashCard : FrontFlashCardViewModel!
    var backFlashCard  : BackFlashCardViewModel!
    var isFlip = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configLayout()
        
        vFlashCard.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init()
        _ = tapGesture.rx_event.subscribeNext {
            gestureReconizer in
            self.flipFlashCard()
        }
        vFlashCard.addGestureRecognizer(tapGesture)
    }
    
    func flipFlashCard() {
        if !isFlip {
            UIView.transitionFromView(frontFlashCard, toView: backFlashCard, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            isFlip = true
        }
        else {
            UIView.transitionFromView(backFlashCard, toView: frontFlashCard, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            isFlip = false
        }
    }
    
    //MARK: config UI
    func configLayout() {
        vFlashCard.layoutIfNeeded()
        let frameFrontCard = CGRectMake(0, 0, vFlashCard.layer.frame.size.width, 2*vFlashCard.layer.frame.size.height/3)
        let frameBackCard = CGRectMake(0, 0, vFlashCard.layer.frame.size.width, vFlashCard.layer.frame.size.height)
        // Load FrontFlashCardView
        frontFlashCard = NSBundle.mainBundle().loadNibNamed("FrontFlashCardView", owner: self, options: nil) [0] as! FrontFlashCardViewModel
        frontFlashCard.frame = frameFrontCard
        vFlashCard.addSubview(frontFlashCard)
        // Load BackFlashCardView
        backFlashCard = NSBundle.mainBundle().loadNibNamed("BackFlashCardView", owner: self, options: nil) [0] as! BackFlashCardViewModel
        backFlashCard.frame = frameBackCard
    }
}
