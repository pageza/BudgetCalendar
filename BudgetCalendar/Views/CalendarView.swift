import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query private var transactions: [Transaction]
    @State private var selectedMonth = Date()
    @State private var startingBalance: Double = 0.0

    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        VStack(spacing: 16) {
            // Month selector
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.bordered)

                Spacer()

                Text(monthYearString)
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)

            // Starting balance input
            HStack {
                Text("Starting Balance:")
                    .font(.subheadline)
                TextField("0.00", value: $startingBalance, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 120)
            }
            .padding(.horizontal)

            // Days of week header
            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)

            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        CalendarDayCell(
                            date: date,
                            transactions: transactions,
                            startingBalance: startingBalance
                        )
                    } else {
                        Color.clear
                            .frame(height: 80)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedMonth)
    }

    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }

        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)

        var currentDate = monthInterval.start
        while currentDate < monthInterval.end {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        return days
    }

    private func previousMonth() {
        selectedMonth = calendar.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
    }

    private func nextMonth() {
        selectedMonth = calendar.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
    }
}

struct CalendarDayCell: View {
    let date: Date
    let transactions: [Transaction]
    let startingBalance: Double

    private let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 4) {
            // Day number
            Text("\(calendar.component(.day, from: date))")
                .font(.caption)
                .fontWeight(.semibold)

            // Running balance
            Text(formatCurrency(runningBalance))
                .font(.caption2)
                .fontWeight(.medium)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            // Income/Expense indicators
            HStack(spacing: 2) {
                if dayIncome > 0 {
                    Text("+\(formatCurrency(dayIncome))")
                        .font(.system(size: 8))
                        .foregroundColor(.green)
                        .lineLimit(1)
                }
                if dayExpenses > 0 {
                    Text("-\(formatCurrency(dayExpenses))")
                        .font(.system(size: 8))
                        .foregroundColor(.red)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .padding(4)
        .background(backgroundColor)
        .cornerRadius(8)
    }

    private var runningBalance: Double {
        BalanceCalculator.runningBalance(for: date, transactions: transactions, startingBalance: startingBalance)
    }

    private var dayIncome: Double {
        BalanceCalculator.totalIncome(on: date, from: transactions)
    }

    private var dayExpenses: Double {
        BalanceCalculator.totalExpenses(on: date, from: transactions)
    }

    private var backgroundColor: Color {
        if dayIncome > 0 && dayExpenses > 0 {
            return Color(red: 0.95, green: 0.95, blue: 0.87) // Light yellow for mixed
        } else if dayIncome > 0 {
            return ColorTheme.incomeLight
        } else if dayExpenses > 0 {
            return ColorTheme.expenseLight
        } else {
            return ColorTheme.balanceColor(for: runningBalance)
        }
    }

    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}
