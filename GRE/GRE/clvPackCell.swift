//
//  clvPackCell.swift
//  GRE
//
//  Created by Do Ngoc Trinh on 7/11/16.
//  Copyright © 2016 Mr.Vu. All rights reserved.
//

import UIKit

class clvPackCell: UICollectionViewCell {

    @IBOutlet weak var lblRemaining: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 3.0;
    }
    func cellWith(pack : PackCard){
        
    }
}
