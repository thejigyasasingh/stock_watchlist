import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlist extends WatchlistEvent {
  const LoadWatchlist();

  @override
  String toString() => 'LoadWatchlist';
}

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

class RemoveStock extends WatchlistEvent {
  final String stockId;

  const RemoveStock(this.stockId);

  @override
  List<Object?> get props => [stockId];

  @override
  String toString() => 'RemoveStock(id: $stockId)';
}

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

class RefreshWatchlist extends WatchlistEvent {
  const RefreshWatchlist();

  @override
  String toString() => 'RefreshWatchlist';
}