//
//  PlanetPickerViewController.swift
//  WorldviewTribute
//
//  Created by Alli Dryer on 4/24/16.
//  Copyright © 2016 mousebird consulting. All rights reserved.
//

import UIKit

class PlanetPickerViewController: UIViewController {
    
    @IBOutlet weak var orbitLinesImageView: UIImageView!
    @IBOutlet weak var allPlanetsImageView: UIImageView!
    @IBOutlet weak var earthPointerLineImageView: UIImageView!
    @IBOutlet weak var marsPointerLineImageView: UIImageView!
    @IBOutlet weak var marsButton: UIButton!
    @IBOutlet weak var earthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orbitLinesImageView.alpha = 0
        allPlanetsImageView.transform = CGAffineTransformMakeTranslation(-1500.0, 0.0)
        earthPointerLineImageView.alpha = 0
        marsPointerLineImageView.alpha = 0
        marsButton.alpha = 0
        earthButton.alpha = 0
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options:
        UIViewAnimationOptions.CurveEaseIn, animations: { 
            self.allPlanetsImageView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
        }) { (finished: Bool) in
            UIView.animateWithDuration(0.5, animations: { 
                self.orbitLinesImageView.alpha = 0.2
                self.earthPointerLineImageView.alpha = 1
                self.marsPointerLineImageView.alpha = 1
                self.marsButton.alpha = 1
                self.earthButton.alpha = 1
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
