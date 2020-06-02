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

        cantidadDeCOcos.text = "\(cantidad ?? 0)"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
