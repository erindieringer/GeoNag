//
//  DetailListTableViewCell.swift
//  iOSApp
//
//  Created by Katie Williams on 12/2/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit

class DetailListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var item: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
