//
//  RegisterVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import DropDown
import M13Checkbox
import SwiftyUserDefaults
import SkyFloatingLabelTextField

class RegisterVC: UIViewController {
  
  @IBOutlet private weak var topBar: UIView!
  @IBOutlet private weak var nameField: SkyFloatingLabelTextField!
  @IBOutlet private weak var lastNameField: SkyFloatingLabelTextField!
  @IBOutlet private weak var phoneField: SkyFloatingLabelTextField!
  @IBOutlet private weak var emailField: SkyFloatingLabelTextField!
  @IBOutlet private weak var passwordField: SkyFloatingLabelTextField!
  @IBOutlet private weak var schoolField: SkyFloatingLabelTextField!
  @IBOutlet private weak var registerBtn: UIButton!
  
  @IBOutlet weak var checkTerms: UIView!
  @IBOutlet weak var buttonTems: UIButton!
  
  let check = M13Checkbox()
  let dropdown = DropDown()
  var schoolId: String?
  var schools: Schools!
  var loader: LoaderVC!
  var user: User!
  let yourAttributes : [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
    NSAttributedString.Key.foregroundColor : UIColor.black,
    NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    requestData()
  }
  
  private func configureView() {
    registerBtn.roundCorners(15)
    schoolField.delegate = self
    checkTerms.addSubview(check)
    check.frame = CGRect(origin: .zero, size: checkTerms.frame.size)
    check.setCheckState(.unchecked, animated: true)
    
    let attributeString = NSMutableAttributedString(string: "Acepto términos y condiciones",
                                                    
                                                    attributes: yourAttributes)
    buttonTems.setAttributedTitle(attributeString,
                                  for: .normal)
  }
  
  private func requestData() {
    schools = Schools()
    showLoader(&loader, view: view)
    schools.getSchoolsRequest { result in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
      case .success(_):
        self.configureDropdown()
      }
    }
  }
  
  private func configureDropdown() {
    var dropdownTitle = [String]()
    for element in schools.schools {
      dropdownTitle.append(element.name ?? "")
    }
    dropdown.anchorView = schoolField
    dropdown.bottomOffset = CGPoint(x: 0, y: schoolField.bounds.height)
    dropdown.direction = .top
    dropdown.dataSource = dropdownTitle
    dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.schoolField.text = item
      self.schoolId = self.schools.schools[index].id ?? ""
      self.dropdown.hide()
    }
  }
  
  @IBAction private func backBtnAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction private func registerBtnAction(_ sender: Any) {
    guard let name = validateField(txtField: nameField),
      let last_name = validateField(txtField: lastNameField),
      let phone = validateField(txtField: phoneField),
      let email = validateField(txtField: emailField),
      let password = validateField(txtField: passwordField),
      let school = schoolId else { return }
    
    if check.checkState != .checked {
      throwError(str: "Para continuar debes aceptar los términos y condiciones")
      return
    }
    view.resignFirstResponder()
    showLoader(&loader, view: view)
    user = User(name: name, last_name: last_name, phone: phone, email: email, password: password, facebook_login: false, id_school: school)
    
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
  
  private func validateField(txtField: SkyFloatingLabelTextField) -> String? {
    guard let text = txtField.text else { return nil }
    if text == "" {
      txtField.errorMessage = txtField.title
      return nil
    }
    txtField.errorMessage = ""
    return text
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
  
  @IBAction func btnTermsAction(_ sender: Any) {
    guard let url = URL(string: "http://easycode.mx/sistema_coco/aviso/terminos.pdf") else {
      return
    }
    UIApplication.shared.open(url)
  }
}

extension RegisterVC: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    dropdown.show()
    return false
  }
}
