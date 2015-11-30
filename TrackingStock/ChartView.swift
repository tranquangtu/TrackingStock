//
//  ChartView.swift
//  Test
//
//  Created by Tatsumi on 10/11/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit

@IBDesignable class ChartView: UIView {
    var view: UIView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var btn1D: UIButton!
    @IBOutlet var btn5D: UIButton!
    @IBOutlet var btn1M: UIButton!
    @IBOutlet var btn6M: UIButton!
    @IBOutlet var btn1Y: UIButton!
    let bColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
    var image: UIImage!{
        get{
            return imageView.image
        }
        set{
            imageView.image = image
        }
    }
    func ChangeColor(str: String){
        
    }
    
    var nibName: String = "ChartView"
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
        self.btn1D.backgroundColor = bColor
        self.btn5D.backgroundColor = bColor
        self.btn1M.backgroundColor = bColor
        self.btn6M.backgroundColor = bColor
        self.btn1Y.backgroundColor = bColor
    }
    func loadbutton(str: String){
            switch(str){
            case "1d":
                self.btn1D.backgroundColor = UIColor.greenColor()
                self.btn5D.backgroundColor = bColor
                self.btn1M.backgroundColor = bColor
                self.btn6M.backgroundColor = bColor
                self.btn1Y.backgroundColor = bColor
                break
            case "5d":
                self.btn5D.backgroundColor = UIColor.greenColor()
                self.btn1D.backgroundColor = bColor
                self.btn1M.backgroundColor = bColor
                self.btn6M.backgroundColor = bColor
                self.btn1Y.backgroundColor = bColor
                break
            case "1m":
                self.btn1M.backgroundColor = UIColor.greenColor()
                self.btn5D.backgroundColor = bColor
                self.btn1D.backgroundColor = bColor
                self.btn6M.backgroundColor = bColor
                self.btn1Y.backgroundColor = bColor
                break
            case "6m":
                self.btn6M.backgroundColor = UIColor.greenColor()
                self.btn5D.backgroundColor = bColor
                self.btn1M.backgroundColor = bColor
                self.btn1D.backgroundColor = bColor
                self.btn1Y.backgroundColor = bColor
                break
            case "1y":
                self.btn1Y.backgroundColor = UIColor.greenColor()
                self.btn5D.backgroundColor = bColor
                self.btn1M.backgroundColor = bColor
                self.btn6M.backgroundColor = bColor
                self.btn1D.backgroundColor = bColor
                break
            default:
                break
            }
        
    }

    func loadViewFromNil()->UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

    
}
