import 'package:equatable/equatable.dart';
import '../data/models.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();

  @override
  String toString() => 'WatchlistInitial';
}

class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();

  @override
  String toString() => 'WatchlistLoading';
}

class WatchlistLoaded extends WatchlistState {
  final List<Stock> stocks;
  final bool isReordering;
  final String? successMessage;

  const WatchlistLoaded({
    required this.stocks,
    this.isReordering = false,
    this.successMessage,
  });

  WatchlistLoaded copyWith({
    List<Stock>? stocks,
    bool? isReordering,
    String? successMessage,
  }) {
    return WatchlistLoaded(
      stocks: stocks ?? this.stocks,
      isReordering: isReordering ?? this.isReordering,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [stocks, isReordering, successMessage];

  @override
  String toString() => 'WatchlistLoaded(stocks: ${stocks.length}, reordering: $isReordering)';
}

class WatchlistError extends WatchlistState {
  final String message;
  final List<Stock>? previousStocks; // Keep previous data for recovery

  const WatchlistError(this.message, {this.previousStocks});

  @override
  List<Object?> get props => [message, previousStocks];

  @override
  String toString() => 'WatchlistError(message: $message)';
}