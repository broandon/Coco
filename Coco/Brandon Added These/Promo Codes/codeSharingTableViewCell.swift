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
        
        code.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1.0)
        
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 0.0, y: code.frame.height - 1, width: code.bounds.width, height: 1.0)
//        bottomLine.backgroundColor = UIColor(red: 0.18, green: 0.24, blue: 0.35, alpha: 1.00).cgColor
//        code.borderStyle = UITextField.BorderStyle.none
//        code.layer.addSublayer(bottomLine)
        
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

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

extension UIView {
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        switch position {
        case .LINE_POSITION_TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}
