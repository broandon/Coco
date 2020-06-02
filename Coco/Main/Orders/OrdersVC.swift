//
//  OrdersVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class OrdersVC: UIViewController, showMeTheCoco, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var table: UITableView!
    
    var loader: LoaderVC!
    var orders: Orders!
    var estimated: OrderEstimatedTime!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orders = Orders()
        configureTable()
        requestData()
    }
    
    func showsTheCoco(position: UIView) {
                
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popoverID")
        
        // set the presentation style
        popController.modalPresentationStyle = .overCurrentContext
        popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = position
        popController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 100.0, height: 33.0)
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    // UIPopoverPresentationControllerDelegate method
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { return UIModalPresentationStyle.none }
    
    private func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        let nib = UINib(nibName: OrderTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: OrderTableViewCell.cellIdentifier)
    }
    
    private func requestData() {
        showLoader(&loader, view: view)
        orders.requestOrders { result in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                self.fillInfo()
            }
        }
    }
    
    private func fillInfo() {
        table.reloadData()
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.orders.count
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.cellIdentifier, for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        let item = orders.orders[indexPath.row]
        
        let timeToGo = item.tiempoEstimado?.msToSeconds
        
        cell.orderNumber.text = "Orden \(item.id ?? "--")"
        cell.dateLabel.text = "Fecha: \(item.date ?? "--")"
        cell.statusLabel.text = "Estatus: \(item.status ?? "--")"
        cell.businessLabel.text = "Cafetería: \(item.business ?? "--")"
        
        
        let otorgados = "\(item.cocopointsOtorgados ?? "0")"
        
        if otorgados == "0" {
            
            cell.buttonShowCoco.isHidden = true
            
        } else {
            
        cell.buttonShowCoco.tag = Int(otorgados)!
        
        }
            
        if item.tiempoEstimado == 0 {
            
            cell.tiempoEstimadoLabel.isHidden = true
            
        } else {
            
            cell.tiempoEstimadoLabel.text = "Tiempo estimado: \(timeToGo?.minute ?? 0) min. \(timeToGo?.second ?? 0) sec."
            
        }
        
        if item.tipoDeCompra == "1" {
            
            cell.amountLabel.text = item.total
            cell.montoCocoLabel.text = "Monto"
            
        } else if item.tipoDeCompra == "2" {
            
            cell.montoCocoLabel.text = "Cocopoints"
            cell.amountLabel.text = item.totalCocopoints
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195 //187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = instantiate(viewControllerClass: OrderDetail.self,
                             storyBoardID: "OrderDetail",
                             storyBoardName: "OrderStoryboard")
        vc.order = orders.orders[indexPath.row]
        presentAsync(vc)
    }
}

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}
