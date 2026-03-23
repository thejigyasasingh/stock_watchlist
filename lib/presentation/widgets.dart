import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../data/models.dart';

class StockCard extends StatelessWidget {
  final Stock stock;
  final VoidCallback? onDismissed;
  final bool isDragging;

  const StockCard({
    super.key,
    required this.stock,
    this.onDismissed,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(stock.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed?.call(),
      background: _buildDismissBackground(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(isDragging ? 1.05 : 1.0)
          ..rotateZ(isDragging ? -0.02 : 0.0),
        child: Card(
          elevation: isDragging ? 8 : 2,
          child: InkWell(
            onTap: () => _showStockDetails(context),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildDragHandle(),
                  const SizedBox(width: 12),
                  _buildStockIcon(),
                  const SizedBox(width: 16),
                  _buildStockInfo(context),
                  const Spacer(),
                  _buildPriceInfo(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Icon(
      Icons.drag_indicator,
      color: Colors.grey[600],
      size: 24,
    );
  }

  Widget _buildStockIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: stock.isPositive
              ? [
            AppTheme.positiveColor.withOpacity(0.3),
            AppTheme.positiveColor.withOpacity(0.1),
          ]
              : [
            AppTheme.negativeColor.withOpacity(0.3),
            AppTheme.negativeColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Text(
          stock.symbol.substring(0, 1),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: stock.isPositive
                ? AppTheme.positiveColor
                : AppTheme.negativeColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStockInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stock.symbol,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            stock.companyName,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          Formatters.formatPrice(stock.currentPrice),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        _buildChangeIndicator(),
      ],
    );
  }

  Widget _buildChangeIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: stock.isPositive
            ? AppTheme.positiveColor.withOpacity(0.15)
            : AppTheme.negativeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: stock.isPositive
              ? AppTheme.positiveColor.withOpacity(0.3)
              : AppTheme.negativeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            stock.isPositive
                ? Icons.arrow_drop_up_rounded
                : Icons.arrow_drop_down_rounded,
            color: stock.isPositive
                ? AppTheme.positiveColor
                : AppTheme.negativeColor,
            size: 20,
          ),
          Text(
            Formatters.formatPercentage(stock.changePercentage),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: stock.isPositive
                  ? AppTheme.positiveColor
                  : AppTheme.negativeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.negativeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 32,
          ),
          SizedBox(height: 4),
          Text(
            'Remove',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showStockDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stock.symbol),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stock.companyName),
            const SizedBox(height: 16),
            Text('Price: ${Formatters.formatPrice(stock.currentPrice)}'),
            Text('Change: ${Formatters.formatChange(stock.changeAmount)}'),
            Text('Percentage: ${Formatters.formatPercentage(stock.changePercentage)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}