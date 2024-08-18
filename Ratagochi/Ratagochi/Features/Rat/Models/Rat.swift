//
//  Rat.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation


class RatModel: Codable, Identifiable, PersistableEntity {
    let id: UUID
    var name: String
    var creationDate: Date
    
    init(id: UUID = UUID(), name: String = "Unnamed Rat", creationDate: Date = Date()) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, creationDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(creationDate, forKey: .creationDate)
    }
}
