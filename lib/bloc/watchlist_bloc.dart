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

  /// Handle loading watchlist
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

  /// Handle stock reordering
  Future<void> _onReorderStocks(
      ReorderStocks event,
      Emitter<WatchlistState> emit,
      ) async {
    // Only proceed if current state is loaded
    if (state is! WatchlistLoaded) return;

    final currentState = state as WatchlistLoaded;
    final stocks = List<Stock>.from(currentState.stocks);

    // Show reordering state for visual feedback
    emit(currentState.copyWith(isReordering: true));

    try {
      // Perform the reorder operation
      final oldIndex = event.oldIndex;
      final newIndex = event.newIndex;

      // Handle the drag and drop logic
      if (oldIndex < newIndex) {
        // Moving item down the list
        final stock = stocks.removeAt(oldIndex);
        stocks.insert(newIndex - 1, stock);
      } else {
        // Moving item up the list
        final stock = stocks.removeAt(oldIndex);
        stocks.insert(newIndex, stock);
      }

      // Update positions for all stocks
      final updatedStocks = stocks
          .asMap()
          .entries
          .map((entry) => entry.value.copyWith(position: entry.key))
          .toList();

      // Save the new order to repository
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
      // Revert to previous state on error
      emit(WatchlistError(
        'Failed to reorder stocks: ${e.toString()}',
        previousStocks: currentState.stocks,
      ));

      // Restore previous state after showing error
      await Future.delayed(const Duration(seconds: 2));
      emit(currentState.copyWith(isReordering: false));
    }
  }

  /// Handle stock removal
  Future<void> _onRemoveStock(
      RemoveStock event,
      Emitter<WatchlistState> emit,
      ) async {
    if (state is! WatchlistLoaded) return;

    final currentState = state as WatchlistLoaded;
    final stocks = List<Stock>.from(currentState.stocks);

    // Find and remove the stock
    final removedStock = stocks.firstWhere((stock) => stock.id == event.stockId);
    stocks.removeWhere((stock) => stock.id == event.stockId);

    // Update positions
    final updatedStocks = stocks
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(position: entry.key))
        .toList();

    // Optimistically update UI
    emit(WatchlistLoaded(
      stocks: updatedStocks,
      successMessage: '${removedStock.symbol} removed',
    ));

    // Try to persist changes
    try {
      await repository.removeStock(event.stockId);
    } catch (e) {
      // If removal fails, restore the stock
      emit(WatchlistError(
        'Failed to remove stock',
        previousStocks: currentState.stocks,
      ));
    }
  }

  /// Handle adding new stock
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

      // Restore previous state
      await Future.delayed(const Duration(seconds: 2));
      emit(currentState);
    }
  }

  /// Handle watchlist refresh
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

      // Restore previous state
      await Future.delayed(const Duration(seconds: 2));
      emit(currentState);
    }
  }
}