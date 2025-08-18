import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/helpers.dart';
import '../utils/app_theme.dart';

class RecentTransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const RecentTransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: transaction.type == TransactionType.income
                ? AppTheme.incomeColor.withOpacity(0.1)
                : AppTheme.expenseColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              transaction.category.icon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.category.displayName,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Text(
              AppHelpers.formatDate(transaction.date),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Text(
          '${transaction.type == TransactionType.income ? '+' : '-'}${AppHelpers.formatCurrency(transaction.amount)}',
          style: TextStyle(
            color: transaction.type == TransactionType.income
                ? AppTheme.incomeColor
                : AppTheme.expenseColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
