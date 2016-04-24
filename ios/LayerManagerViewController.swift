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
    @IBOutlet weak var leftDateButton: UIButton!
    @IBOutlet weak var rightDateButton: UIButton!
    
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
        
        // Style the bar button item
        viewLayersBarButtonItem.setTitleTextAttributes([ NSFontAttributeName:UIFont(name: "Avenir-heavy", size: 14)!], forState: UIControlState.Normal)
        
        // Configuration file for the UI
        let configName = NSBundle.mainBundle().pathForResource("wv", ofType: "json")
        config = WVTConfig.init(file: configName)
        globeViewC.config = config
        
        self.testAdding()
    }
    
    @IBAction func onViewLayersBarButtonItemPressed(sender: AnyObject) {
        if layerManagerView.frame.origin.y == 76 {
            self.viewLayersBarButtonItem.title = "View Layers"
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.layerManagerView.transform = CGAffineTransformMakeTranslation(0.0, -800.0)
                self.datePickerView.transform = CGAffineTransformMakeTranslation(0.0, -800.0)
                self.layerManagerView.alpha = 0
                self.datePickerView.alpha = 0
                }, completion: { (finished: Bool) in
                //
            })
        } else {
            self.viewLayersBarButtonItem.title = "Hide Layers"
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.layerManagerView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
                self.datePickerView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
                self.layerManagerView.alpha = 1
                self.datePickerView.alpha = 1
                }, completion: { (finished: Bool) in
                    //
            })
        }
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
