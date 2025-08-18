import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../utils/constants.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = AppConstants.transactionsCollection;

  // Add a new transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _firestore.collection(_collection).doc(transaction.id).set(transaction.toMap());
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  // Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _firestore.collection(_collection).doc(transaction.id).update(transaction.toMap());
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection(_collection).doc(transactionId).delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  // Get all transactions for a user
  Stream<List<TransactionModel>> getUserTransactions(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList());
  }

  // Get recent transactions (last 3)
  Stream<List<TransactionModel>> getRecentTransactions(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList());
  }

  // Get transactions by date range
  Stream<List<TransactionModel>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch)
        .where('date', isLessThanOrEqualTo: endDate.millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList());
  }

  // Get transactions by type
  Stream<List<TransactionModel>> getTransactionsByType(
    String userId,
    TransactionType type,
  ) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: type.toString().split('.').last)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList());
  }

  // Get transactions by category
  Stream<List<TransactionModel>> getTransactionsByCategory(
    String userId,
    TransactionCategory category,
  ) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category.toString().split('.').last)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList());
  }

  // Get monthly transactions
  Stream<List<TransactionModel>> getMonthlyTransactions(
    String userId,
    int year,
    int month,
  ) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);
    
    return getTransactionsByDateRange(userId, startDate, endDate);
  }

  // Calculate total income for a period
  Future<double> getTotalIncome(String userId, DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'income')
          .where('date', isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch)
          .where('date', isLessThanOrEqualTo: endDate.millisecondsSinceEpoch)
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data() as Map<String, dynamic>)['amount'] ?? 0;
      }
      return total;
    } catch (e) {
      throw Exception('Failed to calculate total income: $e');
    }
  }

  // Calculate total expenses for a period
  Future<double> getTotalExpenses(String userId, DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'expense')
          .where('date', isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch)
          .where('date', isLessThanOrEqualTo: endDate.millisecondsSinceEpoch)
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data() as Map<String, dynamic>)['amount'] ?? 0;
      }
      return total;
    } catch (e) {
      throw Exception('Failed to calculate total expenses: $e');
    }
  }

  // Get spending by category
  Future<Map<TransactionCategory, double>> getSpendingByCategory(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'expense')
          .where('date', isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch)
          .where('date', isLessThanOrEqualTo: endDate.millisecondsSinceEpoch)
          .get();

      Map<TransactionCategory, double> categorySpending = {};
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final categoryString = data['category'] as String;
        final amount = (data['amount'] ?? 0.0) as double;
        
        final category = TransactionCategory.values.firstWhere(
          (e) => e.toString().split('.').last == categoryString,
          orElse: () => TransactionCategory.other_expense,
        );
        
        categorySpending[category] = (categorySpending[category] ?? 0) + amount;
      }
      
      return categorySpending;
    } catch (e) {
      throw Exception('Failed to get spending by category: $e');
    }
  }
}
