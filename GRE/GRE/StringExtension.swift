//
//  StringExtension.swift
//  GRE
//
//  Created by Mr.Vu on 7/15/16.
//  Copyright © 2016 Mr.Vu. All rights reserved.
//

import Foundation

extension String {
    func deleteHTMLTag(tag:String) -> String {
        return self.stringByReplacingOccurrencesOfString("(?i)</?\(tag)\\b[^<]*>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag)
        }
        return mutableString
    }
}