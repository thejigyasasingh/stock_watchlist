import 'package:flutter/material.dart';

class EmptyWatchlist extends StatelessWidget {
  const EmptyWatchlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).cardColor,
              ),
              child: Icon(
                Icons.show_chart_rounded,
                size: 80,
                color: Colors.grey[600],
              ),
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'No Stocks in Watchlist',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.grey[300],
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Add stocks to start tracking their performance',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          OutlinedButton.icon(
            onPressed: () {
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Stock'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
