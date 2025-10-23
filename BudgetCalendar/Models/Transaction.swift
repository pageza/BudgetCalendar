import Foundation
import SwiftData

@Model
final class Transaction {
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var type: TransactionType
    var notes: String

    init(title: String, amount: Double, date: Date, type: TransactionType, notes: String = "") {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.date = date
        self.type = type
        self.notes = notes
    }

    enum TransactionType: String, Codable, CaseIterable {
        case income = "Income"
        case expense = "Expense"

        var displayName: String {
            rawValue
        }
    }
}
