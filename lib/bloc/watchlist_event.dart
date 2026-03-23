import 'package:equatable/equatable.dart';

/// Base class for all watchlist events
abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load initial watchlist data
class LoadWatchlist extends WatchlistEvent {
  const LoadWatchlist();

  @override
  String toString() => 'LoadWatchlist';
}

/// Event to reorder stocks in the watchlist
class ReorderStocks extends WatchlistEvent {
  final int oldIndex;
  final int newIndex;

  const ReorderStocks({
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [oldIndex, newIndex];

  @override
  String toString() => 'ReorderStocks(from: $oldIndex, to: $newIndex)';
}

/// Event to remove a stock from watchlist
class RemoveStock extends WatchlistEvent {
  final String stockId;

  const RemoveStock(this.stockId);

  @override
  List<Object?> get props => [stockId];

  @override
  String toString() => 'RemoveStock(id: $stockId)';
}

/// Event to add a new stock to watchlist
class AddStock extends WatchlistEvent {
  final String symbol;
  final String companyName;

  const AddStock({
    required this.symbol,
    required this.companyName,
  });

  @override
  List<Object?> get props => [symbol, companyName];

  @override
  String toString() => 'AddStock(symbol: $symbol)';
}

/// Event to refresh watchlist data
class RefreshWatchlist extends WatchlistEvent {
  const RefreshWatchlist();

  @override
  String toString() => 'RefreshWatchlist';
}