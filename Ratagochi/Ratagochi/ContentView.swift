//
//  ContentView.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 02/08/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ratRepository: RatRepository
    @State private var newRatName: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Create New Rat")) {
                    HStack {
                        TextField("New Rat Name", text: $newRatName)
                        Button("Add") {
                            ratRepository.saveRat(RatModel(name: newRatName))
                            newRatName = ""
                        }
                        .disabled(newRatName.isEmpty)
                    }
                }
                
                Section(header: Text("Your Rats")) {
                    ForEach(Array(appState.rats.values), id: \.id) { rat in
                        NavigationLink(destination: RatDetailView(ratID: rat.id)) {
                            Text(rat.name)
                        }
                    }
                }
            }
            .navigationTitle("Ratagochi")
        }
    }
}

struct RatDetailView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ratRepository: RatRepository
    let ratID: UUID
    
    var rat: RatModel? {
        appState.getRat(withID: ratID)
    }
    
    var body: some View {
        VStack {
            if let rat = rat {
                Text(rat.name)
                Text("Created on: \(rat.creationDate, formatter: itemFormatter)")
                Button("Feed Rat") {
                    ratRepository.updateRat(id: rat.id) { rat in
                        // Update rat state here, e.g., increase happiness
                    }
                }
            } else {
                Text("Rat not found")
            }
        }
        .navigationTitle(rat?.name ?? "Unknown Rat")
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView()
        .environmentObject(AppState())
        .environmentObject(RatRepository())
}
