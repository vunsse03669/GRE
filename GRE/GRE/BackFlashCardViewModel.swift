//
//  BackFlashCardViewModel.swift
//  GRE
//
//  Created by Mr.Vu on 7/9/16.
//  Copyright © 2016 Mr.Vu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BackFlashCardViewModel: UIView {

    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblScript: UILabel!
    @IBOutlet weak var btnKnew: UIButton!
    @IBOutlet weak var btnNotKnew: UIButton!
    
    var height : CGFloat = 0
    var card : Card! {
        didSet{
            self.layout()
        }
    }
    var nextCardFlag = Variable("")
    
    override func awakeFromNib() {
        
        _ = btnKnew.rx_tap.subscribeNext {
            self.nextCardFlag.value = "knew"
        }
        _ = btnNotKnew.rx_tap.subscribeNext {
            self.nextCardFlag.value = "notKnew"
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layout() {
        self.lblWord.text   = self.card.word
        self.lblTag.text    = self.card.tag
        self.lblType.text   = self.card.type
        self.lblScript.text = self.card.script
        self.lblScript.sizeToFit()
        self.lblType.sizeToFit()
        self.height = self.lblWord.frame.size.height + self.lblType.frame.size.height
            + self.lblScript.frame.size.height + 80 + 88
        print(self.height)
    }

}
