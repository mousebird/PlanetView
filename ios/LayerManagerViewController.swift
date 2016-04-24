//
//  LayerManagerViewController.swift
//  WorldviewTribute
//
//  Created by Alli Dryer on 4/23/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

import UIKit

class LayerManagerViewController: UIViewController {
    
    @IBOutlet weak var viewLayersBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var layerManagerView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    
    var globeViewC = GlobeViewController()
    var config = WVTConfig()
    
    override func viewDidLoad() {
        
        // Load the globe
        globeViewC = GlobeViewController.init()
        self.view.addSubview(globeViewC.view)
        self.addChildViewController(globeViewC)
        
        // Load the UI
        self.view.addSubview(layerManagerView)
        self.view.addSubview(datePickerView)
        
        // Style the UI Views
        insertBlurView(layerManagerView, style: UIBlurEffectStyle.Dark)
        insertBlurView(datePickerView, style: UIBlurEffectStyle.Dark)
        layerManagerView.clipsToBounds = true
        datePickerView.clipsToBounds = true
        layerManagerView.layer.cornerRadius = 10
        datePickerView.layer.cornerRadius = 10
        
        // Style the bar button items
        viewLayersBarButtonItem.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir-heavy", size: 14)!], forState: UIControlState.Normal)

        
        // Configuration file for the UI
        let configName = NSBundle.mainBundle().pathForResource("wv", ofType: "json")
        config = WVTConfig.init(file: configName)
        globeViewC.config = config
        
        self.testAdding()
    }
    
    @IBAction func onViewLayersBarButtonItemPressed(sender: AnyObject) {
        layerManagerView.alpha = 1
    }
    
    // turn the status bar white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func testAdding() {
        globeViewC.addLayerByName("VIIRS_SNPP_CorrectedReflectance_BandsM11-I2-I1")
        //globeViewC.addLayerByName("MODIS_Terra_CorrectedReflectance_TrueColor")
        globeViewC.addLayerByName("AIRS_Dust_Score")
        //globeViewC.addLayerByName("MODIS_Terra_Aerosol")
    }
}
