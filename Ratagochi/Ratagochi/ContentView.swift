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
                                navigationPath.append(Route.viewRatDetail)
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
                case .viewRatDetail:
                    RatDetailView()
                case .createRat, .updateRat:
                    RatFormView(isUpdating: route == .updateRat)
                }
            }
        }
    }
}

enum Route: Hashable {
    case viewRatDetail
    case createRat
    case updateRat
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        .environmentObject(RatService())
}
