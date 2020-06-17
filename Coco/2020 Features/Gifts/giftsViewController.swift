//
//  giftsViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 16/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class giftsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    var gifts : [Dictionary<String, Any>] = []
    let userID = Defaults[.user]
    let reuseDocument = "DocumentCellCards"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        getThemGifts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if gifts.count < 0 {
            
            tableView.isHidden = true
            
            return 0
            
        }
        
        return gifts.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let document = gifts[indexPath.row]
        
        let date = document["fecha"] as! String
        let status = document["estatus"] as! String
        let orden = document["Id"] as! String
        let businessName = document["nombre"] as! String
        let friend = document["amigo"] as! String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath)

        cell.selectionStyle = .none
        
        if let cell = cell as? giftsTableViewCell {
            
            DispatchQueue.main.async {
                cell.dateOrder.text = "Fecha: \(date)"
                cell.statusOrder.text = "Estatus: \(status)"
                cell.orderName.text = orden
                cell.friendOrder.text = "Amigo:" + friend
                cell.storeOrder.text = "Cafetería:" + businessName
            }
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    private func configureTable() {
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        let documentXib = UINib(nibName: "giftsTableViewCell", bundle: nil)
        table.register(documentXib, forCellReuseIdentifier: reuseDocument)
    }
    
    func getThemGifts() {
        
        print("Downloading gifts")
        
        let url = URL(string: "https://easycode.mx/sistema_coco/webservice/controller_last.php")!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getPresent&id_user="+userID!
        print(userID!)
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            
            do {
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let dictionary = json as? Dictionary<String, AnyObject>
                    
                {
                    
                    print(dictionary)
                    
                    if let items = dictionary["data"] as? [Dictionary<String, Any>] {
                        
                        for d in items {
                            
                            self.gifts.append(d)
                            
                            print("Appended cards")
                            
                        }
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    if self.gifts.count > 0 {
                        self.table.reloadData()
                        print("Tableview was reloaded")
                    }
                    
                }
                
            }
            
        }.resume()
        
        
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}