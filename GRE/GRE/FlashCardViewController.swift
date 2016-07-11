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
import SwiftyJSON

class FlashCardViewController: UIViewController {
    

    @IBOutlet weak var vFlashCard: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblMaster: UILabel!
    @IBOutlet weak var lblLearning: UILabel!
    @IBOutlet weak var vProgress: UIView!
    
    var vMaster   : UIView!
    var vReview   : UIView!
    var vLearning : UIView!
    
    var frontFlashCard : FrontFlashCardViewModel!
    var backFlashCard  : BackFlashCardViewModel!
    var isFlip = false
    var currentCard = 0
    var cardCollection = [Card]()
    
    var nextCardVariable  = Variable("")
    var numberOfLearning  : Variable<Int> = Variable(0)
    var numberOfReviewing : Variable<Int> = Variable(0)
    var numberOfMaster    : Variable<Int> = Variable(0)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configLayout()
        self.dumpData()
        
        vFlashCard.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init()
        _ = tapGesture.rx_event.subscribeNext {
            gestureReconizer in
            self.flipFlashCard()
        }
        self.vFlashCard.addGestureRecognizer(tapGesture)
    }
    
    func flipFlashCard() {
        let frameBackCard = CGRectMake(0, 0, vFlashCard.layer.frame.size.width,
                                       self.backFlashCard.height)
        self.backFlashCard.frame = frameBackCard
        if !self.isFlip {
            UIView.transitionFromView(frontFlashCard, toView: backFlashCard, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            self.isFlip = true
        }
        else {
            UIView.transitionFromView(backFlashCard, toView: frontFlashCard, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            self.isFlip = false
        }
    }
    
    //MARK: Config UI
    func configLayout() {
        self.vFlashCard.layoutIfNeeded()
        
        // Load FrontFlashCardView
        self.frontFlashCard = NSBundle.mainBundle().loadNibNamed("FrontFlashCardView", owner: self, options: nil) [0] as! FrontFlashCardViewModel
        let frameFrontCard = CGRectMake(0, 0, self.vFlashCard.layer.frame.size.width,
                                        2*self.vFlashCard.layer.frame.size.height/3)
        self.frontFlashCard.frame = frameFrontCard
        self.vFlashCard.addSubview(self.frontFlashCard)
        
        // Load BackFlashCardView
        self.backFlashCard = NSBundle.mainBundle().loadNibNamed("BackFlashCardView", owner: self, options: nil) [0] as! BackFlashCardViewModel
       
        self.backFlashCard.nextCardFlag = self.nextCardVariable
        
        // Label progress
        self.vReview = UIView()
        self.vMaster = UIView()
        self.vLearning  = UIView()
        
        _ = numberOfMaster.asObservable().subscribeNext {
            master in
            self.lblMaster.text = "Master : \(master)"
            if master != 0 {
                self.caculateProgressPhase(self.vMaster, color: MASTER_TAG_COLOR,
                    origiX: 0, numberCard: master)
                self.updateProgressPhase(self.vReview, origiX: self.vMaster.frame.width,
                    width: self.vReview.frame.width, height: self.vReview.frame.height)
                self.updateProgressPhase(self.vLearning, origiX: self.vMaster.frame.width +
                    self.vReview.frame.width,
                    width: self.vLearning.frame.width, height: self.vLearning.frame.height)

            }
        }
        
        _ = numberOfReviewing.asObservable().subscribeNext {
            review in
           self.lblReview.text = "Review : \(review)"
            if review != 0 {
                self.caculateProgressPhase(self.vReview, color: REVIEW_TAG_COLOR,
                    origiX: self.vMaster.frame.width, numberCard: review)
                self.updateProgressPhase(self.vLearning, origiX: self.vMaster.frame.width +
                    self.vReview.frame.width,
                    width: self.vLearning.frame.width, height: self.vLearning.frame.height)
            }
        }
        
        _ = numberOfLearning.asObservable().subscribeNext {
            learning in
            self.lblLearning.text = "Learning : \(learning)"
            if learning != 0 {
                self.caculateProgressPhase(self.vLearning, color: LEARNING_TAG_COLOR,
                    origiX: self.vReview.frame.width + self.vMaster.frame.width, numberCard: learning)
            }
        }
       
    }
    
    func caculateProgressPhase(view : UIView, color : UIColor, origiX : CGFloat, numberCard : Int) {
        let totalQuestion = self.cardCollection.count
        let width = self.vProgress.layer.bounds.width
        let vHeight = self.vProgress.layer.bounds.height
        let vWidth = CGFloat(numberCard)*width/CGFloat(totalQuestion)
        let frame = CGRectMake(origiX, 0, vWidth, vHeight)
        view.frame = frame
        view.backgroundColor = color
        view.removeFromSuperview()
        self.vProgress.addSubview(view)
    }
    
    func updateProgressPhase(view : UIView, origiX : CGFloat, width : CGFloat, height : CGFloat) {
        let frame = CGRectMake(origiX, 0, width, height)
        view.frame = frame
    }
    
    //MARK: Dump data
    func dumpData() {
        if let file = NSBundle(forClass:AppDelegate.self).pathForResource("text", ofType: "txt") {
            let data = NSData(contentsOfFile: file)!
            let json = JSON(data:data)
            
            for index in 0..<json[0]["card"].count {
                let jsonCard = json[0]["card"][index]
                let word     = jsonCard["word"].string!
                let type     = jsonCard["type"].string!
                let script   = jsonCard["script"].string!
                let tag      = jsonCard["tag"].string!
                print(word)
                
                if DB.getCardByWord(word) == nil {
                    let card = Card.create(word, type: type, script: script, tag: tag)
                    self.cardCollection.append(card)
                }
                else {
                    self.cardCollection.append(DB.getCardByWord(word))
                }
            }
            self.bindingData()
        } else {
            print("file not exists")
        }
    }
    
    func bindingData() {
        
        _ = self.nextCardVariable.asObservable().subscribeNext {
            next in
            
            if next != "" {
                
                UIView.transitionFromView(self.backFlashCard, toView: self.frontFlashCard, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
                self.isFlip = false
                let card = self.cardCollection[self.currentCard]
                
                // Progress learning
                if next == "notKnew" {
                    if card.tag == MASTER_TAG {
                        DB.updateTag(card, tag: LEARNING_TAG)
                        self.numberOfMaster.value -= 1
                        self.numberOfLearning.value += 1
                    }
                    else if card.tag == REVIEW_TAG {
                        DB.updateTag(card, tag: LEARNING_TAG)
                        self.numberOfReviewing.value -= 1
                        self.numberOfLearning.value += 1
                    }
                    else if card.tag == NEW_WORD_TAG {
                        DB.updateTag(card, tag: LEARNING_TAG)
                        self.numberOfLearning.value += 1
                    }
                }
                else if next == "knew" {
                    if card.tag == NEW_WORD_TAG {
                        DB.updateTag(card, tag: MASTER_TAG)
                        self.numberOfMaster.value += 1
                    }
                    else if card.tag == REVIEW_TAG {
                        DB.updateTag(card, tag: MASTER_TAG)
                        self.numberOfMaster.value += 1
                        self.numberOfReviewing.value -= 1
                    }
                    else if card.tag == LEARNING_TAG {
                        DB.updateTag(card, tag: REVIEW_TAG)
                        self.numberOfReviewing.value += 1
                        self.numberOfLearning.value  -= 1
                    }
                }
                self.currentCard += 1
                if self.currentCard == self.cardCollection.count {
                    self.currentCard = 0
                }
            }
            
            self.frontFlashCard.card = self.cardCollection[self.currentCard]
            self.backFlashCard.card  = self.cardCollection[self.currentCard]
            
            
        }
    }
}
