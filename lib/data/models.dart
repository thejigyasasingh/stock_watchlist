import 'package:equatable/equatable.dart';

/// Represents a stock in the watchlist
/// Uses Equatable for value comparison and immutability
class Stock extends Equatable {
  final String id;
  final String symbol;
  final String companyName;
  final double currentPrice;
  final double changeAmount;
  final double changePercentage;
  final int position;

  const Stock({
    required this.id,
    required this.symbol,
    required this.companyName,
    required this.currentPrice,
    required this.changeAmount,
    required this.changePercentage,
    required this.position,
  });

  /// Helper to check if stock is gaining value
  bool get isPositive => changeAmount >= 0;

  /// Creates a copy of this stock with updated fields
  Stock copyWith({
    String? id,
    String? symbol,
    String? companyName,
    double? currentPrice,
    double? changeAmount,
    double? changePercentage,
    int? position,
  }) {
    return Stock(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      companyName: companyName ?? this.companyName,
      currentPrice: currentPrice ?? this.currentPrice,
      changeAmount: changeAmount ?? this.changeAmount,
      changePercentage: changePercentage ?? this.changePercentage,
      position: position ?? this.position,
    );
  }

  /// Equatable props for value comparison
  @override
  List<Object?> get props => [
    id,
    symbol,
    companyName,
    currentPrice,
    changeAmount,
    changePercentage,
    position,
  ];

  @override
  String toString() => 'Stock(symbol: $symbol, position: $position, price: \$$currentPrice)';

  /// Factory method to create from JSON (for future API integration)
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      companyName: json['companyName'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      changeAmount: (json['changeAmount'] as num).toDouble(),
      changePercentage: (json['changePercentage'] as num).toDouble(),
      position: json['position'] as int,
    );
  }

  /// Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'companyName': companyName,
      'currentPrice': currentPrice,
      'changeAmount': changeAmount,
      'changePercentage': changePercentage,
      'position': position,
    };
  }
}