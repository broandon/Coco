//
//  promoViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 21/05/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyUserDefaults

class promoViewController: UIViewController {
    
    @IBOutlet weak var promoImage: UIImageView!
    var userProfile: UserProfile!
    var user: User!
    let userID = Defaults[.user]
    var urlToVisit : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requesData()
        
    }
    
    private func requesData() {
        
        let url = URL(string: "https://easycode.mx/sistema_coco/webservice/controller_last.php")!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let postString = "funcion=getUserMain&id_user="+userID!
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("error: No data to decode")
                return
            }
            
            guard let promoInfo = try? JSONDecoder().decode(Promo.self, from: data) else {
                
                print("Error: Couldn't decode data into info")
                return
                
            }
            
            let imageURL = promoInfo.data?.promocion?.imagen
            let URLDirection = promoInfo.data?.promocion?.link
            self.urlToVisit = URLDirection
            
            self.promoImage.sd_setImage(with: URL(string: imageURL ?? "No Image"), completed: nil)
            
            
        }
        
        
        task.resume()
        
        
    }
    
    @IBAction func goToProm(_ sender: Any) {
        
        if let url = URL(string: urlToVisit ?? "www.google.com") {
            UIApplication.shared.open(url)
            
        }
        
    }
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
