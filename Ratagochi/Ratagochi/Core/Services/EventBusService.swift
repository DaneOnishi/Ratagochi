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
    var id: UUID { get }
}

extension EventProtocol {
    var eventType: String { Self.eventType }
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
    
    var id: UUID
    var message: String
}
