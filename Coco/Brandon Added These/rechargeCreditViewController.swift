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
    @IBOutlet weak var cardImage: UIImageView!
    
    let userID = Defaults[.user]
    let cardID = UserDefaults.standard.string(forKey: "cardIDValue")
    let digits = UserDefaults.standard.string(forKey: "lastDigitsValue")
    let typeOfCard = UserDefaults.standard.string(forKey: "typeOfCard")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1, animations: {
            
            self.cardImage.alpha = 100
            
        })
        
    }
    
    //MARK: Funcs
    
    func configureView() {
        
        cardImage.alpha = 0
        
        cardNumbers.isUserInteractionEnabled = false
        cardNumbers.text! = "**** **** **** \(digits ?? "****")"
        cardNumbers.textAlignment = .center
        rechargeAmount.textAlignment = .center
        
        if typeOfCard == "VISA" {
            
            cardImage.image = UIImage(named: "visa_sola")
            
        }
        
        if typeOfCard == "MASTER CARD" {
            
            cardImage.image = UIImage(named: "mastercard")
            
        }
        
        if typeOfCard == "AMEX" {
            
            cardImage.image = UIImage(named: "amex")
            
        }
        
    }
    
    //MARK: Buttons
    
    @IBAction func cancelRecharge(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func rechargeButton(_ sender: Any) {
        
        if rechargeAmount.text!.isEmpty {
            
            let alert = UIAlertController(title: "¡Cuidado!", message: "Debes introducir una cantidad a recargar. 💵", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        if  Int(rechargeAmount.text!)! < 200 {
            throwError(str: "El monto a recargar no puede ser menor a $ 200")
            return
          }
        
        let url = URL(string: "https://easycode.mx/sistema_coco/webservice/controller_last.php")!
              
              var request = URLRequest(url: url)
              request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
              request.httpMethod = "POST" // Metodo
        
        let string1 = "funcion=rechargeBalance&id_token="+cardID!
        let string2 = "&amount="+rechargeAmount.text!
        let string3 = "&id_user="+userID!
        
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
                                      
                                      alert.addAction(UIAlertAction(title: "Genial", style: .cancel, handler: { action in
                                          
                                          let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                          let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainController") as! MainController
                                          newViewController.modalPresentationStyle = .fullScreen
                                          self.present(newViewController, animated: true, completion: nil)
                                          
                                      }))
                                      
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
                                    
                                    print(stateString)
                                                                            
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
