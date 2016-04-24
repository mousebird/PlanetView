//
//  LayerItemCell.swift
//  WorldviewTribute
//
//  Created by Alli Dryer on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

import UIKit

class LayerItemCell: UITableViewCell {
    
    @IBOutlet weak var layerItemVisibilityButton: UIButton!
    @IBOutlet weak var layerNameLabel: UILabel!
    @IBOutlet weak var layerDataSourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
