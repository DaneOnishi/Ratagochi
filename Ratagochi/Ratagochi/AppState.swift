//
//  AppState.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var notifications: [Notification] = []
    
//    MARK: Rat Management
    @Published private(set) var rats: [UUID: RatModel] = [:]
    @Published var currentRat: RatModel?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        Logger.debug("Initializing AppState")
        EventBus.shared.events
            .sink { [weak self] event in
                self?.handleEvent(event)
            }
            .store(in: &cancellables)
    }
    
    func loadInitialState() {
        EventBus.shared.publish(RequestAllRatsEvent())
    }
    
//    MARK: Event Handling
    private func handleEvent(_ event: any EventProtocol) {
        switch event {
        case let notificationEvent as NotificationEvent:
            handleNotificationEvent(notificationEvent)
        case let ratStateEvent as RatStateChangedEvent:
            handleRatStateChangedEvent(ratStateEvent)
        case let ratDeletedEvent as RatDeletedEvent:
            handleRatDeletedEvent(ratDeletedEvent)
        default:
            Logger.debug("Unhandled event type: \(type(of: event))")
        }
    }
    
    private func handleNotificationEvent(_ event: NotificationEvent) {
        Logger.debug("Got NotificationEvent")
        Logger.debug("Notification: \(event.message)")
        // Add the notification to the list if needed
        // notifications.append(Notification(message: event.message))
    }
    
    private func handleRatStateChangedEvent(_ event: RatStateChangedEvent) {
        Logger.debug("Got event: \(event)")
        let rat = event.newRat
        rats[rat.id] = rat
        
        if currentRat?.id == rat.id {
            loadRat(withID: rat.id)
        }
    }
    
    private func handleRatDeletedEvent(_ event: RatDeletedEvent) {
        Logger.debug("Deleting rat: \(event.ratId)")
        rats[event.ratId] = nil
        
        if currentRat?.id == event.ratId {
            clearCurrentRat()
        }
    }

    func loadRat(withID id: UUID) {
        currentRat = rats[id]
    }
    
    func clearCurrentRat() {
        currentRat = nil
    }
    
}


struct RequestAllRatsEvent: EventProtocol {
    static var eventType: String { "requestAllRats" }
    var eventId = UUID()
}
