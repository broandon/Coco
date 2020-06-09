//
//  popover1ViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 01/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class popover1ViewController: UIViewController {
    
    var cantidad = UserDefaults.standard.value(forKey: "cocopointsOtorgados")
    @IBOutlet weak var cantidadDeCOcos: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if cantidad == nil {
            cantidad = 0
        }
        cantidadDeCOcos.text = "\(cantidad ?? 0)"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "cocopointsOtorgados")
    }
}
