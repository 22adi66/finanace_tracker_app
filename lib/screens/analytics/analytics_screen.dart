import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';
import '../../utils/app_theme.dart';
import '../../utils/helpers.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedChartIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.transactions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No data to display',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Add some transactions to see analytics',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart selector
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedChartIndex = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedChartIndex == 0
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Expenses',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _selectedChartIndex == 0
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedChartIndex = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedChartIndex == 1
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Daily',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _selectedChartIndex == 1
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedChartIndex = 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedChartIndex == 2
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Monthly',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _selectedChartIndex == 2
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedChartIndex = 3),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedChartIndex == 3
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Summary',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _selectedChartIndex == 3
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Chart content
                if (_selectedChartIndex == 0) ...[
                  _buildExpensesPieChart(transactionProvider),
                ] else if (_selectedChartIndex == 1) ...[
                  _buildDailyTrendsChart(transactionProvider),
                ] else if (_selectedChartIndex == 2) ...[
                  _buildMonthlyTrendsChart(transactionProvider),
                ] else ...[
                  _buildSummaryCards(transactionProvider),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpensesPieChart(TransactionProvider provider) {
    final categorySpending = provider.getExpensesByCategory();
    
    if (categorySpending.isEmpty) {
      return Container(
        height: 300,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No expense data available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Add some expense transactions to see the chart',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expenses by Category',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: categorySpending.entries.map((entry) {
                final index = categorySpending.keys.toList().indexOf(entry.key);
                final percentage = (entry.value / categorySpending.values.reduce((a, b) => a + b)) * 100;
                
                return PieChartSectionData(
                  value: entry.value,
                  title: '${percentage.toStringAsFixed(1)}%',
                  color: colors[index % colors.length],
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Legend
        Wrap(
          children: categorySpending.entries.map((entry) {
            final index = categorySpending.keys.toList().indexOf(entry.key);
            return Container(
              margin: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.key.displayName}: ${AppHelpers.formatCurrency(entry.value)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDailyTrendsChart(TransactionProvider provider) {
    final dailyData = provider.getDailyData();
    
    if (dailyData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No daily data available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    double maxY = 0;
    
    int index = 0;
    dailyData.forEach((date, data) {
      double income = data['income'] ?? 0;
      double expense = data['expense'] ?? 0;
      incomeSpots.add(FlSpot(index.toDouble(), income));
      expenseSpots.add(FlSpot(index.toDouble(), expense));
      maxY = math.max(maxY, math.max(income, expense));
      index++;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Trends (Income vs Expenses)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < dailyData.length) {
                        final date = dailyData.keys.elementAt(value.toInt());
                        return Text(
                          '${DateTime.parse(date).day}/${DateTime.parse(date).month}',
                          style: TextStyle(fontSize: 10),
                        );
                      }
                      return Text('');
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(AppHelpers.formatCurrency(value));
                    },
                    reservedSize: 60,
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              minX: 0,
              maxX: (dailyData.length - 1).toDouble(),
              minY: 0,
              maxY: maxY * 1.1,
              lineBarsData: [
                LineChartBarData(
                  spots: incomeSpots,
                  isCurved: true,
                  color: AppTheme.incomeColor,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
                LineChartBarData(
                  spots: expenseSpots,
                  isCurved: true,
                  color: AppTheme.expenseColor,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Income', AppTheme.incomeColor),
            SizedBox(width: 20),
            _buildLegendItem('Expenses', AppTheme.expenseColor),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthlyTrendsChart(TransactionProvider provider) {
    final monthlyData = provider.getMonthlyDetailedData();
    
    if (monthlyData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No monthly data available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    double maxY = 0;
    
    int index = 0;
    monthlyData.forEach((month, data) {
      double income = data['income'] ?? 0;
      double expense = data['expense'] ?? 0;
      incomeSpots.add(FlSpot(index.toDouble(), income));
      expenseSpots.add(FlSpot(index.toDouble(), expense));
      maxY = math.max(maxY, math.max(income, expense));
      index++;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Trends (Income vs Expenses)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < monthlyData.length) {
                        final monthKey = monthlyData.keys.elementAt(value.toInt());
                        return Text(
                          monthKey,
                          style: TextStyle(fontSize: 10),
                        );
                      }
                      return Text('');
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(AppHelpers.formatCurrency(value));
                    },
                    reservedSize: 60,
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              minX: 0,
              maxX: (monthlyData.length - 1).toDouble(),
              minY: 0,
              maxY: maxY * 1.1,
              lineBarsData: [
                LineChartBarData(
                  spots: incomeSpots,
                  isCurved: true,
                  color: AppTheme.incomeColor,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
                LineChartBarData(
                  spots: expenseSpots,
                  isCurved: true,
                  color: AppTheme.expenseColor,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Income', AppTheme.incomeColor),
            SizedBox(width: 20),
            _buildLegendItem('Expenses', AppTheme.expenseColor),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _buildSummaryCards(TransactionProvider provider) {
    final totalIncome = provider.getTotalByType(TransactionType.income);
    final totalExpenses = provider.getTotalByType(TransactionType.expense);
    final balance = totalIncome - totalExpenses;
    final transactionCount = provider.transactions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Financial Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Income',
                AppHelpers.formatCurrency(totalIncome),
                AppTheme.incomeColor,
                Icons.arrow_upward,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Total Expenses',
                AppHelpers.formatCurrency(totalExpenses),
                AppTheme.expenseColor,
                Icons.arrow_downward,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Net Balance',
                AppHelpers.formatCurrency(balance),
                balance >= 0 ? AppTheme.successColor : AppTheme.errorColor,
                balance >= 0 ? Icons.trending_up : Icons.trending_down,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Transactions',
                transactionCount.toString(),
                AppTheme.primaryColor,
                Icons.receipt_long,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Additional insights
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Insights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                if (totalExpenses > 0) ...[
                  _buildInsightRow(
                    'Average Transaction',
                    AppHelpers.formatCurrency(totalExpenses / provider.getTransactionsByType(TransactionType.expense).length),
                  ),
                ],
                
                if (totalIncome > totalExpenses) ...[
                  _buildInsightRow(
                    'Savings Rate',
                    '${((balance / totalIncome) * 100).toStringAsFixed(1)}%',
                  ),
                ] else ...[
                  _buildInsightRow(
                    'Overspending',
                    AppHelpers.formatCurrency(totalExpenses - totalIncome),
                  ),
                ],
                
                _buildInsightRow(
                  'This Month',
                  '${provider.transactions.where((t) => t.date.month == DateTime.now().month).length} transactions',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Icon(icon, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
