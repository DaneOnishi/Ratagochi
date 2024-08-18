//
//  RatService.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation
import Combine

@MainActor
class RatRepository: ObservableObject {
    private let databaseService: DatabaseService
    private let eventBus: EventBus
    private var cancellables: Set<AnyCancellable> = []
    
    init(databaseService: DatabaseService = .shared, eventBus: EventBus = .shared) {
        self.databaseService = databaseService
        self.eventBus = eventBus
        
        setupEventSubscription()
    }
    
    private func setupEventSubscription() {
        Logger.debug("Setting up RatRepository Subscription")
        eventBus.events
            .sink { [weak self] event in
                if let requestEvent = event as? RequestAllRatsEvent {
                    self?.handleRequestAllRatsEvent(requestEvent)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleRequestAllRatsEvent(_ event: RequestAllRatsEvent) {
        Logger.debug("Starting to fetch all rats")
        Task {
            do {
                let allRats = try await fetchAllRats()
                Logger.debug("allRats: \(allRats)")
                for rat in allRats {
                    eventBus.publish(RatStateChangedEvent(newRat: rat))
                }
            } catch {
                print("Error fetching initial rats: \(error)")
            }
        }
    }
    
    func saveRat(_ rat: RatModel) {
        do {
            guard !(try databaseService.exists(RatModel.self, withID: rat.id)) else {
                print("Rat with ID \(rat.id) exists already")
                return
            }
            
            try databaseService.save(rat)
            eventBus.publish(RatStateChangedEvent(newRat: rat))
        } catch {
            print("Error saving rat: \(error)")
        }
    }
    
    private func fetchAllRats() async throws -> [RatModel] {
        return try databaseService.fetchAll(RatModel.self)
    }
    
    func fetchRat(withID id: UUID) async throws -> RatModel? {
        return try databaseService.fetch(RatModel.self, withID: id)
    }
    
    func updateRat(id: UUID, update: (inout RatModel) -> Void) {
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
