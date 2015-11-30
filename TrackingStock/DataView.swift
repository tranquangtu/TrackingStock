//
//  ChartView.swift
//  Test
//
//  Created by Tatsumi on 10/11/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit

@IBDesignable class DataView: UIView {
    var view: UIView!
    
    
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbAVG: UILabel!
    @IBOutlet var lbYL: UILabel!
    @IBOutlet var lbYH: UILabel!
    @IBOutlet var lbCap: UILabel!
    @IBOutlet var lbVol: UILabel!
    @IBOutlet var lbLow: UILabel!
    @IBOutlet var lbOpen: UILabel!
    @IBOutlet var lbHigh: UILabel!
    var nibName: String = "DataView"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    func setup(){
        view = loadViewFromNil()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        addSubview(view)
    }
    
    func loadViewFromNil()->UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    
}
