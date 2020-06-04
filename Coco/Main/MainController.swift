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
import Hero

class MainController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var cocopointsView: UIView!
    @IBOutlet weak var cocopointsBalance: UILabel!
    @IBOutlet weak var currentEstimatedTime: UIView!
    @IBOutlet weak var estimatedTimeText: UILabel!
    
    private var loader: LoaderVC!
    private var mainData: Main!
    let userID = Defaults[.user]
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainData = Main()
        configureView()
        configureTable()
        let pushManager = PushNotificationManager()
        pushManager.registerForPushNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: "reloadBalance"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "showedPromo") == true {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "promoViewController") as! promoViewController
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            UserDefaults.standard.set(false, forKey: "showedPromo")
            self.present(destVC, animated: true, completion: nil)
        }
        requestEstimatedTime()
    }
    
    func requestEstimatedTime() {
        let url = URL(string: "https://easycode.mx/sistema_coco/webservice/controller_last.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getUserMain&id_user="+userID!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
            if let dictionary = json as? Dictionary<String, AnyObject> {
                if let data = dictionary["data"] {
                    if let tiempoEstimado = data["ultimo_pedido"] {
                        let tiempoDePedido = "\(tiempoEstimado ?? 0)"
                        let tiempoDePedidoInt = Int(tiempoDePedido)
                        if tiempoDePedidoInt == nil {
                            self.currentEstimatedTime.isHidden = true
                            return
                        }
                        if tiempoDePedidoInt == 0 {
                            self.currentEstimatedTime.isHidden = true
                        } else {
                            DispatchQueue.main.async {
                                self.estimatedTimeText.text = "\(tiempoDePedidoInt?.msToSeconds.minute ?? 0) Minutos"
                                self.currentEstimatedTime.isHidden = false
                                self.currentEstimatedTime.slideInFromBottom()
                                self.countDownTest(minutes: (tiempoDePedidoInt?.msToSeconds.minute)!, seconds: (tiempoDePedidoInt?.msToSeconds.second)!)
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        task.resume()
    }
    
    func countDownTest(minutes: Int, seconds: Int) {
        
        var minutesToGo = minutes - 1
        
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            
            self.estimatedTimeText.text = "\(minutesToGo) Minutos"
            minutesToGo -= 1
            
            if minutesToGo == 0 {
                
                self.currentEstimatedTime.isHidden = true
                timer.invalidate()
                
            }
            
        }
        
    }
    
    @objc func shareTheCode() {
        
        let text = "¡Descarga Cocoapp y usa mi código para obtener saldo gratis en tu primera recarga! CODIGO: \(mainData.info?.codigo_referido ?? "--") Descargala en: https://apps.apple.com/mx/app/coco-app/id1470991257?l=en"
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @objc func didAddCode() {
        
        print("Labels Updated")
        mainData = Main()
        configureView()
        configureTable()
        
    }
    
    @objc func updateLabels() {
        print("Updating labels")
        mainData.requestUserMain { (result) in
            print("Labels data requested")
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                print("Labels data was succesfully received, updating texts")
                self.table.reloadData()
                DispatchQueue.main.async {
                    self.balanceLabel.text = "Saldo: $\(self.mainData.info?.current_balance ?? "--")"
                    self.cocopointsBalance.text = "Cocopoints: \(self.mainData.info?.cocopoints_balance ?? "--")"
                    print("Text populated")
                }
                self.table.reloadData()
            }
        }
    }
    
    @IBAction func showCards(_ sender: Any) {
        
        let vc = BalanceVC()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        presentAsync(vc)
        
    }
    
    @IBAction func codigos(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "newCodeViewController") as! newCodeViewController
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func showCocoPopUp(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            UserDefaults.standard.set("Cocopoints", forKey: "buttonPressed")
            
        }
        
        if sender.tag == 3 {
            
            UserDefaults.standard.set("tuCodigo", forKey: "buttonPressed")
            
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "popUpViewController") as! popUpViewController
        newViewController.modalPresentationStyle = .overCurrentContext
        newViewController.modalTransitionStyle = .crossDissolve
        newViewController.referalCode = mainData.info?.codigo_referido
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    private func configureView() {
        balanceView.roundCorners(15)
        cocopointsView.roundCorners(15)
        currentEstimatedTime.roundCorners(20)
        currentEstimatedTime.isHidden = true
        logo.slideInFromLeft()
    }
    
    private func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        
        let nib = UINib(nibName: BusinessTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: BusinessTableViewCell.cellIdentifier)
    }
    
    func requestData() {
        showLoader(&loader, view: view)
        mainData.requestUserMain { (result) in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                print(result)
                self.fillInfo()
            }
        }
    }
    
    func fillInfo() {
        table.reloadData()
        balanceLabel.text = "Saldo: $ \(mainData.info?.current_balance ?? "--")"
        cocopointsBalance.text = "Cocopoints: \(mainData.info?.cocopoints_balance ?? "--")"
        // referalCodeLabel.text = "Tu codigo: \(mainData.info?.codigo_referido ?? "")"
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
        case .cocopoints:
            let addCardVC = storedCardsViewController(nibName: "storedCardsViewController", bundle: nil)
            self.present(addCardVC, animated: true, completion: nil)
        case .promocode:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "newCodeViewController") as! newCodeViewController
            self.present(newViewController, animated: true, completion: nil)
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
            //  let domain = Bundle.main.bundleIdentifier!
            //  UserDefaults.standard.removePersistentDomain(forName: domain)
            //  UserDefaults.standard.synchronize()
            //  print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
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

