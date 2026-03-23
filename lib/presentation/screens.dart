import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_watchlist/presentation/widgets.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../core/theme.dart';
import 'empty_widgets.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<WatchlistBloc, WatchlistState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return _buildLoadingState();
          }

          if (state is WatchlistError) {
            return _buildErrorState(context, state);
          }

          if (state is WatchlistLoaded) {
            if (state.stocks.isEmpty) {
              return const EmptyWatchlist();
            }
            return _buildLoadedState(context, state);
          }

          return _buildInitialState();
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Watchlist'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Refresh',
          onPressed: () {
            context.read<WatchlistBloc>().add(const RefreshWatchlist());
          },
        ),
        // More options menu
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (value) => _handleMenuSelection(context, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'sort_alpha',
              child: Row(
                children: [
                  Icon(Icons.sort_by_alpha_rounded),
                  SizedBox(width: 12),
                  Text('Sort A-Z'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'sort_price',
              child: Row(
                children: [
                  Icon(Icons.attach_money_rounded),
                  SizedBox(width: 12),
                  Text('Sort by Price'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'sort_change',
              child: Row(
                children: [
                  Icon(Icons.trending_up_rounded),
                  SizedBox(width: 12),
                  Text('Sort by Change'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$value - Coming soon!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Loading watchlist...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WatchlistError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.negativeColor.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppTheme.negativeColor,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              state.message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<WatchlistBloc>().add(const LoadWatchlist());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, WatchlistLoaded state) {
    return Column(
      children: [
        // Summary header
        _buildSummaryHeader(context, state),

        // Instruction hint (optional - remove after first use)
        if (state.stocks.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.accentColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Long press and drag to reorder • Swipe left to delete',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Stock list with improved drag feedback
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: state.stocks.length,
            buildDefaultDragHandles: true, // Enable default drag handles
            onReorder: (oldIndex, newIndex) {
              print('📍 Reordering: $oldIndex → $newIndex'); // Debug log

              context.read<WatchlistBloc>().add(
                ReorderStocks(
                  oldIndex: oldIndex,
                  newIndex: newIndex,
                ),
              );
            },
            proxyDecorator: _proxyDecorator,
            itemBuilder: (context, index) {
              final stock = state.stocks[index];
              return StockCard(
                key: ValueKey(stock.id), // CRITICAL: Must have unique key
                stock: stock,
                isDragging: state.isReordering,
                onDismissed: () {
                  _removeStock(context, stock.id, stock.symbol);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryHeader(BuildContext context, WatchlistLoaded state) {
    // FIXED: Remove the '?' - stock is never null in the list
    final gainers = state.stocks.where((s) => s.isPositive).length;
    final losers = state.stocks.length - gainers;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.2),
            AppTheme.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(
            context,
            'Total',
            state.stocks.length.toString(),
            Icons.show_chart_rounded,
            AppTheme.primaryColor,
          ),
          _buildDivider(),
          _buildStat(
            context,
            'Gainers',
            gainers.toString(),
            Icons.trending_up_rounded,
            AppTheme.positiveColor,
          ),
          _buildDivider(),
          _buildStat(
            context,
            'Losers',
            losers.toString(),
            Icons.trending_down_rounded,
            AppTheme.negativeColor,
          ),
        ],
      ),
    );
  }
  Widget _buildStat(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color,
      ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// Build vertical divider
  Widget _buildDivider() {
    return Container(
      height: 60,
      width: 1,
      color: Colors.grey[700],
    );
  }

  /// Build initial state
  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.candlestick_chart_rounded,
            size: 100,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to Watchlist',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  /// Custom proxy decorator for dragging animation
  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Build floating action button
  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddStockDialog(context),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Add Stock'),
      elevation: 6,
    );
  }

  /// Show dialog to add new stock
  void _showAddStockDialog(BuildContext context) {
    final symbolController = TextEditingController();
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Stock'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: symbolController,
                decoration: const InputDecoration(
                  labelText: 'Stock Symbol',
                  hintText: 'e.g., AAPL',
                  prefixIcon: Icon(Icons.business_rounded),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a stock symbol';
                  }
                  if (value.length > 5) {
                    return 'Symbol too long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  hintText: 'e.g., Apple Inc.',
                  prefixIcon: Icon(Icons.apartment_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<WatchlistBloc>().add(
                  AddStock(
                    symbol: symbolController.text.toUpperCase(),
                    companyName: nameController.text,
                  ),
                );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  /// Handle stock removal with confirmation
  void _removeStock(BuildContext context, String stockId, String symbol) {
    context.read<WatchlistBloc>().add(RemoveStock(stockId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Text('$symbol removed from watchlist'),
          ],
        ),
        backgroundColor: AppTheme.surfaceColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppTheme.primaryColor,
          onPressed: () {
            // In production, implement undo functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Undo feature - Coming soon!'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Handle state changes and show messages
  void _handleStateChanges(BuildContext context, WatchlistState state) {
    if (state is WatchlistLoaded && state.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 12),
              Text(state.successMessage!),
            ],
          ),
          backgroundColor: AppTheme.positiveColor.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}