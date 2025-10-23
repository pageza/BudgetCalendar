import SwiftUI
import SwiftData

struct TransactionFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var type: Transaction.TransactionType = .expense
    @State private var notes: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Transaction Details") {
                    TextField("Title", text: $title)
                        .autocapitalization(.words)

                    HStack {
                        Text("$")
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                    }

                    DatePicker("Date", selection: $date, displayedComponents: .date)

                    Picker("Type", selection: $type) {
                        ForEach(Transaction.TransactionType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Notes (Optional)") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTransaction()
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func saveTransaction() {
        // Validation
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a title"
            showError = true
            return
        }

        guard let amountValue = Double(amount), amountValue > 0 else {
            errorMessage = "Please enter a valid amount greater than 0"
            showError = true
            return
        }

        // Create and save transaction
        let transaction = Transaction(
            title: title,
            amount: amountValue,
            date: date,
            type: type,
            notes: notes
        )

        modelContext.insert(transaction)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save transaction: \(error.localizedDescription)"
            showError = true
        }
    }
}
