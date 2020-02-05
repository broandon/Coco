//
//  MainController.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyUserDefaults

class MainController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var cocopointsView: UIView!
    @IBOutlet weak var cocopointsBalance: UILabel!
    
    private var loader: LoaderVC!
    private var mainData: Main!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainData = Main()
        configureView()
        configureTable()
        
        let pushManager = PushNotificationManager()
        pushManager.registerForPushNotifications()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    private func configureView() {
        balanceView.roundCorners(15)
        cocopointsView.roundCorners(15)
    }
    
    private func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        
        let nib = UINib(nibName: BusinessTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: BusinessTableViewCell.cellIdentifier)
    }
    
    private func requestData() {
        showLoader(&loader, view: view)
        mainData.requestUserMain { (result) in
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
        balanceLabel.text = "Saldo: $ \(mainData.info?.current_balance ?? "--")"
        cocopointsBalance.text = "Cocopoints: \(mainData.info?.cocopoints_balance ?? "--")"
    }
    
    @IBAction func menuAction(_ sender: Any) {
        let vc = instantiate(viewControllerClass: MenuVC.self)
        vc.delegate = self
        addChild(vc)
        let username = "\(mainData.info?.name ?? "") \(mainData.info?.last_name ?? "")"
        vc.showInView(aView: view, userName: username)
    }
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainData.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusinessTableViewCell.cellIdentifier, for: indexPath) as? BusinessTableViewCell else {
            return UITableViewCell()
        }
        
        let item = mainData.stores[indexPath.row]
        cell.businessName.text = item.name
        cell.businessSchedule.text = item.schedule
        cell.businessAddress.text = item.address
        cell.businessImage.kf.setImage(with: URL(string: item.imgURL ?? ""),
                                       placeholder: nil,
                                       options: [.transition(.fade(0.4))],
                                       progressBlock: nil,
                                       completionHandler: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = mainData.stores[indexPath.row]
        let vc = CategoriesVC()
        vc.modalPresentationStyle = .fullScreen
        vc.id_business = item.id ?? ""
        presentAsync(vc)
    }
}

extension MainController: MenuDelegate {
    func didSelectMenuOption(option: Menu) {
        switch option {
        case .profile:
            let vc = ProfileVC()
            vc.modalTransitionStyle = .crossDissolve
            presentAsync(vc)
        case .balance:
            let vc = BalanceVC()
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            presentAsync(vc)
        case .favorite:
            let vc = FavoritesVC()
            vc.modalTransitionStyle = .crossDissolve
            presentAsync(vc)
        case .orders:
            let vc = OrdersVC()
            presentAsync(vc)
        case .settings:
            let vc = SettingsVC()
            presentAsync(vc)
        case .session:
            Defaults.removeObject(forKey: "user")
            Defaults.removeObject(forKey: "token")
            Defaults.removeObject(forKey: "token_saved")
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
            let vc = instantiate(viewControllerClass: AccountVC.self)
            let wnd = UIApplication.shared.keyWindow
            var options = UIWindow.TransitionOptions()
            options.direction = .toBottom
            options.duration = 0.4
            options.style = .easeOut
            wnd?.setRootViewController(vc, options: options)
        }
    }
}

extension MainController: BalanceDelegate {
    func didChangeBalance() {
        requestData()
    }
}
