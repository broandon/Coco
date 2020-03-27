//
//  codeSharingTableViewCell.swift
//  Coco
//
//  Created by Brandon Gonzalez on 26/03/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class codeSharingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var gradientBackground: GradientView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: code.frame.height - 1, width: code.bounds.width - 15, height: 1.0)
        bottomLine.backgroundColor = UIColor(red: 0.18, green: 0.24, blue: 0.35, alpha: 1.00).cgColor
        code.borderStyle = UITextField.BorderStyle.none
        code.layer.addSublayer(bottomLine)
        
        codeButton.roundCorners(15)
        gradientBackground.roundCorners(30)
        shareButton.roundCorners(23)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func shareCoco(_ sender: Any) {
        
        print("Pressed share coco")
        
        NotificationCenter.default.post(name: Notification.Name("shareCoco"), object: nil)
        
    }
    
    @IBAction func exchangeCode(_ sender: Any) {
        
        let codeText = code.text!
        
        UserDefaults.standard.set(codeText, forKey: "code")
        
        print("Pressed exchange coco")
        
        NotificationCenter.default.post(name: Notification.Name("exchangeCode"), object: nil)
        
    }
    
    
}
