//
//  popUpViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 24/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    var typeOfInfo = UserDefaults.standard.value(forKey: "buttonPressed") as! String

    override func viewDidLoad() {
        super.viewDidLoad()

         checkInfo()

    }
    
    func checkInfo() {
    
        if typeOfInfo == "Cocopoints" {
            
            message.text = "Cocopoints es una nueva forma de pago, ahora por cada compra que realices se sumarán cocopoints a tu cuenta, con los cuales podrás adquirir más productos. ¡Cocopoints es la nueva forma de comprar!"
            
        }
        
        if typeOfInfo == "tuCodigo" {
            
            message.text = "¡Ahora compartir CocoApp te dará beneficios! Comparte tu código y colócalo en la sección de código promocional,y recibe saldo para seguir comprando."
            
        }
        
    }

    @IBAction func closePopUp(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
