//
//  giftDetailViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 18/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SDWebImage
import AVKit

class giftDetailViewController: UIViewController {
    
    @IBOutlet weak var orderNameNUmber: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var store: UILabel!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var friendMessageText: UILabel!
    @IBOutlet weak var buttonGetIt: UIButton!
    @IBOutlet weak var animationBackground: UIView!
    @IBOutlet weak var openedGiftImage: UIImageView!
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var aboveMessageLabel: UILabel!
    @IBOutlet weak var redeemGiftButton: UIButton!
    @IBOutlet weak var cover: UIView!
    
    var player : AVPlayer?
    var orderNumber : String!
    let userID = Defaults[.user]
    var giftStatus : String?
    var loader: LoaderVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        getGiftDetails()
        initializeVideoPlayerWithVideo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("refreshTheList"), object: nil)
    }
    
    func configureView() {
        backgroundView.addShadow()
        orderNameNUmber.roundCorners(12)
        buttonGetIt.roundCorners(12)
        openedGiftImage.alpha = 0
        animationBackground.alpha = 0
        aboveMessageLabel.alpha = 0
        friendMessageText.alpha = 0
        gotItButton.alpha = 0
        redeemGiftButton.roundCorners(12)
        redeemGiftButton.isHidden = true
    }
    
    func notShowingTheVideo() {
        DispatchQueue.main.async {
            self.cover.alpha = 0
            self.animationBackground.alpha = 0
            self.animationBackground.isUserInteractionEnabled = false
        }
    }
    
    func showingTheVideo() {
        DispatchQueue.main.async {
            self.cover.alpha = 0
            self.player?.play()
            self.animationBackground.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 2, animations: {
                    self.videoPlayer.alpha = 0
                    self.openedGiftImage.alpha = 1
                    self.gotItButton.alpha = 1
                    self.aboveMessageLabel.alpha = 1
                    self.friendMessageText.alpha = 1
                })
            }
        }
    }
    
    func initializeVideoPlayerWithVideo() {
        videoPlayer.clipsToBounds = true
        let videoString:String? = Bundle.main.path(forResource: "gift", ofType: "mp4")
        guard let unwrappedVideoPath = videoString else {return}
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        self.player = AVPlayer(url: videoUrl)
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.frame = videoPlayer!.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.cornerRadius = 30
        videoPlayer?.layer.addSublayer(layer)
    }
    
    @IBAction func alrightyThen(_ sender: Any) {
        DispatchQueue.main.async {
            self.animationBackground.alpha = 0
            self.animationBackground.isUserInteractionEnabled = false
        }
    }
    
    func getGiftDetails() {
        showLoader(&loader, view: view)
        let url = URL(string: "https://easycode.mx/sistema_coco/webservice/controller_last.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getPresentDetail&id_user="+userID!+"&id_order="+orderNumber
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            let gift = try? JSONDecoder().decode(giftDetailMain.self, from: data)
            let productnameText = gift?.data?.products![0].nombre
            let imageProduct = gift?.data?.products![0].imagen
            
            DispatchQueue.main.async {
                self.productName.text = productnameText
                self.productImage.sd_setImage(with: URL(string: imageProduct!), completed: nil)
                self.openedGiftImage.sd_setImage(with: URL(string: imageProduct!), completed: nil)
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let dictionary = json as? Dictionary<String, AnyObject> {
                if let items = dictionary["data"] {
                    if let info = items["info"] as? Dictionary<String, AnyObject>{
                        let orden = info["Id"] as! String
                        let fecha = info["fecha"] as! String
                        let status = info["estatus"] as! String
                        let cafeteria = info["nombre"] as! String
                        let amigo = info["alumno_regalo"] as! String
                        let mensajeAmigo = info["mensaje_amigo"] as! String
                        DispatchQueue.main.async {
                            self.orderNameNUmber.text = orden
                            self.date.text = "Fecha: " + fecha
                            self.status.text = "Estatus: " + status
                            self.store.text = "Cafetería: " + cafeteria
                            self.friendName.text = amigo
                            self.friendMessageText.text = mensajeAmigo
                            self.loader.removeAnimate()
                            if status == "Pagado" {
                                self.redeemGiftButton.isHidden = false
                            }
                        }
                        
                        if self.giftStatus == "Cerrado" {
                            self.showingTheVideo()
                        }
                        
                        if self.giftStatus == "Abierto" {
                            self.notShowingTheVideo()
                        }
                    }
                }
            }
        }.resume()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("refreshTheList"), object: nil)
    }
    
    @IBAction func redeemGift(_ sender: Any) {
        
        // Alert with action
        
        let alert = UIAlertController(title: "Canjeando", message: "¿De verdad quieres canjear el regalo?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Si", style: .destructive, handler: { action in
            
            let url = URL(string: "https://easycode.mx/sistema_coco/webservice/controller_last.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let postString = "funcion=changePresent&id_user="+self.userID!+"&id_order="+self.orderNumber
            request.httpBody = postString.data(using: .utf8)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil, response != nil else {
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let dictionary = json as? Dictionary<String, AnyObject> {
                    
                    if let estimatedTime = dictionary["data"] as? Dictionary<String, AnyObject> {
                        if let time = estimatedTime["TiempoEstimado"] {
                            UserDefaults.standard.set(time, forKey: "estimatedValue")
                        }
                    }
                    
                    if let state = dictionary["state"] {
                        if state as! String == "200" {
                            NotificationCenter.default.post(name: Notification.Name("refreshTheList"), object: nil)
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(false, forKey: "comingFromFriend")
                                // Register Nib
                                let newViewController = doneModalViewController(nibName: "doneModalViewController", bundle: nil)
                                newViewController.modalPresentationStyle = .fullScreen
                                // Present View "Modally"
                                self.present(newViewController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }.resume()
            
        }))
        
        self.present(alert, animated: true)
        
    }
    
}
