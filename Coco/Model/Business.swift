//
//  Business.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

class Business: Decodable {
  public var id: String?
  public var name: String?
  public var schedule: String?
  public var imgURL: String?
  public var address: String?
  
  public init(id: String = "",
              name: String = "",
              schedule: String = "",
              address: String = "",
              imgURL: String = "") {
    self.id = id
    self.name = name
    self.schedule = schedule
    self.address = address
    self.imgURL = imgURL
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "Id"
    case name = "nombre"
    case schedule = "horario"
    case address = "direccion"
    case imgURL = "imagen"
  }
}
