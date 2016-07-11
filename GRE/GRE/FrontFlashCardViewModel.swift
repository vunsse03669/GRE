//
//  FrontFlashCardViewModel.swift
//  GRE
//
//  Created by Mr.Vu on 7/9/16.
//  Copyright © 2016 Mr.Vu. All rights reserved.
//

import UIKit

class FrontFlashCardViewModel: UIView {
    
    @IBOutlet weak var vTag: UIView!
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblTag: UILabel!
    var card : Card! {
        didSet{
            self.layout()
        }
    }
    
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 13
    }
    
    func layout() {
        self.lblWord.text = card.word
        self.lblTag.text = card.tag.uppercaseString
        
        if card.tag == NEW_WORD_TAG {
            self.vTag.backgroundColor = NEW_WORD_TAG_COLOR
        }
        else if card.tag == LEARNING_TAG {
            self.vTag.backgroundColor = LEARNING_TAG_COLOR
        }
        else if card.tag == REVIEW_TAG {
            self.vTag.backgroundColor = REVIEW_TAG_COLOR
        }
        else if card.tag == MASTER_TAG {
            self.vTag.backgroundColor = MASTER_TAG_COLOR
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
