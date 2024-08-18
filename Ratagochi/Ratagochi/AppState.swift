//
//  AppState.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published private(set) var rats: [UUID: RatModel] = [:]
    @Published var notifications: [Notification] = []
    
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
    
    private func handleEvent(_ event: any EventProtocol) {
        switch event {
        case let notificationEvent as NotificationEvent:
            handleNotificationEvent(notificationEvent)
        case let ratStateEvent as RatStateChangedEvent:
            handleRatStateChangedEvent(ratStateEvent)
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
        updateRat(event.newRat)
    }
    
    private func handleRequestAllRatsStateEvent(_ event: RequestAllRatsEvent) {

    }
    
    private func updateRat(_ rat: RatModel) {
        Logger.debug("Updating rat: \(rat)")
        rats[rat.id] = rat
    }
    
    func getRat(withID id: UUID) -> RatModel? {
        return rats[id]
    }
    
    func publisherForRat(withID id: UUID) -> AnyPublisher<RatModel?, Never> {
        return $rats.map { $0[id] }.eraseToAnyPublisher()
    }
    
}


struct RequestAllRatsEvent: EventProtocol {
    static var eventType: String { "requestAllRats" }
    var id = UUID()
}
