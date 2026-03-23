import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models.dart';
import '../data/repositories.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository repository;

  WatchlistBloc({required this.repository}) : super(const WatchlistInitial()) {
    on<LoadWatchlist>(_onLoadWatchlist);
    on<ReorderStocks>(_onReorderStocks);
    on<RemoveStock>(_onRemoveStock);
    on<AddStock>(_onAddStock);
    on<RefreshWatchlist>(_onRefreshWatchlist);
  }

  Future<void> _onLoadWatchlist(
      LoadWatchlist event,
      Emitter<WatchlistState> emit,
      ) async {
    emit(const WatchlistLoading());

    try {
      final stocks = await repository.fetchWatchlist();
      emit(WatchlistLoaded(stocks: stocks));
    } catch (e) {
      emit(WatchlistError('Failed to load watchlist: ${e.toString()}'));
    }
  }

  Future<void> _onReorderStocks(
      ReorderStocks event,
      Emitter<WatchlistState> emit,
      ) async {
    if (state is! WatchlistLoaded) return;

    final currentState = state as WatchlistLoaded;
    final stocks = List<Stock>.from(currentState.stocks);

    emit(currentState.copyWith(isReordering: true));

    try {
      final oldIndex = event.oldIndex;
      final newIndex = event.newIndex;

      if (oldIndex < newIndex) {
        final stock = stocks.removeAt(oldIndex);
        stocks.insert(newIndex - 1, stock);
      } else {
        final stock = stocks.removeAt(oldIndex);
        stocks.insert(newIndex, stock);
      }

      final updatedStocks = stocks
          .asMap()
          .entries
          .map((entry) => entry.value.copyWith(position: entry.key))
          .toList();

      final success = await repository.saveWatchlistOrder(updatedStocks);

      if (success) {
        emit(WatchlistLoaded(
          stocks: updatedStocks,
          isReordering: false,
        ));
      } else {
        throw Exception('Failed to save order');
      }
    } catch (e) {
      emit(WatchlistError(
        'Failed to reorder stocks: ${e.toString()}',
        previousStocks: currentState.stocks,
      ));

      await Future.delayed(const Duration(seconds: 2));
      emit(currentState.copyWith(isReordering: false));
    }
  }

  Future<void> _onRemoveStock(
      RemoveStock event,
      Emitter<WatchlistState> emit,
      ) async {
    if (state is! WatchlistLoaded) return;

    final currentState = state as WatchlistLoaded;
    final stocks = List<Stock>.from(currentState.stocks);

    final removedStock = stocks.firstWhere((stock) => stock.id == event.stockId);
    stocks.removeWhere((stock) => stock.id == event.stockId);

    final updatedStocks = stocks
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(position: entry.key))
        .toList();

    emit(WatchlistLoaded(
      stocks: updatedStocks,
      successMessage: '${removedStock.symbol} removed',
    ));

    try {
      await repository.removeStock(event.stockId);
    } catch (e) {
      emit(WatchlistError(
        'Failed to remove stock',
        previousStocks: currentState.stocks,
      ));
    }
  }

  Future<void> _onAddStock(
      AddStock event,
      Emitter<WatchlistState> emit,
      ) async {
    if (state is! WatchlistLoaded) return;

    final currentState = state as WatchlistLoaded;

    try {
      final newStock = await repository.addStock(
        event.symbol,
        event.companyName,
      );

      if (newStock != null) {
        final updatedStocks = List<Stock>.from(currentState.stocks)..add(newStock);

        emit(WatchlistLoaded(
          stocks: updatedStocks,
          successMessage: '${event.symbol} added to watchlist',
        ));
      } else {
        throw Exception('Failed to create stock');
      }
    } catch (e) {
      emit(WatchlistError(
        'Failed to add stock: ${e.toString()}',
        previousStocks: currentState.stocks,
      ));

      await Future.delayed(const Duration(seconds: 2));
      emit(currentState);
    }
  }

  Future<void> _onRefreshWatchlist(
      RefreshWatchlist event,
      Emitter<WatchlistState> emit,
      ) async {
    if (state is! WatchlistLoaded) {
      add(const LoadWatchlist());
      return;
    }

    final currentState = state as WatchlistLoaded;

    try {
      repository.clearCache();
      final stocks = await repository.fetchWatchlist();

      emit(WatchlistLoaded(
        stocks: stocks,
        successMessage: 'Watchlist refreshed',
      ));
    } catch (e) {
      emit(WatchlistError(
        'Failed to refresh watchlist',
        previousStocks: currentState.stocks,
      ));

      await Future.delayed(const Duration(seconds: 2));
      emit(currentState);
    }
  }
}