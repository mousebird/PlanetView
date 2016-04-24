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

    var card = WVTDisplayCard()
    
    func reset() {
        cardTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return card.displayMeasures.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let measurement = card.displayMeasures[section] as! WVTDisplayMeasurement
        
        return measurement.sourcesAndLayers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let measurement = card.displayMeasures[section] as! WVTDisplayMeasurement
        let row = indexPath.row
        if (row >= measurement.sourcesAndLayers.count)
        {
            // Note: This shouldn't happen
            let cell = tableView.dequeueReusableCellWithIdentifier("subheader", forIndexPath: indexPath) as! SubheaderTableViewCell
            
            cell.subheaderLabel.text = "Error"
            cell.backgroundColor = .clearColor()

            return cell;
        }
        let entry = measurement.sourcesAndLayers[row]
        
        if (entry.isKindOfClass(WVTMeasurementSource))
        {
            let source = entry as! WVTMeasurementSource
            let cell = tableView.dequeueReusableCellWithIdentifier("subheader", forIndexPath: indexPath) as! SubheaderTableViewCell
            
            //configure stuff
            //Data source needs to include selected/unselected state
            
            cell.subheaderLabel.text = source.name
            cell.backgroundColor = .clearColor()
            
            return cell
        } else {
            let layer = entry as! WVTLayer
            let cell = tableView.dequeueReusableCellWithIdentifier(tvcReuseIdentifier, forIndexPath: indexPath) as! LayerItemCell
            
            //configure stuff
            //Data source needs to include selected/unselected state
            
            cell.layerNameLabel.text = layer.title
            cell.layerDataSourceLabel.text = layer.subtitle
            cell.backgroundColor = .clearColor()
            
            return cell
        }
        
        //return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let measurement = card.displayMeasures[indexPath.section] as! WVTDisplayMeasurement
        let row = indexPath.row
        
        // Note: Why does this happen?
        if (row >= measurement.sourcesAndLayers.count)
        {
            return 0.0;
        }
        let entry = measurement.sourcesAndLayers[row]

        if (entry.isKindOfClass(WVTMeasurementSource))
        {
            return 35.0
        } else {
            return 80.0
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let measurement = card.displayMeasures[section] as! WVTDisplayMeasurement

        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor(red: 6/255, green: 41/255, blue: 70/255, alpha: 1)
        header.textLabel!.font = UIFont.init(name: "Avenir-Book", size: 12.0)
        header.textLabel!.text = measurement.measure.title
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
}