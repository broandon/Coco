//
//  UIViewControllerExtensions.swift
//  Coco
//
//  Created by Carlos Banos on 6/18/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Alamofire
import SwiftyJSON

extension UIViewController {
  
  func getInstance(controller: String) -> Any{
    return self.storyboard!.instantiateViewController(withIdentifier: controller)
  }
  
  class var storyboardID : String{
    return "\(self)"
  }
  
  func instantiate<T: UIViewController>(viewControllerClass : T.Type,storyBoardID name: String? = nil, storyBoardName: String? = nil) -> T {
    let storyboardID = name != nil ? name! : (viewControllerClass as UIViewController.Type).storyboardID
    if (storyBoardName != nil) {
      let storyboard = UIStoryboard(name: storyBoardName!, bundle: nil)
      return storyboard.instantiateViewController(withIdentifier: storyboardID) as! T
    } else {
      return self.storyboard!.instantiateViewController(withIdentifier: storyboardID) as! T
    }
  }
  
  func addDoneButtonToKeyboard(_ responders: [UIResponder]) {
    let keyboardToolbar = UIToolbar()
    keyboardToolbar.sizeToFit()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                        target: view, action: #selector(UIView.endEditing(_:)))
    keyboardToolbar.items = [flexBarButton, doneBarButton]
    for responder in responders {
      if let textField = responder as? UITextField {
        textField.inputAccessoryView = keyboardToolbar
      } else if let textView = responder as? UITextView {
        textView.inputAccessoryView = keyboardToolbar
      }
    }
  }
  
  func throwError(str: String){
    let errorAlert = UIAlertController()
    errorAlert.title = "Error"
    errorAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
    errorAlert.message = str
    self.present(errorAlert, animated: true, completion: nil)
  }
  
  func getTopSafeAreaHeight() -> CGFloat {
    guard let window = UIApplication.shared.keyWindow else { return 0 }
    return window.safeAreaInsets.top
  }
  
  func showLoader(_ loader: inout LoaderVC?, view: UIView) {
    loader = LoaderVC()
    loader!.showInView(aView: view, animated: true)
  }
  
  func getUserId() -> String? {
    return Defaults[.user]
  }
  
  func saveIdUser(id: String) {
    Defaults[.user] = id
  }
  
  func presentAsync(_ vc: UIViewController) {
    DispatchQueue.main.async {
      self.present(vc, animated: true)
    }
  }
}

