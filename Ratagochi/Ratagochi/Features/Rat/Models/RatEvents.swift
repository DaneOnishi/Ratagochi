//
//  Events.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 03/08/24.
//

import Foundation

struct RatStateChangedEvent: EventProtocol {
    static var eventType: String { "ratStateChanged" }
    
    var id: UUID
    var newRat: RatModel
    
    init(newRat: RatModel) {
        self.id = UUID()
        self.newRat = newRat
    }
}
