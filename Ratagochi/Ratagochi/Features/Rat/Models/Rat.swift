//
//  Rat.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation
import SwiftData

@Model
class RatModel: Codable, Identifiable, PersistableEntity {
    let id: UUID
    var name: String
    
    init(id: UUID = UUID(), name: String = "Unnamed Rat") {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}
