//
//  SettingsVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

  @IBOutlet weak var notificationsView: UIView!
  @IBOutlet weak var termsView: UIView!
  @IBOutlet weak var privacyView: UIView!
  @IBOutlet weak var versionView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    notificationsView.addBottomBorder(thickness: 1, color: .CocoBlack)
    termsView.addBottomBorder(thickness: 1, color: .CocoBlack)
    privacyView.addBottomBorder(thickness: 1, color: .CocoBlack)
    versionView.addBottomBorder(thickness: 1, color: .CocoBlack)
  }
  
  @IBAction func facebookBtn(_ sender: Any) {
    guard let url = URL(string: "https://m.facebook.com/Cocoapp-547601782438531/?ref=bookmarks") else {
      return
    }
    UIApplication.shared.open(url)
  }
  
  @IBAction func instagramBtn(_ sender: Any) {
    guard let url = URL(string: "https://www.instagram.com/coco_appha/") else {
      return
    }
    UIApplication.shared.open(url)
  }
  
  @IBAction func privacyButton(_ sender: Any) {
    guard let url = URL(string: "http://easycode.mx/sistema_coco/aviso/politicas.pdf") else {
      return
    }
    UIApplication.shared.open(url)
  }
  
  @IBAction func termsButton(_ sender: Any) {
    guard let url = URL(string: "http://easycode.mx/sistema_coco/aviso/terminos.pdf") else {
      return
    }
    UIApplication.shared.open(url)
  }
  
  @IBAction func backBtn(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
