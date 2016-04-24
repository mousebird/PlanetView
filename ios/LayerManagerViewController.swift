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
    @IBOutlet weak var layersTableView: UITableView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!

    
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
        insertBlurView(layerManagerView, style: UIBlurEffectStyle.Light)
        insertBlurView(datePickerView, style: UIBlurEffectStyle.Light)
        layerManagerView.clipsToBounds = true
        datePickerView.clipsToBounds = true
        layerManagerView.layer.cornerRadius = 10
        datePickerView.layer.cornerRadius = 10
        
        //animate in the Layers
        layerManagerView.transform = CGAffineTransformMakeTranslation(0.0, -800.0)
        datePickerView.transform = CGAffineTransformMakeTranslation(0.0, -800.0)
        UIView.animateWithDuration(0.5, delay: 0.6, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.layerManagerView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
            self.datePickerView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
            self.layerManagerView.alpha = 1
            self.datePickerView.alpha = 1
            }, completion: { (finished: Bool) in
                //
        })

        // Style the navigation bar and bar button items
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
    
    @IBAction func onSettingsBarButtonItemPressed(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    // hide the status bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func testAdding() {
        let timeStr = "2016-04-20"
        let reflectLayer = config.findLayer("VIIRS_SNPP_CorrectedReflectance_BandsM11-I2-I1")
        globeViewC.addWVTLayer(reflectLayer, forTime:timeStr)
        let dustLayer = config.findLayer("AIRS_Dust_Score")
        globeViewC.addWVTLayer(dustLayer, forTime:timeStr)
    }
    
    
}

//MARK: Table View Data Source
extension LayerManagerViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("layerItem") as! LayerItemCell
        
        //configure stuff
        //Data source needs to include selected/unselected state
        
        cell.layerNameLabel.text = "Layer Title"
        cell.layerDataSourceLabel.text = "SOURCES"
        cell.backgroundColor = .clearColor()
        
        return cell
    }
    
}

//MARK: Table View Delegate
extension LayerManagerViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Update data source with selected state change.
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor(red: 6/255, green: 41/255, blue: 70/255, alpha: 1)
        header.textLabel!.font = UIFont.init(name: "Avenir-Book", size: 12.0)
        header.textLabel!.text = "OVERLAYS"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
}