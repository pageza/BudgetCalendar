import SwiftUI
import SwiftData

struct TransactionListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    var body: some View {
        List {
            if transactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions",
                    systemImage: "list.bullet.rectangle",
                    description: Text("Add your first transaction to get started")
                )
            } else {
                ForEach(groupedTransactions.keys.sorted(by: >), id: \.self) { date in
                    Section(header: Text(formatDate(date))) {
                        ForEach(groupedTransactions[date] ?? []) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                        .onDelete { indexSet in
                            deleteTransactions(at: indexSet, for: date)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var groupedTransactions: [Date: [Transaction]] {
        Dictionary(grouping: transactions) { transaction in
            Calendar.current.startOfDay(for: transaction.date)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func deleteTransactions(at offsets: IndexSet, for date: Date) {
        guard let transactionsForDate = groupedTransactions[date] else { return }

        for index in offsets {
            let transaction = transactionsForDate[index]
            modelContext.delete(transaction)
        }

        do {
            try modelContext.save()
        } catch {
            print("Error deleting transaction: \(error)")
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .fontWeight(.medium)

                if !transaction.notes.isEmpty {
                    Text(transaction.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(formatAmount(transaction.amount, type: transaction.type))
                    .fontWeight(.semibold)
                    .foregroundColor(transaction.type == .income ? .green : .red)

                Text(transaction.type.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .listRowBackground(ColorTheme.transactionColor(for: transaction.type))
    }

    private func formatAmount(_ amount: Double, type: Transaction.TransactionType) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"

        let prefix = type == .income ? "+" : "-"
        let amountString = formatter.string(from: NSNumber(value: amount)) ?? "$0.00"

        return "\(prefix)\(amountString)"
    }
}
