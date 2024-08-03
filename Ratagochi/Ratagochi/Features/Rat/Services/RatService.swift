//
//  RatService.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation
import Combine

@MainActor
class RatRepository {
    private let databaseService: DatabaseService
    private let eventBus: EventBus
    
    init(databaseService: DatabaseService = .shared, eventBus: EventBus = .shared) {
        self.databaseService = databaseService
        self.eventBus = eventBus
    }
    
    func saveRat(_ rat: RatModel) {
        do {
            try databaseService.save(rat)
            eventBus.publish(RatStateChangedEvent(newRat: rat))
        } catch {
            print("Error saving rat: \(error)")
        }
    }
    
    func fetchRat(withID id: UUID) -> AnyPublisher<RatModel?, Error> {
        return Future { promise in
            do {
                let rat = try self.databaseService.fetch(RatModel.self, withID: id)
                promise(.success(rat))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateRatState(id: UUID, update: (inout RatModel) -> Void) {
        do {
            guard var rat = try databaseService.fetch(RatModel.self, withID: id) else {
                print("Rat not found")
                return
            }
            
            update(&rat)
            try databaseService.save(rat)
            eventBus.publish(RatStateChangedEvent(newRat: rat))
        } catch {
            print("Error updating rat state: \(error)")
        }
    }
}
