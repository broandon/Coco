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
    
    //MARK: Outlets
    
    var player: AVPlayer?
    
    let estimatedValue = UserDefaults.standard.value(forKey: "estimatedValue")
    
    @IBOutlet weak var doneCheckVideo: UIView!
    @IBOutlet weak var doneText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeVideoPlayerWithVideo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            //self.close()
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainController") as! MainController
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
            
        }
        
        doneText.text = "Tu pedido ha sido enviado y estará listo en \(estimatedValue ?? "0") minutos"
        
    }
    
    //MARK: Funcs
    
    override func viewDidAppear(_ animated: Bool) {
        
        player?.play()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        player?.pause()
        
        
    }
    
    func initializeVideoPlayerWithVideo() {
        
        // Video will obey layout rules
        doneCheckVideo.clipsToBounds = true
        
        // get the path string for the video from assets
        let videoString:String? = Bundle.main.path(forResource: "checkmark", ofType: "mp4")
        guard let unwrappedVideoPath = videoString else {return}
        
        // convert the path string to a url
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        
        // initialize the video player with the url
        self.player = AVPlayer(url: videoUrl)
        
        // create a video layer for the player
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        
        // make the layer the same size as the container view
        layer.frame = doneCheckVideo!.bounds
        
        // make the video fill the layer as much as possible while keeping its aspect size
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // Added rounded corners
        layer.cornerRadius = 30
        
        // add the layer to the container view
        doneCheckVideo?.layer.addSublayer(layer)
        
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
//            self?.player?.seek(to: CMTime.zero)
//            self?.player?.play()
//            
//        }
        
    }
    
    func close() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
