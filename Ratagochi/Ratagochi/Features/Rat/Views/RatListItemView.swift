//
//  RatListItemView.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 19/08/24.
//

import Foundation
import SwiftUI


struct RatListItemView: View {
    let rat: RatModel
    
    var body: some View {
        Text(rat.name)
    }
}
