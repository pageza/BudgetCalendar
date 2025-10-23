# Budget Calendar

A native iOS budgeting app that visualizes your cash flow as a calendar. Track income and expenses, view running balances, and see your financial future at a glance.

## Features

- **Calendar View**: Displays your budget as a monthly calendar with color-coded dates
- **Running Balance**: See your account balance after each day's transactions
- **Transaction Management**: Add, view, and delete income and expense entries
- **Color Coding**: Light-tone colors distinguish income (green), expenses (red), and balance states (blue/amber)
- **Offline First**: All data stored locally on your device using SwiftData
- **No Server Required**: Runs entirely on your iPhone - no backend, no cloud, no subscriptions

## Color Coding System

- **Light Green**: Days with income
- **Light Red/Pink**: Days with expenses
- **Light Yellow**: Days with both income and expenses
- **Light Blue**: Positive balance
- **Light Amber**: Low balance (under $100)
- **Light Orange**: Negative balance

## Requirements

- iOS 17.0 or later (iPhone 15 Pro Max supported)
- Xcode 15.0 or later (for development)
- macOS 13.0 or later (for development)

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/pageza/BudgetCalendar.git
   cd BudgetCalendar
   ```

2. **Open in Xcode**:
   ```bash
   open BudgetCalendar.xcodeproj
   ```

3. **Select your iPhone**:
   - Connect your iPhone 15 Pro Max via cable or WiFi
   - In Xcode, select your device from the device selector (top bar)
   - You may need to trust your Mac on your iPhone

4. **Configure Signing**:
   - Click on the project in Xcode's navigator
   - Select the "BudgetCalendar" target
   - Go to "Signing & Capabilities"
   - Select your Apple ID under "Team"
   - Xcode will automatically create a provisioning profile

5. **Run the App**:
   - Click the Run button (▶️) or press `Cmd + R`
   - The app will build and install on your iPhone
   - First launch may require you to trust the developer certificate on your iPhone:
     - Settings > General > VPN & Device Management > Trust

## Usage

### Adding Transactions

1. Tap the **+** button in the top right
2. Enter transaction details:
   - **Title**: Description (e.g., "Grocery Shopping", "Salary")
   - **Amount**: Dollar amount (without $ symbol)
   - **Date**: When the transaction occurs
   - **Type**: Income or Expense
   - **Notes**: Optional additional details
3. Tap **Save**

### Viewing the Calendar

- **Navigate months**: Use chevron buttons (< >)
- **Set starting balance**: Enter your current account balance at the top
- **Read balance**: Each day shows the running balance after that day's transactions
- **See transactions**: Days with transactions show +/- amounts in small text

### Managing Transactions

- Switch to the **List** tab to see all transactions
- Swipe left on any transaction to delete it
- Transactions are grouped by date

## Technical Details

### Architecture

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Data Persistence**: SwiftData (Apple's modern data framework)
- **Minimum Dependencies**: Only uses Apple's standard frameworks

### Project Structure

```
BudgetCalendar/
├── BudgetCalendarApp.swift      # App entry point
├── ContentView.swift             # Main tab view
├── Models/
│   └── Transaction.swift         # Data model
├── Views/
│   ├── CalendarView.swift        # Calendar display
│   ├── TransactionFormView.swift # Add transaction form
│   └── TransactionListView.swift # Transaction list
└── Utilities/
    ├── BalanceCalculator.swift   # Running balance logic
    └── ColorTheme.swift          # Color definitions
```

### Data Model

Transactions are stored with:
- `id`: Unique identifier
- `title`: Transaction description
- `amount`: Dollar amount
- `date`: Transaction date
- `type`: Income or Expense enum
- `notes`: Optional notes

All data is stored locally in SwiftData's SQLite database on your device.

## Security

- **No Network Access**: App runs entirely offline
- **Local Storage Only**: Data never leaves your device
- **No Third-Party SDKs**: Uses only Apple's frameworks
- **Sandboxed**: iOS security model protects your data
- **No Analytics**: No tracking or telemetry

## Future Enhancements (Optional)

- Recurring transactions
- Budget categories
- Export to CSV
- iCloud sync between devices
- Touch ID / Face ID protection
- Multiple accounts
- Reporting and charts

## License

This project is open source and available under the MIT License.

## Support

For issues or questions, please open an issue on GitHub.

---

Built with Swift and SwiftUI for iPhone