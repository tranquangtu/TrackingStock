//
//  CustomCell.swift
//  Test
//
//  Created by MICHELE on 10/5/15.
//  Copyright © 2015 MICHELE. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet var lbCode: UILabel!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbPrice: UILabel!
    @IBOutlet var lbPercent: UILabel!
    @IBOutlet var lbMC: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
