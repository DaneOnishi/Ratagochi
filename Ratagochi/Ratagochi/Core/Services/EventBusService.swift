//
//  EventBusService.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation
import Combine

public protocol EventProtocol: Identifiable {
    static var eventType: String { get }
    var eventType: String { get }
    var eventId: UUID { get }
    
    var id: UUID { get }
}

extension EventProtocol {
    var eventType: String { Self.eventType }
    var id: UUID { eventId }
}

class EventBus {
    static let shared = EventBus()
    
    private let eventSubject = PassthroughSubject<any EventProtocol, Never>()
    
    var events: AnyPublisher<any EventProtocol, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    func publish(_ event: any EventProtocol) {
        eventSubject.send(event)
    }
}

struct NotificationEvent: EventProtocol {
    static var eventType: String { "notification" }
    
    var eventId: UUID
    var message: String
}
