import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/helpers.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/recent_transaction_card.dart';
import '../transactions/add_transaction_screen.dart';
import '../transactions/transactions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      transactionProvider.initializeTransactions(authProvider.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshData(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final user = authProvider.user;
                  return Row(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AppTheme.primaryColor,
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? Text(
                                user?.displayName.isNotEmpty == true
                                    ? user!.displayName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      
                      // Greeting
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppHelpers.getGreeting(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              user?.displayName ?? 'User',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Refresh Button
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => _refreshData(context),
                        tooltip: 'Refresh',
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              // Dashboard Cards
              Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: DashboardCard(
                          title: 'Income',
                          amount: transactionProvider.totalIncome,
                          color: AppTheme.incomeColor,
                          icon: Icons.arrow_upward,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DashboardCard(
                          title: 'Expenses',
                          amount: transactionProvider.totalExpenses,
                          color: AppTheme.expenseColor,
                          icon: Icons.arrow_downward,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
                  return DashboardCard(
                    title: 'Balance',
                    amount: transactionProvider.balance,
                    color: transactionProvider.balance >= 0 
                        ? AppTheme.successColor 
                        : AppTheme.errorColor,
                    icon: transactionProvider.balance >= 0 
                        ? Icons.trending_up 
                        : Icons.trending_down,
                    isFullWidth: true,
                  );
                },
              ),

              const SizedBox(height: 30),

              // Recent Transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TransactionsScreen(),
                        ),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
                  if (transactionProvider.recentTransactions.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No transactions yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Tap the + button to add your first transaction',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactionProvider.recentTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactionProvider.recentTransactions[index];
                      return RecentTransactionCard(transaction: transaction);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
