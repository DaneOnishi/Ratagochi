//
//  AppState.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var rat: RatModel
    @Published var notifications: [Notification] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(rat: RatModel = RatModel()) {
        self.rat = rat
        
        // Subscribe to events
        EventBus.shared.events
            .sink { [weak self] event in
                self?.handleEvent(event)
            }
            .store(in: &cancellables)
    }
    
    private func handleEvent(_ event: any EventProtocol) {
        if let notificationEvent = event as? NotificationEvent {
            print("Got NotificationEvent")
            print("Notification: \(notificationEvent.message)")
        } else if let ratStateEvent = event as? RatStateChangedEvent {
            print("Got RatStateChangedEvent")
            print("Rat state changed: rat: \(ratStateEvent.newRat)")
            self.rat = ratStateEvent.newRat
        } else {
            // Handle unknown event types
            print("Unhandled event type: \(type(of: event))")
        }
    }
}
