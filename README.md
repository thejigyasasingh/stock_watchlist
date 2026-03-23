# 📈 Stock Watchlist - Flutter BLoC App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-00D9FF?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)

**A professional stock watchlist app showcasing clean architecture, BLoC pattern, and modern Flutter best practices**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Architecture](#-architecture)

</div>

---

## 🌟 Overview

A production-ready Flutter application demonstrating enterprise-level mobile development with the BLoC state management pattern. Track stocks, reorder with drag-and-drop, and manage your watchlist with a beautiful, intuitive UI.

## ✨ Features

- 📊 **Stock Management** - View stocks with real-time price changes and percentage indicators
- 🔄 **Drag & Drop Reordering** - Long-press and drag to reorganize your watchlist
- 👆 **Swipe to Delete** - Swipe left to remove stocks with undo option
- ➕ **Quick Add** - Add new stocks with validation
- 🎨 **Modern UI** - Dark theme with Material Design 3
- 🏗️ **Clean Architecture** - BLoC pattern with complete separation of concerns
- ✅ **Type Safe** - Full null safety and Equatable implementation
- 🧪 **Well Tested** - Unit tests included

## 📸 Screenshots

```
┌─────────────────────────────────┐
│  Watchlist              🔄  ⋮   │
├─────────────────────────────────┤
│ Total: 8  Gainers: 5  Losers: 3 │
├─────────────────────────────────┤
│ ☰ 🔵 AAPL      $178.50  +1.33%▲ │
│    Apple Inc.                   │
├─────────────────────────────────┤
│ ☰ 🔴 GOOGL     $142.80  -0.83%▼ │
│    Alphabet Inc.                │
├─────────────────────────────────┤
│ ☰ 🔵 MSFT      $412.30  +1.38%▲ │
│    Microsoft Corp.              │
└─────────────────────────────────┘
```

## 🚀 Installation

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0

### Quick Start

```bash
# Clone or create project
flutter create stock_watchlist
cd stock_watchlist

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3    # State management
  equatable: ^2.0.5       # Value equality
  google_fonts: ^6.1.0    # Typography
```

## 📖 Usage

### Basic Operations

**Reorder Stocks:**
1. Long-press on any stock card
2. Drag up or down to desired position
3. Release to drop

**Delete Stock:**
1. Swipe left on stock card
2. Tap "UNDO" if needed

**Add Stock:**
1. Tap floating "+" button
2. Enter symbol and company name
3. Tap "Add"

**Refresh:**
- Pull down from top or tap refresh icon

## 🏗️ Architecture

Built with **BLoC (Business Logic Component)** pattern following clean architecture principles:

```
lib/
├── core/                    # Theme, constants, utils
├── data/                    # Models, repositories
│   ├── models/
│   └── repositories/
├── business_logic/          # BLoC layer
│   └── bloc/
│       ├── watchlist_bloc.dart
│       ├── watchlist_event.dart
│       └── watchlist_state.dart
└── presentation/            # UI layer
    ├── screens/
    └── widgets/
```

### Data Flow

```
User Action → Event → BLoC → Repository → BLoC → State → UI Update
```

### Key Components

**Events** (User Actions)
- `LoadWatchlist` - Load stocks
- `ReorderStocks` - Drag and drop
- `RemoveStock` - Delete stock
- `AddStock` - Add new stock
- `RefreshWatchlist` - Refresh data

**States** (UI States)
- `WatchlistInitial` - Before loading
- `WatchlistLoading` - Fetching data
- `WatchlistLoaded` - Data ready
- `WatchlistError` - Error occurred

**BLoC** - Processes events, manages business logic, emits states

**Repository** - Handles data operations (currently uses sample data)

## 🔬 Technical Highlights

### Clean Code Practices

✅ **Separation of Concerns** - UI, business logic, and data layers completely separated  
✅ **Type Safety** - Full null safety implementation  
✅ **Immutability** - All models are immutable with Equatable  
✅ **Reusability** - Modular, reusable widgets  
✅ **Testability** - Easy to write unit and widget tests  
✅ **Scalability** - Easy to extend with new features

### State Management

```dart
// Event dispatch
context.read<WatchlistBloc>().add(ReorderStocks(oldIndex: 2, newIndex: 0));

// State listening
BlocBuilder<WatchlistBloc, WatchlistState>(
  builder: (context, state) {
    if (state is WatchlistLoaded) {
      return StockList(stocks: state.stocks);
    }
    return LoadingIndicator();
  },
)
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🎯 Project Goals Achieved

1. ✅ **UI/UX Quality** - Smooth animations, intuitive gestures
2. ✅ **Responsiveness** - 60fps performance, adaptive layouts
3. ✅ **Code Quality** - Clean, documented, maintainable
4. ✅ **Reusability** - Modular components, DRY principles
5. ✅ **Type Safety** - Full null safety, no dynamic types
6. ✅ **BLoC Implementation** - Proper events, states, and bloc
7. ✅ **Project Structure** - Clear organization, layer separation

## 🗺️ Roadmap

- [ ] Real-time API integration
- [ ] Price alerts & notifications
- [ ] Stock search functionality
- [ ] Historical charts
- [ ] Multiple watchlists
- [ ] Cloud sync
- [ ] Light/dark theme toggle

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - Google's UI toolkit
- [BLoC Library](https://bloclibrary.dev/) - State management
- [Material Design 3](https://m3.material.io/) - Design system

---

<div align="center">

**Built with ❤️ using Flutter & BLoC**

⭐ Star this repo if you find it helpful!

</div>