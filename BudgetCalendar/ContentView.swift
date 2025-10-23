import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showingAddTransaction = false

    var body: some View {
        TabView(selection: $selectedTab) {
            // Calendar Tab
            NavigationStack {
                CalendarView()
                    .navigationTitle("Budget Calendar")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                showingAddTransaction = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                            }
                        }
                    }
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .tag(0)

            // Transactions Tab
            NavigationStack {
                TransactionListView()
                    .navigationTitle("Transactions")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                showingAddTransaction = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                            }
                        }
                    }
            }
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }
            .tag(1)
        }
        .sheet(isPresented: $showingAddTransaction) {
            TransactionFormView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Transaction.self, inMemory: true)
}
