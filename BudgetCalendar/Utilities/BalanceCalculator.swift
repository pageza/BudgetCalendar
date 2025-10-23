import Foundation

struct BalanceCalculator {
    /// Calculate running balance up to and including a specific date
    static func runningBalance(for date: Date, transactions: [Transaction], startingBalance: Double = 0.0) -> Double {
        let calendar = Calendar.current
        let endOfDay = calendar.startOfDay(for: date).addingTimeInterval(86400 - 1) // End of the day

        let filteredTransactions = transactions.filter { transaction in
            transaction.date <= endOfDay
        }

        let total = filteredTransactions.reduce(startingBalance) { balance, transaction in
            switch transaction.type {
            case .income:
                return balance + transaction.amount
            case .expense:
                return balance - transaction.amount
            }
        }

        return total
    }

    /// Get transactions for a specific date
    static func transactions(on date: Date, from transactions: [Transaction]) -> [Transaction] {
        let calendar = Calendar.current
        return transactions.filter { transaction in
            calendar.isDate(transaction.date, inSameDayAs: date)
        }
    }

    /// Calculate total income for a date
    static func totalIncome(on date: Date, from transactions: [Transaction]) -> Double {
        transactions(on: date, from: transactions)
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }

    /// Calculate total expenses for a date
    static func totalExpenses(on date: Date, from transactions: [Transaction]) -> Double {
        transactions(on: date, from: transactions)
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
}
