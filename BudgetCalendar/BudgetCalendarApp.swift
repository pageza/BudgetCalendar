import SwiftUI
import SwiftData

@main
struct BudgetCalendarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Transaction.self)
    }
}
