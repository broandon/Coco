//
//  doneModalViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 06/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import AVKit

class doneModalViewController: UIViewController {
    
    var player: AVPlayer?
    let estimatedValue = UserDefaults.standard.value(forKey: "estimatedValue")
    
    @IBOutlet weak var doneCheckVideo: UIView!
    @IBOutlet weak var doneText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVideoPlayerWithVideo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainController") as! MainController
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
            print("THIS IS THE ESTIMATED TIME")
            print(self.estimatedValue)
        }
        
        if UserDefaults.standard.bool(forKey: "comingFromFriend") == true {
            doneText.text = "Tu regalo ha sido enviado. ¡Gracias!"
        }
        
        if UserDefaults.standard.bool(forKey: "comingFromFriend") == false {
            
            let theValue = "\(estimatedValue!)"
            
            if theValue == "0" {
                doneText.text = "¡Tu pedido ha sido enviado y se encuentra listo!"
                return
            }
            
            if theValue == "" {
                doneText.text = "Tu pedido ha sido enviado y estará listo en unos minutos"
                return
            }
            
            doneText.text = "Tu pedido ha sido enviado y estará listo en \(estimatedValue) minutos"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "comingFromFriend")
        player?.pause()
    }
    
    func initializeVideoPlayerWithVideo() {
        doneCheckVideo.clipsToBounds = true
        let videoString:String? = Bundle.main.path(forResource: "checkmark", ofType: "mp4")
        guard let unwrappedVideoPath = videoString else {return}
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        self.player = AVPlayer(url: videoUrl)
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.frame = doneCheckVideo!.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.cornerRadius = 30
        doneCheckVideo?.layer.addSublayer(layer)
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
