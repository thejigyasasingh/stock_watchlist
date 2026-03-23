import 'models.dart';


class WatchlistRepository {
  List<Stock>? _cachedStocks;

  List<Stock> _getSampleStocks() {
    return [
      const Stock(
        id: '1',
        symbol: 'AAPL',
        companyName: 'Apple Inc.',
        currentPrice: 178.50,
        changeAmount: 2.35,
        changePercentage: 1.33,
        position: 0,
      ),
      const Stock(
        id: '2',
        symbol: 'GOOGL',
        companyName: 'Alphabet Inc.',
        currentPrice: 142.80,
        changeAmount: -1.20,
        changePercentage: -0.83,
        position: 1,
      ),
      const Stock(
        id: '3',
        symbol: 'MSFT',
        companyName: 'Microsoft Corporation',
        currentPrice: 412.30,
        changeAmount: 5.60,
        changePercentage: 1.38,
        position: 2,
      ),
      const Stock(
        id: '4',
        symbol: 'AMZN',
        companyName: 'Amazon.com Inc.',
        currentPrice: 178.25,
        changeAmount: 3.45,
        changePercentage: 1.97,
        position: 3,
      ),
      const Stock(
        id: '5',
        symbol: 'TSLA',
        companyName: 'Tesla Inc.',
        currentPrice: 242.84,
        changeAmount: -4.16,
        changePercentage: -1.68,
        position: 4,
      ),
      const Stock(
        id: '6',
        symbol: 'NVDA',
        companyName: 'NVIDIA Corporation',
        currentPrice: 875.28,
        changeAmount: 12.50,
        changePercentage: 1.45,
        position: 5,
      ),
      const Stock(
        id: '7',
        symbol: 'META',
        companyName: 'Meta Platforms Inc.',
        currentPrice: 485.60,
        changeAmount: -2.30,
        changePercentage: -0.47,
        position: 6,
      ),
      const Stock(
        id: '8',
        symbol: 'NFLX',
        companyName: 'Netflix Inc.',
        currentPrice: 598.75,
        changeAmount: 8.90,
        changePercentage: 1.51,
        position: 7,
      ),
      const Stock(
        id: '9',
        symbol: 'AMD',
        companyName: 'Advanced Micro Devices Inc.',
        currentPrice: 165.42,
        changeAmount: -3.28,
        changePercentage: -1.94,
        position: 8,
      ),
      const Stock(
        id: '10',
        symbol: 'INTC',
        companyName: 'Intel Corporation',
        currentPrice: 42.18,
        changeAmount: 0.67,
        changePercentage: 1.61,
        position: 9,
      ),
    ];
  }


  Future<List<Stock>> fetchWatchlist() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // refresh data
    _cachedStocks ??= _getSampleStocks();
    return List.from(_cachedStocks!);
  }


  Future<bool> saveWatchlistOrder(List<Stock> stocks) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      _cachedStocks = List.from(stocks);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove stock from watchlist
  Future<bool> removeStock(String stockId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));

      _cachedStocks?.removeWhere((stock) => stock.id == stockId);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Add stock to watchlist
  Future<Stock?> addStock(String symbol, String companyName) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final newStock = Stock(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        symbol: symbol.toUpperCase(),
        companyName: companyName,
        currentPrice: 0.0,
        changeAmount: 0.0,
        changePercentage: 0.0,
        position: _cachedStocks?.length ?? 0,
      );

      _cachedStocks?.add(newStock);

      return newStock;
    } catch (e) {
      return null;
    }
  }

  /// Clear cache (useful for refresh)
  void clearCache() {
    _cachedStocks = null;
  }
}