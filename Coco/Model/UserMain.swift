//
//  UserMain.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

class UserMain: Decodable {
  public var name: String?
  public var last_name: String?
  public var phone: String?
  public var notifications: String?
  public var current_balance: String?
  
  public init(name: String = "",
              last_name: String = "",
              phone: String = "",
              notifications: String = "",
              current_balance: String = "") {
    self.name = name
    self.last_name = last_name
    self.phone = phone
    self.notifications = notifications
    self.current_balance = current_balance
  }
  
  enum CodingKeys: String, CodingKey {
    case name = "nombre"
    case last_name = "apellidos"
    case phone = "telefono"
    case notifications = "notificaciones"
    case current_balance = "saldo_actual"
  }
}

class Main: Decodable {
  public var info: UserMain?
  public var stores: [Business]
  
  public init(info: UserMain? = nil,
              stores: [Business] = []) {
    self.info = info
    self.stores = stores
  }
  
  enum CodingKeys: String, CodingKey {
    case info = "info"
    case stores = "tiendas"
  }
  
  func requestUserMain(completion: @escaping(Result) -> Void){
    let data = [
      "funcion": Routes.getMainData,
      "id_user": Defaults[.user]!
    ]
    
    Alamofire.request(General.url_connection,
                      method: .post,
                      parameters: data).responseJSON { (response) in
      guard let data = response.result.value else {
        completion(.failure("Error de conexión"))
        return
      }
      
      guard let dictionary = JSON(data).dictionary else {
        completion(.failure("Error al obtener los datos"))
        return
      }
      
      if dictionary["state"] != "200" {
        completion(.failure(dictionary["status_msg"]?.string ?? ""))
        return
      }
      
      guard let dataDictionary = dictionary["data"],
        let object = try? dataDictionary.rawData(),
        let decoded = try? JSONDecoder().decode(Main.self, from: object) else {
          completion(.failure("Error al leer los datos"))
          return
      }
      self.info = decoded.info
      self.stores = decoded.stores
      completion(.success([]))
    }
  }
}
