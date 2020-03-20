//
//  ProductsVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class ProductsVC: UIViewController {
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var table: UITableView!
    
    var id_category: String = ""
    var id_business: String = ""
    var loader: LoaderVC!
    var products: Products!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        products = Products()
        configureTable()
        requestData()
    }
    
    private func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        let nib = UINib(nibName: ProductsTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: ProductsTableViewCell.cellIdentifier)
    }
    
    private func requestData() {
        showLoader(&loader, view: view)
        products.requestProducts(id_category: id_category, id_business: id_business) { result in
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
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.cellIdentifier, for: indexPath) as? ProductsTableViewCell else {
            return UITableViewCell()
        }
        let item = products.products[indexPath.row]
        cell.dishName.text = item.name
        cell.price.text = "Precio: $\(item.price ?? "--")"
        cell.cocopointsCost.text = "Cocopoints: \(item.cocopoints ?? 0)"
        cell.dishImage.kf.setImage(with: URL(string: item.imageURL ?? ""),
                                   placeholder: nil,
                                   options: [.transition(.fade(0.4))],
                                   progressBlock: nil,
                                   completionHandler: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = products.products[indexPath.row]
        let vc = instantiate(viewControllerClass: ProductDetailVC.self, storyBoardName: "Main")
        vc.product = item
        presentAsync(vc)
    }
}
