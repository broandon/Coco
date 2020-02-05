//
//  AccountVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftyUserDefaults

class AccountVC: UIViewController {
  
  @IBOutlet weak var facebookBtn: UIButton!
  @IBOutlet weak var loginBtn: UIButton!
  @IBOutlet weak var registerBtn: UIButton!
  
  var schoolId: String = ""
  var schools: Schools!
  var loader: LoaderVC!
  var user: User!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    loginBtn.roundCorners(15)
    facebookBtn.roundCorners(15)
  }
  
  @IBAction private func facebookLoginAction(_ sender: Any) {
    let loginManager = LoginManager()
    loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
      GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler:
        { (connection, result, error) -> Void in
          guard error == nil,
            let data = result as? Dictionary<String,Any>,
            let fb_id = data["id"] as? String,
            let email = data["email"] as? String,
            let first_name = data["first_name"] as? String,
            let last_name = data["last_name"] as? String else {
              self.throwError(str: "No se pudieron obtener los datos de Facebook")
              return
          }
          self.performFBLogin(email: email, name: first_name, last_name: last_name, fb_id: fb_id)
      })
    }
  }
  
  private func performFBLogin(email: String, name: String, last_name: String, fb_id: String) {
    user = User(name: name, last_name: last_name, email: email, password: fb_id, facebook_login: true)
    requestSchools()
  }
  
  private func registerRequest() {
    showLoader(&loader, view: view)
    user.newUserRequest { result in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
      case .success(_):
        self.performSuccessRegister()
      }
    }
  }
  
  private func requestSchools() {
    schools = Schools()
    showLoader(&loader, view: view)
    schools.getSchoolsRequest { result in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
      case .success(_):
        self.showSchoolPicker()
      }
    }
  }
  
  private func showSchoolPicker() {
    let vc = SchoolModal()
    vc.schools = schools
    vc.delegate = self
    addChild(vc)
    vc.showInView(aView: view, animated: true)
  }
  
  private func performSuccessRegister() {
    guard let id = user.id else { return }
    Defaults[.user] = id
    let vc = instantiate(viewControllerClass: MainController.self)
    let wnd = UIApplication.shared.keyWindow
    var options = UIWindow.TransitionOptions()
    options.direction = .fade
    options.duration = 0.4
    options.style = .easeOut
    wnd?.setRootViewController(vc, options: options)
  }
  
  @IBAction private func loginAction(_ sender: Any) {
    let loginVC = instantiate(viewControllerClass: LoginVC.self)
    present(loginVC, animated: true)
  }
  
  @IBAction private func registerAction(_ sender: Any) {
    let registerVC = instantiate(viewControllerClass: RegisterVC.self)
    present(registerVC, animated: true)
  }
  
  @IBAction func forgotPassword(_ sender: Any) {
    let forgotPasswordVC = instantiate(viewControllerClass: ForgotPasswordVC.self)
    present(forgotPasswordVC, animated: true)
  }
}

extension AccountVC: SchoolModalDelegate {
  func didSelectSchool(index: Int) {
    schoolId = schools.schools[index].id ?? ""
    user.id_school = schoolId
    registerRequest()
  }
}
