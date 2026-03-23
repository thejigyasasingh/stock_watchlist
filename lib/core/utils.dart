/// Utility class for formatting stock data
class Formatters {
  /// Format price with dollar sign and 2 decimal places
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Format change amount with sign and 2 decimal places
  static String formatChange(double change) {
    final sign = change >= 0 ? '+' : '';
    return '$sign\$${change.toStringAsFixed(2)}';
  }

  /// Format percentage change with sign and 2 decimal places
  static String formatPercentage(double percentage) {
    final sign = percentage >= 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(2)}%';
  }

  /// Format large numbers with K, M, B suffixes
  static String formatCompactNumber(double number) {
    if (number >= 1000000000) {
      return '\$${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '\$${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '\$${(number / 1000).toStringAsFixed(2)}K';
    }
    return formatPrice(number);
  }
}