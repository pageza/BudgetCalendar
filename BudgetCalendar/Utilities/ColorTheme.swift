import SwiftUI

struct ColorTheme {
    // Light tone colors for income
    static let incomeLight = Color(red: 0.87, green: 0.98, blue: 0.90) // Light green
    static let incomeMedium = Color(red: 0.72, green: 0.94, blue: 0.80) // Medium light green

    // Light tone colors for expenses
    static let expenseLight = Color(red: 1.0, green: 0.89, blue: 0.89) // Light red/pink
    static let expenseMedium = Color(red: 0.99, green: 0.76, blue: 0.76) // Medium light red

    // Light tone colors for balance states
    static let positiveBalance = Color(red: 0.88, green: 0.95, blue: 1.0) // Light blue
    static let neutralBalance = Color(red: 0.96, green: 0.96, blue: 0.96) // Light gray
    static let lowBalance = Color(red: 1.0, green: 0.95, blue: 0.87) // Light amber
    static let negativeBalance = Color(red: 1.0, green: 0.92, blue: 0.84) // Light orange

    // Get balance color based on amount
    static func balanceColor(for amount: Double) -> Color {
        switch amount {
        case ..<0:
            return negativeBalance
        case 0..<100:
            return lowBalance
        case 100..<500:
            return neutralBalance
        default:
            return positiveBalance
        }
    }

    // Get transaction type color
    static func transactionColor(for type: Transaction.TransactionType, emphasized: Bool = false) -> Color {
        switch type {
        case .income:
            return emphasized ? incomeMedium : incomeLight
        case .expense:
            return emphasized ? expenseMedium : expenseLight
        }
    }
}
