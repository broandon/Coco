//
//  giftsTableViewCell.swift
//  Coco
//
//  Created by Brandon Gonzalez on 16/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

protocol showMeTheGiftDetail {
    func showTheDetail(idNumber:String)
}

class giftsTableViewCell: UITableViewCell {
    
    var orderNameID : String?

    static let cellIdentifier = "giftsTableViewCell"
    
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var dateOrder: UILabel!
    @IBOutlet weak var statusOrder: UILabel!
    @IBOutlet weak var storeOrder: UILabel!
    @IBOutlet weak var friendOrder: UILabel!
    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var underGiftButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    
    var delegate : showMeTheGiftDetail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        behindView.addShadow()
        orderName.roundCorners(12)
        behindView.layer.cornerRadius = 12
        underGiftButton.roundCorners(12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func openTheGift(_ sender: UIButton) {
        let currentcellnumber = "\(sender.tag)"
        self.delegate.showTheDetail(idNumber: currentcellnumber)
    }
    
    @IBAction func theDetails(_ sender: UIButton) {
        let currentcellnumber = "\(sender.tag)"
        self.delegate.showTheDetail(idNumber: currentcellnumber)
    }
    
}
