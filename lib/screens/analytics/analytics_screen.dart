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

  // Consolidated chart colors
  static const List<Color> _chartColors = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.transactions.isEmpty) {
            return _buildEmptyState(
              'No data to display',
              'Add some transactions to see analytics',
              Icons.analytics_outlined,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChartSelector(),
                const SizedBox(height: 24),
                _buildSelectedChart(transactionProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChartSelector() {
    final options = ['Expenses', 'Daily', 'Monthly', 'Summary'];
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedChartIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedChartIndex == index
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedChartIndex == index
                        ? Colors.white
                        : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedChart(TransactionProvider provider) {
    switch (_selectedChartIndex) {
      case 0:
        return _buildExpensesPieChart(provider);
      case 1:
        return _buildDailyTrendsChart(provider);
      case 2:
        return _buildMonthlyTrendsChart(provider);
      case 3:
        return _buildSummaryCards(provider);
      default:
        return _buildExpensesPieChart(provider);
    }
  }

  Widget _buildExpensesPieChart(TransactionProvider provider) {
    final categorySpending = provider.getExpensesByCategory();
    
    if (categorySpending.isEmpty) {
      return SizedBox(
        height: 300,
        child: _buildEmptyState(
          'No expense data available',
          'Add some expense transactions to see the chart',
          Icons.pie_chart_outline,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expenses by Category',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  color: _chartColors[index % _chartColors.length],
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
                      color: _chartColors[index % _chartColors.length],
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
      return _buildEmptyState(
        'No daily data available',
        '',
        Icons.trending_up,
      );
    }

    final chartData = _prepareLineChartData(dailyData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Trends (Income vs Expenses)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildLineChart(chartData, dailyData, true),
        const SizedBox(height: 16),
        _buildChartLegend(),
      ],
    );
  }

  Widget _buildMonthlyTrendsChart(TransactionProvider provider) {
    final monthlyData = provider.getMonthlyDetailedData();
    
    if (monthlyData.isEmpty) {
      return _buildEmptyState(
        'No monthly data available',
        '',
        Icons.calendar_month,
      );
    }

    final chartData = _prepareLineChartData(monthlyData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monthly Trends (Income vs Expenses)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildLineChart(chartData, monthlyData, false),
        const SizedBox(height: 16),
        _buildChartLegend(),
      ],
    );
  }

  Map<String, dynamic> _prepareLineChartData(Map<String, Map<String, double>> data) {
    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    double maxY = 0;
    
    int index = 0;
    data.forEach((date, values) {
      double income = values['income'] ?? 0;
      double expense = values['expense'] ?? 0;
      incomeSpots.add(FlSpot(index.toDouble(), income));
      expenseSpots.add(FlSpot(index.toDouble(), expense));
      maxY = math.max(maxY, math.max(income, expense));
      index++;
    });

    return {
      'incomeSpots': incomeSpots,
      'expenseSpots': expenseSpots,
      'maxY': maxY,
      'dataLength': data.length,
    };
  }

  Widget _buildLineChart(Map<String, dynamic> chartData, Map<String, Map<String, double>> rawData, bool isDaily) {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < rawData.length) {
                    final dateKey = rawData.keys.elementAt(value.toInt());
                    if (isDaily) {
                      final date = DateTime.parse(dateKey);
                      return Text(
                        '${date.day}/${date.month}',
                        style: const TextStyle(fontSize: 10),
                      );
                    } else {
                      return Text(
                        dateKey,
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                  }
                  return const Text('');
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
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: (chartData['dataLength'] - 1).toDouble(),
          minY: 0,
          maxY: chartData['maxY'] * 1.1,
          lineBarsData: [
            LineChartBarData(
              spots: chartData['incomeSpots'],
              isCurved: true,
              color: AppTheme.incomeColor,
              barWidth: 3,
              dotData: const FlDotData(show: true),
            ),
            LineChartBarData(
              spots: chartData['expenseSpots'],
              isCurved: true,
              color: AppTheme.expenseColor,
              barWidth: 3,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Income', AppTheme.incomeColor),
        const SizedBox(width: 20),
        _buildLegendItem('Expenses', AppTheme.expenseColor),
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
        const SizedBox(width: 8),
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        
        _buildInsightsCard(provider, totalIncome, totalExpenses, balance),
      ],
    );
  }

  Widget _buildInsightsCard(TransactionProvider provider, double totalIncome, double totalExpenses, double balance) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            if (totalExpenses > 0)
              _buildInsightRow(
                'Avg Expense',
                AppHelpers.formatCurrency(totalExpenses / provider.getTransactionsByType(TransactionType.expense).length),
              ),
            
            if (totalIncome > 0)
              _buildInsightRow(
                'Savings Rate',
                totalIncome > totalExpenses 
                    ? '${((balance / totalIncome) * 100).toStringAsFixed(1)}%'
                    : 'Overspending: ${AppHelpers.formatCurrency(totalExpenses - totalIncome)}',
              ),
            
            _buildInsightRow(
              'This Month',
              '${provider.transactions.where((t) => t.date.month == DateTime.now().month).length} transactions',
            ),
          ],
        ),
      ),
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
                style: const TextStyle(color: Colors.white, fontSize: 14),
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
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}