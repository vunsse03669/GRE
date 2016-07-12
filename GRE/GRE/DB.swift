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
    
    static func getPackByName(name:String)->PackCard!{
        let predicate = NSPredicate(format: "name = %@", name)
        return realm.objects(PackCard).filter(predicate).first
    }
    
    static func getAllPacks()->[PackCard]{
        let packs = realm.objects(PackCard)
        var returnPacks = [PackCard]()
        for pack:PackCard in packs {
            returnPacks.append(pack)
        }
        return returnPacks
    }
    
    static func getNumberTagOfPack(pack: PackCard, tag:String) -> Int!{
        let findPack = getPackByName(pack.name)
        var numberCount = 0
        for card:Card in findPack.cards {
            if(card.tag == tag){
                numberCount += 1
            }
        }
        return numberCount
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
    
    static func updateTag(card : Card, tag : String) {
        try! realm.write {
            card.tag = tag
        }
    }
    
}
