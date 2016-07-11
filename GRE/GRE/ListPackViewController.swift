//
//  ListPackViewController.swift
//  GRE
//
//  Created by Mr.Vu on 7/7/16.
//  Copyright © 2016 Mr.Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import RealmSwift

class ListPackViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var vCollection: UIView!
    
    var collectionView:UICollectionView!
    var packs =  [PackCard]()
    @IBOutlet weak var clvPack: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dumpData()
        clvPack.registerNib(UINib.init(nibName: "clvPackCell", bundle: nil), forCellWithReuseIdentifier: "clvPackCell")
    }
    func configCollectionView() {
        self.view.layoutIfNeeded()
    }
    func dumpData() {
        if let file = NSBundle(forClass:AppDelegate.self).pathForResource("text", ofType: "txt") {
            let data = NSData(contentsOfFile: file)!
            let json = JSON(data:data)
            print(json)
            for index in 0..<json.count{
                print(index)
                let name  = json[index]["name"].string!
                let cards = json[index]["card"]
                let listCard : List<Card> = List<Card>()
                for index in 0..<cards.count{
                    let word     = cards[index]["word"].string!
                    let type     = cards[index]["type"].string!
                    let script   = cards[index]["script"].string!
                    let tag      = cards[index]["tag"].string!
                    let newCard : Card = Card.create(word, type: type, script: script, tag: tag);
                    listCard.append(newCard)
                }
                let newPack: PackCard = PackCard .create(name, cards:listCard)
                packs.append(newPack)
                clvPack.reloadData()
                print(packs.count)
            }
        } else {
            print("file not exists")
        }
    }
    
    //MARK: CollectionView datasource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30//packs.count;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "clvPackCell"
        
        var cell: clvPackCell! = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? clvPackCell
        
        if (cell == nil) {
            collectionView.registerNib(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? clvPackCell
        }
        let selectedPack : PackCard = packs[0]
        cell.cellWith(selectedPack)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let width = collectionView.frame.size.width/2-12;
        let height = width*0.57;
        return CGSize.init(width:width, height: height);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8,0, 8) // margin between cells
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    //MARK: CollectionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let flashCard : FlashCardViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("FlashCardViewController") as? FlashCardViewController)!
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.addAnimation(transition, forKey: kCATransition)
        presentViewController(flashCard, animated: false, completion: nil)
    }
    
    
}
