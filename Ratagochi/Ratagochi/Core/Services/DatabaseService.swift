//
//  DatabaseService.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation
import SwiftData

import SwiftData

import Foundation
import SwiftData

protocol PersistableEntity: PersistentModel, Codable {
    var id: UUID { get }
}

@MainActor
class DatabaseService {
    static let shared = DatabaseService()
    
    private init() {}
    
    private var container: ModelContainer?
    
    func configure(with types: [any PersistentModel.Type]) throws {
        let schema = Schema(types)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        container = try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
    
    func save<T: PersistableEntity>(_ entity: T) throws {
        guard let context = container?.mainContext else {
            throw DatabaseError.notConfigured
        }
        context.insert(entity)
        try context.save()
    }
    
    func fetch<T: PersistableEntity>(_ type: T.Type, withID id: UUID) throws -> T? {
        guard let context = container?.mainContext else {
            throw DatabaseError.notConfigured
        }
        let descriptor = FetchDescriptor<T>(predicate: #Predicate { $0.id == id })
        return try context.fetch(descriptor).first
    }
    
    func fetch<T: PersistableEntity>(_ type: T.Type, withPredicate predicate: Predicate<T>) throws -> [T] {
        guard let context = container?.mainContext else {
            throw DatabaseError.notConfigured
        }
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        return try context.fetch(descriptor)
    }
    
    enum DatabaseError: Error {
        case notConfigured
    }
}
