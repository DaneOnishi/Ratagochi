//
//  ContentView.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 02/08/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ratRepository: RatService
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Section(header: Text("Your Rats")) {
                    ForEach(Array(appState.rats.values), id: \.id) { rat in
                        RatListItemView(rat: rat)
                            .onTapGesture {
                                appState.loadRat(withID: rat.id)
                                navigationPath.append(Route.ratDetail)
                            }
                    }
                }
            }
            .navigationTitle("Ratagochi")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        appState.clearCurrentRat()
                        navigationPath.append(Route.createRat)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .ratDetail:
                    RatDetailView()
                case .createRat, .updateRat:
                    RatCreationView()
                }
            }
        }
    }
}

enum Route: Hashable {
    case ratDetail
    case createRat
    case updateRat
}

struct RatListItemView: View {
    let rat: RatModel
    
    var body: some View {
        Text(rat.name)
    }
}

struct RatDetailView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ratRepository: RatService
    @State private var showingDeleteConfirmation = false
    @Environment(\.presentationMode) var presentationMode
    
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
        .onDisappear {
            appState.clearCurrentRat()
        }
    }
}

struct RatCreationView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var ratRepository: RatService
    @Environment(\.presentationMode) var presentationMode
    @State private var ratName: String = ""
    
    var isUpdating: Bool {
        appState.currentRat != nil
    }
    
    var body: some View {
        Form {
            TextField("Rat Name", text: $ratName)
        }
        .navigationTitle(isUpdating ? "Update Rat" : "Create Rat")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isUpdating ? "Update" : "Create") {
                    if let rat = appState.currentRat {
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
            if let rat = appState.currentRat {
                ratName = rat.name
            }
        }
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
        .environmentObject(RatService())
}
