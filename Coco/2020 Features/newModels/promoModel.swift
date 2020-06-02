// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let promo = try? newJSONDecoder().decode(Promo.self, from: jsonData)

import Foundation

// MARK: - Promo
class Promo: Codable {
    let state, statusMsg: String?
    let data: DataClass?

    enum CodingKeys: String, CodingKey {
        case state
        case statusMsg = "status_msg"
        case data
    }

    init(state: String?, statusMsg: String?, data: DataClass?) {
        self.state = state
        self.statusMsg = statusMsg
        self.data = data
    }
}

// MARK: - DataClass
class DataClass: Codable {
    let info: Info?
    let tiendas: [Tienda]?
    let promocion: Promocion?

    init(info: Info?, tiendas: [Tienda]?, promocion: Promocion?) {
        self.info = info
        self.tiendas = tiendas
        self.promocion = promocion
    }
}

// MARK: - Info
class Info: Codable {
    let nombre, apellidos, notificaciones, saldoActual: String?
    let saldoCocopoints, codigoReferido: String?

    enum CodingKeys: String, CodingKey {
        case nombre, apellidos, notificaciones
        case saldoActual = "saldo_actual"
        case saldoCocopoints = "saldo_cocopoints"
        case codigoReferido = "codigo_referido"
    }

    init(nombre: String?, apellidos: String?, notificaciones: String?, saldoActual: String?, saldoCocopoints: String?, codigoReferido: String?) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.notificaciones = notificaciones
        self.saldoActual = saldoActual
        self.saldoCocopoints = saldoCocopoints
        self.codigoReferido = codigoReferido
    }
}

// MARK: - Promocion
class Promocion: Codable {
    let id, titulo, descripcion: String?
    let imagen: String?
    let link: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case titulo, descripcion, imagen, link
    }

    init(id: String?, titulo: String?, descripcion: String?, imagen: String?, link: String?) {
        self.id = id
        self.titulo = titulo
        self.descripcion = descripcion
        self.imagen = imagen
        self.link = link
    }
}

// MARK: - Tienda
class Tienda: Codable {
    let id, nombre, horario: String?
    let imagen: String?
    let direccion: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case nombre, horario, imagen, direccion
    }

    init(id: String?, nombre: String?, horario: String?, imagen: String?, direccion: String?) {
        self.id = id
        self.nombre = nombre
        self.horario = horario
        self.imagen = imagen
        self.direccion = direccion
    }
}
