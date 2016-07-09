//
//  BackFlashCardViewModel.swift
//  GRE
//
//  Created by Mr.Vu on 7/9/16.
//  Copyright © 2016 Mr.Vu. All rights reserved.
//

import UIKit

class BackFlashCardViewModel: UIView {

    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblScript: UILabel!
    @IBOutlet weak var btnKnew: UIButton!
    @IBOutlet weak var btnNotKnew: UIButton!
    
    override func awakeFromNib() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
