//
//  Navigation.swift
//  TrackingStock
//
//  Created by Tatsumi on 10/29/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit


class Navigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//     override func shouldAutorotate() -> Bool {
//        if visibleViewController is MainViewController {
//            return false
//        }
//        return true
//    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if visibleViewController is MainViewController {
            return UIInterfaceOrientationMask.Portrait
        }else if visibleViewController is HistoricalViewController {
            return [UIInterfaceOrientationMask.LandscapeLeft, UIInterfaceOrientationMask.LandscapeRight]
        }else if visibleViewController is ChartViewController {
            return [UIInterfaceOrientationMask.LandscapeLeft, UIInterfaceOrientationMask.LandscapeRight]
        }else if visibleViewController is FinancialViewController {
            return [UIInterfaceOrientationMask.LandscapeLeft, UIInterfaceOrientationMask.LandscapeRight]
        }

        return UIInterfaceOrientationMask.All

    }


}
