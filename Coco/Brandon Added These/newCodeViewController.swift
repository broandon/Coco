//
//  newCodeViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 24/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Hero

class newCodeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCodeButton: UIButton!
    let reuseDocument = "DocumentoCellCoupons"
    let userID = Defaults[.user]
    var codes : [Dictionary<String, Any>] = []
    
    //MARK: viewDid
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getThemCodes()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newCode), name: Notification.Name(rawValue: "newCodeReload"), object: nil)
        
    }
    
    //MARK: Tableview
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        let documentXib = UINib(nibName: "promoCodesTableViewCell", bundle: nil)
        tableView.register(documentXib, forCellReuseIdentifier: reuseDocument)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        codes.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let document = codes[indexPath.row]
        
        let amount = document["monto"]
        let date = document["fecha"]
        let token = document["token"]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath)
        
        cell.selectionStyle = .none
        
        if let cell = cell as? promoCodesTableViewCell {
            
            DispatchQueue.main.async {
                
                cell.montoLabel.text = amount as! String
                cell.fechaLabel.text = date as! String
                cell.codigoLabel.text = token as! String
                
            }
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    //MARK: Actions
    
    @IBAction func promoCodes(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addCode(_ sender: Any) {
        
        
        let addCardVC = addNewPromoCodeViewController(nibName: "addNewPromoCodeViewController", bundle: nil)
        
        self.present(addCardVC, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: Funcs
    
    @objc func newCode() {
        
        print("called")
        codes.removeAll()
        getThemCodes()
        DispatchQueue.main.async { self.tableView.reloadData() }
        
    }
    
    func getThemCodes() {
        
        let url = URL(string: "https://easycode.mx/sistema_coco/webservice/controller_last.php")!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getCodePromotionals&id_user="+userID!
        
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            
            do {
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let dictionary = json as? Dictionary<String, AnyObject>
                    
                {
                    
                    print("cupones")
                    print(dictionary)
                    print("*********")
                    
                    if let items = dictionary["data"] as? [Dictionary<String, Any>] {
                        
                        for d in items {
                            
                            self.codes.append(d)
                            
                        }
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    if self.codes.count > 0 {
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
            
        }.resume()
        
        
    }
    
    //MARK: Extensions
    
}
