//
//  FrontFlashCardViewModel.swift
//  GRE
//
//  Created by Mr.Vu on 7/9/16.
//  Copyright © 2016 Mr.Vu. All rights reserved.
//

import UIKit

class FrontFlashCardViewModel: UIView {
    
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblTag: UILabel!
    var card : Card! {
        didSet{
            self.layout()
        }
    }
    
    override func awakeFromNib() {

    }
    
    func layout() {
        self.lblWord.text = card.word
        self.lblTag.text = card.tag
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
