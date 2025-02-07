//
//  General.swift
//  Coco
//
//  Created by Carlos Banos on 6/18/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import YPImagePicker
import SwiftyUserDefaults

struct General {
  static var token = Defaults[.token]
  static var username = Defaults[.user]
  
  static let url_connection: String = "https://easycode.mx/sistema_coco/webservice/controller_last.php"
//  static let image_url: String = "https://easycode.mx/trimedicals/app_images/"
  
  static func configurationImagePicker(ratio: Double = 1) -> YPImagePickerConfiguration {
    var config = YPImagePickerConfiguration()
    config.isScrollToChangeModesEnabled = true
    config.onlySquareImagesFromCamera = false
    config.usesFrontCamera = true
    config.showsPhotoFilters = false
    config.shouldSaveNewPicturesToAlbum = false
    config.albumName = "DefaultYPImagePickerAlbumName"
    config.startOnScreen = YPPickerScreen.photo
    config.screens = [.library, .photo]
    config.showsCrop = .rectangle(ratio: ratio)
    config.targetImageSize = YPImageSize.original
    config.overlayView = UIView()
    config.hidesStatusBar = false
    config.hidesBottomBar = false
    config.preferredStatusBarStyle = UIStatusBarStyle.default
    
    return config
  }
}

enum Result {
  case success(JSON?), failure(String)
}

enum ReturnType {
  case data, array
}

enum ReturnErrors: String {
  case GenericServerError = "Ocurrió un error al procesar la solicitud."
}

enum Menu: String {
  case profile = "Mi Perfil"
  case balance = "Recargar Saldo"
  case cocopoints = "Tarjeta Coco"
  case promocode = "Código Promocional - Referido"
  case favorite = "Favoritos"
  case orders = "Pedidos"
  case settings = "Configuración"
  case session = "Cerrar Sesión"
  
  func getImage() -> UIImage {
    switch self {
    case .profile: return #imageLiteral(resourceName: "profile_menu")
    case .balance: return #imageLiteral(resourceName: "credit_menu")
    case .promocode: return UIImage(named: "deal")!
    case .favorite: return #imageLiteral(resourceName: "favorite_menu")
    case .orders: return #imageLiteral(resourceName: "menu_pedidos")
    case .settings: return #imageLiteral(resourceName: "conf_menu")
    case .session: return #imageLiteral(resourceName: "cerrar_menu")
    case .cocopoints: return UIImage(named: "cococard")!
    }
  }
}

extension DefaultsKeys {
  static let user = DefaultsKey<String?>("user")
  static let token = DefaultsKey<String?>("token")
  static let token_saved = DefaultsKey<Bool?>("token_saved")
}

