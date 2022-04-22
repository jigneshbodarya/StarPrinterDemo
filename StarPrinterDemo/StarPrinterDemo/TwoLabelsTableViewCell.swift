//
//  TwoLabelsTableViewCell.swift
//  CellarPass Table App
//
//  Created by Diana Petrea on 10/02/2017.
//  Copyright © 2017 CellarPass. All rights reserved.
//

import UIKit

class TwoLabelsTableViewCell: UITableViewCell {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
