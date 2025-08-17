import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import '../utils/helpers.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  
  List<TransactionModel> _transactions = [];
  List<TransactionModel> _recentTransactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  double _totalIncome = 0;
  double _totalExpenses = 0;
  Map<TransactionCategory, double> _categorySpending = {};

  List<TransactionModel> get transactions => _transactions;
  List<TransactionModel> get recentTransactions => _recentTransactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;
  double get balance => _totalIncome - _totalExpenses;
  Map<TransactionCategory, double> get categorySpending => _categorySpending;

  void initializeTransactions(String userId) {
    _loadUserTransactions(userId);
    _loadRecentTransactions(userId);
  }

  void _loadUserTransactions(String userId) {
    _transactionService.getUserTransactions(userId).listen(
      (transactions) {
        _transactions = transactions;
        // Automatically recalculate monthly data when transactions change
        _recalculateMonthlyData();
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to load transactions: $error');
      },
    );
  }

  void _loadRecentTransactions(String userId) {
    _transactionService.getRecentTransactions(userId).listen(
      (transactions) {
        _recentTransactions = transactions;
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to load recent transactions: $error');
      },
    );
  }

  void _recalculateMonthlyData() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    _totalIncome = 0;
    _totalExpenses = 0;
    _categorySpending = {};

    for (var transaction in _transactions) {
      final transactionDate = transaction.date;
      
      // Check if transaction is in current month
      if (transactionDate.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          transactionDate.isBefore(endOfMonth.add(const Duration(days: 1)))) {
        
        if (transaction.type == TransactionType.income) {
          _totalIncome += transaction.amount;
        } else {
          _totalExpenses += transaction.amount;
          _categorySpending[transaction.category] = 
              (_categorySpending[transaction.category] ?? 0) + transaction.amount;
        }
      }
    }
  }

  Future<bool> addTransaction({
    required String userId,
    required double amount,
    required TransactionType type,
    required TransactionCategory category,
    required String description,
    required DateTime date,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final transaction = TransactionModel(
        id: AppHelpers.generateId(),
        userId: userId,
        amount: amount,
        type: type,
        category: category,
        description: description,
        date: date,
        createdAt: DateTime.now(),
      );

      await _transactionService.addTransaction(transaction);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateTransaction(TransactionModel transaction) async {
    _setLoading(true);
    _clearError();

    try {
      await _transactionService.updateTransaction(transaction);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteTransaction(String transactionId, String userId) async {
    _setLoading(true);
    _clearError();

    try {
      await _transactionService.deleteTransaction(transactionId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  List<TransactionModel> getTransactionsByType(TransactionType type) {
    return _transactions.where((transaction) => transaction.type == type).toList();
  }

  List<TransactionModel> getTransactionsByCategory(TransactionCategory category) {
    return _transactions.where((transaction) => transaction.category == category).toList();
  }

  List<TransactionModel> getTransactionsByDateRange(DateTime startDate, DateTime endDate) {
    return _transactions.where((transaction) {
      return transaction.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
             transaction.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  double getTotalByType(TransactionType type) {
    return _transactions
        .where((transaction) => transaction.type == type)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double getTotalByCategory(TransactionCategory category) {
    return _transactions
        .where((transaction) => transaction.category == category)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  Map<TransactionCategory, double> getExpensesByCategory() {
    Map<TransactionCategory, double> categoryTotals = {};
    
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        categoryTotals[transaction.category] = 
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }
    }
    
    return categoryTotals;
  }

  Map<String, double> getMonthlyData() {
    Map<String, double> monthlyData = {};
    
    for (var transaction in _transactions) {
      String monthKey = '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
      if (transaction.type == TransactionType.income) {
        monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) + transaction.amount;
      } else {
        monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) - transaction.amount;
      }
    }
    
    return monthlyData;
  }

  Map<String, Map<String, double>> getDailyData() {
    Map<String, Map<String, double>> dailyData = {};
    
    for (var transaction in _transactions) {
      String dateKey = '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}-${transaction.date.day.toString().padLeft(2, '0')}';
      
      if (dailyData[dateKey] == null) {
        dailyData[dateKey] = {'income': 0, 'expense': 0};
      }
      
      if (transaction.type == TransactionType.income) {
        dailyData[dateKey]!['income'] = dailyData[dateKey]!['income']! + transaction.amount;
      } else {
        dailyData[dateKey]!['expense'] = dailyData[dateKey]!['expense']! + transaction.amount;
      }
    }
    
    return dailyData;
  }

  Map<String, Map<String, double>> getMonthlyDetailedData() {
    Map<String, Map<String, double>> monthlyData = {};
    
    for (var transaction in _transactions) {
      String monthKey = '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
      
      if (monthlyData[monthKey] == null) {
        monthlyData[monthKey] = {'income': 0, 'expense': 0};
      }
      
      if (transaction.type == TransactionType.income) {
        monthlyData[monthKey]!['income'] = monthlyData[monthKey]!['income']! + transaction.amount;
      } else {
        monthlyData[monthKey]!['expense'] = monthlyData[monthKey]!['expense']! + transaction.amount;
      }
    }
    
    return monthlyData;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
