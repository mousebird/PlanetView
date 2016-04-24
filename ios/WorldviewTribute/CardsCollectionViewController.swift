//
//  CardsCollectionViewController.swift
//  WorldviewTribute
//
//  Created by Alli Dryer on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CardsCollectionViewController: UICollectionViewController {
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0)
    var config = WVTConfig()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(CardsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        // Get access to the config
        config = WVTConfig.init()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return Int(config.getNumCategories())
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return config.cardsForNthCategory(Int32(section)).count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CardsCollectionViewCell as CardsCollectionViewCell
    
        // Configure the cell
        cell.backgroundColor = .whiteColor()
        cell.layer.cornerRadius = 10
        cell.cardTableView.delegate = cell
        cell.cardTableView.dataSource = cell
        cell.cardTableView.reloadData()
        
        // Fill in the title and the image from the card
        let cards = config.cardsForNthCategory(Int32(indexPath.section))
        let card = cards[indexPath.row] as! WVTCard
        cell.card = card.makeDisplayCard()
        cell.cardCategoryLabel.text = card.title
        cell.reset()
        if (card.imageName != nil)
        {
            let imageName = card.imageName
            let image = UIImage.init(named: imageName)
            cell.cardImageView.image = image
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

extension CardsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 320, height: 600)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 24.0
    }
}

extension CardsCollectionViewController: CardTableCellSelectionDelegate {
    func cardTableCellWasSelected(indexPath: NSIndexPath) {
        print("cell selected, delegate acting")
        self.collectionView?.reloadData()
        self.collectionView?.layoutSubviews()
    }
}
