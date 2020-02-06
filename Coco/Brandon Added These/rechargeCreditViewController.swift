//
//  rechargeCreditViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 2/5/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class rechargeCreditViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var cardNumbers: UITextField!
    @IBOutlet weak var rechargeAmount: UITextField!
    
    let userID = Defaults[.user]
    let cardID = UserDefaults.standard.string(forKey: "cardIDValue")
    let digits = UserDefaults.standard.string(forKey: "lastDigitsValue")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()

    }
    
    //MARK: Funcs
    
    func configureView() {
        
        cardNumbers.isUserInteractionEnabled = false
        cardNumbers.text! = "**** **** **** \(digits ?? "****")"
        cardNumbers.textAlignment = .center
        rechargeAmount.textAlignment = .center
    }
    
    //MARK: Buttons
    @IBAction func rechargeButton(_ sender: Any) {
        
        if rechargeAmount.text!.isEmpty {
            
            let alert = UIAlertController(title: "¡Cuidado!", message: "Debes introducir una cantidad a recargar. 💵", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        let url = URL(string: "https://easycode.mx/sistema_coco/webservice/controller_last.php")!
              
              var request = URLRequest(url: url)
              request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
              request.httpMethod = "POST" // Metodo
        
        let string1 = "funcion=rechargeBalance&id_token="+cardID!
        let string2 = "&amount="+rechargeAmount.text!
        let string3 = "&id_user"+userID!
        
        let postString = string1+string2+string3
        
        print(postString)
                            
              request.httpBody = postString.data(using: .utf8) // SE codifica a UTF-8
              
              let task = URLSession.shared.dataTask(with: request) { data, response, error in
                  
                  // Validacion para errores de Red
                  
                  guard let data = data, error == nil else {
                      print("error=\(String(describing: error))")
                      return
                  }
                  
                  do {
                      
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                      print(" \n\n Respuesta: ")
                      print(" ============ ")
                      print(json as Any)
                      print(" ============ ")
                      
                      if let parseJSON = json {
                          
                          if let state = parseJSON["state"]{
                              
                              let stateString = "\(state)"
                              
                              if stateString == "200" {
                                  
                                  DispatchQueue.main.async {
                                      
                                      let alert = UIAlertController(title: "¡Exito!", message: "Hemos recargado la cantidad solicitada a tu saldo. ¡A comer!", preferredStyle: .alert)
                                      
                                      alert.addAction(UIAlertAction(title: "Genial", style: .default, handler: nil))
                                      
                                      self.present(alert, animated: true)
                                      
                                  }
                                  
                              } else if stateString == "101" {
                                  
                                  DispatchQueue.main.async {
                                                                            
                                      let alert = UIAlertController(title: "Error", message: "Hemos encontrado un error. Intenta en unos minutos o verifica tener el saldo suficiente en tu tarjeta.", preferredStyle: .alert)
                                      
                                      alert.addAction(UIAlertAction(title: "Volver a intentar", style: .default, handler: nil))
                                      
                                      self.present(alert, animated: true)
                                      
                                  }
                                  
                              } else {
                                  
                                  DispatchQueue.main.async {
                                                                            
                                      let alert = UIAlertController(title: "Error", message: "Hay un problema con el servidor, inténtalo de nuevo más tarde.", preferredStyle: .alert)
                                      
                                      alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
                                      
                                      self.present(alert, animated: true)
                                      
                                  }
                                  
                              }
                              
                          }

                      }
                  }
              }
              
              task.resume()
        
    }
    
}
