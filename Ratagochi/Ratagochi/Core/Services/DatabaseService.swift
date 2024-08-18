//
//  DatabaseService.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation

protocol PersistableEntity: Codable, Identifiable {
    var id: UUID { get }
}

@MainActor
class DatabaseService {
    static let shared = DatabaseService()
    
    private let fileManager = FileManager.default
    private let documentsDirectory: URL
    
    private init() {
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func fileURL<T: PersistableEntity>(for type: T.Type) -> URL {
        return documentsDirectory.appendingPathComponent("\(String(describing: type)).json")
    }
    
    private func fetch<T: PersistableEntity>(_ type: T.Type) throws -> [UUID: T] {
        let fileURL = fileURL(for: type)
        guard fileManager.fileExists(atPath: fileURL.path) else { return [:] }
        
        let data = try Data(contentsOf: fileURL)
        let entities = try JSONDecoder().decode([T].self, from: data)
        return Dictionary(uniqueKeysWithValues: entities.map { ($0.id, $0) })
    }
    
    func save<T: PersistableEntity>(_ entity: T) throws {
        let fileURL = fileURL(for: T.self)
        var entities = try fetch(T.self)
        entities[entity.id] = entity
        let data = try JSONEncoder().encode(Array(entities.values))
        try data.write(to: fileURL)
    }
    
    func fetch<T: PersistableEntity>(_ type: T.Type, withID id: UUID) throws -> T? {
        let entities = try fetch(type)
        return entities[id]
    }
    
    func fetch<T: PersistableEntity>(_ type: T.Type, withPredicate predicate: @escaping (T) -> Bool) throws -> [T] {
        let entities = try fetch(type)
        return entities.values.filter(predicate)
    }
    
    func fetchAll<T: PersistableEntity>(_ type: T.Type) throws -> [T] {
        let entities = try fetch(type)
        return Array(entities.values)
    }
    
    func exists<T: PersistableEntity>(_ type: T.Type, withID id: UUID) throws -> Bool {
        let entities = try fetch(type)
        return entities[id] != nil
    }
    
    func delete<T: PersistableEntity>(_ type: T.Type, withID id: UUID) throws {
        let fileURL = fileURL(for: T.self)
        var entities = try fetch(type)
        entities.removeValue(forKey: id)
        let data = try JSONEncoder().encode(Array(entities.values))
        try data.write(to: fileURL)
    }
    
    enum DatabaseError: Error {
        case entityNotFound
    }
}
