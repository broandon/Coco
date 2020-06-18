//
//  giftsTableViewCell.swift
//  Coco
//
//  Created by Brandon Gonzalez on 16/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class giftsTableViewCell: UITableViewCell {

    static let cellIdentifier = "giftsTableViewCell"
    
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var dateOrder: UILabel!
    @IBOutlet weak var statusOrder: UILabel!
    @IBOutlet weak var storeOrder: UILabel!
    @IBOutlet weak var friendOrder: UILabel!
    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var underGiftButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        behindView.addShadow()
        orderName.roundCorners(12)
        behindView.layer.cornerRadius = 12
        underGiftButton.roundCorners(12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
