//
//  Events.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation

struct RatStateChangedEvent: EventProtocol {
    static var eventType: String { "ratStateChanged" }
    
    var eventId: UUID
    var newRat: RatModel
    
    init(newRat: RatModel) {
        self.eventId = UUID()
        self.newRat = newRat
    }
}

struct RatDeletedEvent: EventProtocol {
    static var eventType: String { "RatDeleted" }
    
    var eventId: UUID
    var ratId: UUID
    
    init(ratId: UUID) {
        self.eventId = UUID()
        self.ratId = ratId
    }
}
