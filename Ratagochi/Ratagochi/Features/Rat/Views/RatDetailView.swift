//
//  RatDetailView.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 19/08/24.
//

import Foundation
import SwiftUI

struct RatDetailView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ratRepository: RatService
    @State private var showingDeleteConfirmation = false
    @Environment(\.presentationMode) var presentationMode
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        Group {
            if let rat = appState.currentRat {
                VStack {
                    Text(rat.name)
                    Text("Created on: \(rat.creationDate, formatter: itemFormatter)")
                    
                    NavigationLink(value: Route.updateRat) {
                        Text("Update Rat")
                    }
                    
                    Button("Delete Rat") {
                        showingDeleteConfirmation = true
                    }
                    .foregroundColor(.red)
                    .alert(isPresented: $showingDeleteConfirmation) {
                        Alert(
                            title: Text("Delete Rat"),
                            message: Text("Are you sure you want to delete this rat?"),
                            primaryButton: .destructive(Text("Delete")) {
                                ratRepository.delete(rat: rat)
                                presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .navigationTitle(rat.name)
            } else {
                Text("Rat not found")
            }
        }
    }
}
