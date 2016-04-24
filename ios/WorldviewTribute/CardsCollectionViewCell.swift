//
//  CardsCollectionViewCell.swift
//  WorldviewTribute
//
//  Created by Alli Dryer on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

import UIKit

class CardsCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardCategoryLabel: UILabel!

    private let tvcReuseIdentifier = "layerItem1"

    var card = WVTCard()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return card.measurements.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let measurement = card.measurements[section] as! WVTMeasurement
        let measureSource = measurement.sources[0] as! WVTMeasurementSource
        return measureSource.layers.count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let measurement = card.measurements[indexPath.section] as! WVTMeasurement
        let measureSource = measurement.sources[0] as! WVTMeasurementSource
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("subheader", forIndexPath: indexPath) as! SubheaderTableViewCell
            
            //configure stuff
            //Data source needs to include selected/unselected state
            
            cell.subheaderLabel.text = measureSource.title
            cell.backgroundColor = .clearColor()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(tvcReuseIdentifier, forIndexPath: indexPath) as! LayerItemCell
            
            //configure stuff
            //Data source needs to include selected/unselected state
            let layer = measureSource.layers[indexPath.row-1] as! WVTLayer
            
            cell.layerNameLabel.text = layer.title
            cell.layerDataSourceLabel.text = layer.subtitle
            cell.backgroundColor = .clearColor()
            
            return cell
            
        }
        
        //return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 35.0
        } else {
            return 80.0
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let measurement = card.measurements[section]

        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor(red: 6/255, green: 41/255, blue: 70/255, alpha: 1)
        header.textLabel!.font = UIFont.init(name: "Avenir-Book", size: 12.0)
        header.textLabel!.text = measurement.title
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
}