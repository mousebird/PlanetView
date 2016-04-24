//
//  LayerManagerViewController.swift
//  WorldviewTribute
//
//  Created by Alli Dryer on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

import UIKit


class LayerManagerViewController: UIViewController {
    
    var globeViewC = GlobeViewController()
    var config = WVTConfig()
    
    override func viewDidLoad() {
        // Load the globe
        globeViewC = GlobeViewController.init()
        self.view.addSubview(globeViewC.view)
        self.addChildViewController(globeViewC)
        
        // Configuration file for the UI
        let configName = NSBundle.mainBundle().pathForResource("wv", ofType: "json")
        config = WVTConfig.init(file: configName)
        globeViewC.config = config
        
        self.testAdding()
    }

    func testAdding() {
        globeViewC.addLayerByName("VIIRS_SNPP_CorrectedReflectance_BandsM11-I2-I1")
        //globeViewC.addLayerByName("MODIS_Terra_CorrectedReflectance_TrueColor")
        globeViewC.addLayerByName("AIRS_Dust_Score")
        //globeViewC.addLayerByName("MODIS_Terra_Aerosol")
    }
}
