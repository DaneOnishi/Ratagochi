//
//  RatFormView.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 19/08/24.
//

import Foundation
import SwiftUI

struct RatFormView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ratRepository: RatService
    @Environment(\.presentationMode) var presentationMode
    @State private var ratName: String = ""
    let isUpdating: Bool
    
    var body: some View {
        Form {
            TextField("Rat Name", text: $ratName)
        }
        .navigationTitle(isUpdating ? "Update Rat" : "Create Rat")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isUpdating ? "Update" : "Create") {
                    if isUpdating, let rat = appState.currentRat {
                        ratRepository.updateRat(withID: rat.id) { updatedRat in
                            updatedRat.name = ratName
                        }
                    } else {
                        ratRepository.save(rat: RatModel(name: ratName))
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(ratName.isEmpty)
            }
        }
        .onAppear {
            if isUpdating, let rat = appState.currentRat {
                ratName = rat.name
            }
        }
    }
}
