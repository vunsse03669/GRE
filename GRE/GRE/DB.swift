//
//  DB.swift
//  GRE
//
//  Created by Do Ngoc Trinh on 7/7/16.
//  Copyright © 2016 Mr.Vu. All rights reserved.
//

import RealmSwift

class DB: Object{
    
    static let realm = try! Realm()

    //MARK: PACKCARD
    static func createPack(pack : PackCard){
        try! realm.write{
            realm.add(pack)
        }
    }
    
    //MARK: CARD
    static func createCard(card : Card){
        try! realm.write{
            realm.add(card)
        }
    }
    
    static func getCardByWord(word : String) -> Card! {
        let predicate = NSPredicate(format: "word = %@", word)
        return realm.objects(Card).filter(predicate).first
    }
}
