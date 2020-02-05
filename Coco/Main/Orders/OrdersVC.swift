//
//  OrdersVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class OrdersVC: UIViewController {

  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var table: UITableView!
  
  var loader: LoaderVC!
  var orders: Orders!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    orders = Orders()
    configureTable()
    requestData()
  }
  
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
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.cellIdentifier, for: indexPath) as? OrderTableViewCell else {
      return UITableViewCell()
    }
    let item = orders.orders[indexPath.row]
    cell.orderNumber.text = "Orden \(item.id ?? "--")"
    cell.dateLabel.text = "Fecha: \(item.date ?? "--")"
    cell.statusLabel.text = "Estatus: \(item.status ?? "--")"
    cell.businessLabel.text = "Cafetería: \(item.business ?? "--")"
    cell.amountLabel.text = item.total
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 187
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = instantiate(viewControllerClass: OrderDetail.self,
                         storyBoardID: "OrderDetail",
                         storyBoardName: "OrderStoryboard")
    vc.order = orders.orders[indexPath.row]
    presentAsync(vc)
  }
}
