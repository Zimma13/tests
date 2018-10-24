//
//  MonyTableViewCell.swift
//  TestProjectMonyList
//
//  Created by Zimma on 05/09/2018.
//  Copyright © 2018 Zimma. All rights reserved.
//

import UIKit

class MonyTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLblCell: UILabel!
    @IBOutlet weak var priceLblCell: UILabel!
    @IBOutlet weak var amountLblCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
