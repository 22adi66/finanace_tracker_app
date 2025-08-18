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

class _AnalyticsScreenState extends State<AnalyticsScreen> 
    with TickerProviderStateMixin {
  int _selectedChartIndex = 0;
  int _touchedPieIndex = -1;
  late AnimationController _pieAnimationController;
  late Animation<double> _pieAnimation;

  // Beautiful gradient colors that make the pie chart pop
  static const List<List<Color>> _chartGradientColors = [
    [Color(0xFFFF6B6B), Color(0xFFFF5252)], // Red gradient
    [Color(0xFF4ECDC4), Color(0xFF26A69A)], // Teal gradient
    [Color(0xFF45B7D1), Color(0xFF1976D2)], // Blue gradient
    [Color(0xFFFFA726), Color(0xFFFF7043)], // Orange gradient
    [Color(0xFFAB47BC), Color(0xFF8E24AA)], // Purple gradient
    [Color(0xFF66BB6A), Color(0xFF43A047)], // Green gradient
    [Color(0xFFEC407A), Color(0xFFD81B60)], // Pink gradient
    [Color(0xFF5C6BC0), Color(0xFF3F51B5)], // Indigo gradient
    [Color(0xFFFFCA28), Color(0xFFFFA000)], // Amber gradient
  ];

  @override
  void initState() {
    super.initState();
    // Start the animation when user first sees the pie chart
    _pieAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pieAnimation = CurvedAnimation(
      parent: _pieAnimationController,
      curve: Curves.easeInOutCubic,
    );
    _pieAnimationController.forward();
  }

  @override
  void dispose() {
    _pieAnimationController.dispose();
    super.dispose();
  }

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
    
    // Simple tab-like selector for switching between chart views
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
    
    // Show a friendly message if no expense data exists yet
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

    final totalAmount = categorySpending.values.reduce((a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expenses by Category',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        
        // Quick overview of total spending
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.purple.shade50,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Expenses',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Text(
                AppHelpers.formatCurrency(totalAmount),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Interactive pie chart with smooth animations
        AnimatedBuilder(
          animation: _pieAnimation,
          builder: (context, child) {
            return SizedBox(
              height: 320,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // Handle user tapping on pie sections
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedPieIndex = -1;
                              return;
                            }
                            _touchedPieIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 3,
                      centerSpaceRadius: 50,
                      sections: _generatePieChartSections(categorySpending, totalAmount),
                    ),
                  ),
                  // Center display showing total amount
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppHelpers.formatCurrency(totalAmount),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        const SizedBox(height: 20),
        
        // Detailed breakdown with interactive highlighting
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Category Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              ...categorySpending.entries.map((entry) {
                final index = categorySpending.keys.toList().indexOf(entry.key);
                final percentage = (entry.value / totalAmount) * 100;
                final gradientColors = _chartGradientColors[index % _chartGradientColors.length];
                final isSelected = _touchedPieIndex == index; // Highlight if user touched this section
                
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected 
                        ? Border.all(color: gradientColors[0].withOpacity(0.3))
                        : null,
                    boxShadow: isSelected
                        ? [BoxShadow(
                            color: gradientColors[0].withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )]
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Beautiful gradient color indicator
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: gradientColors,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: gradientColors[0].withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Category name
                      Expanded(
                        child: Text(
                          entry.key.displayName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? gradientColors[0] : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      // Percentage badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: gradientColors[0].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: gradientColors[0],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Amount
                      Text(
                        AppHelpers.formatCurrency(entry.value),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? gradientColors[0] : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generatePieChartSections(
    Map<dynamic, double> categorySpending, 
    double totalAmount
  ) {
    return categorySpending.entries.map((entry) {
      final index = categorySpending.keys.toList().indexOf(entry.key);
      final percentage = (entry.value / totalAmount) * 100;
      final isTouched = index == _touchedPieIndex;
      final gradientColors = _chartGradientColors[index % _chartGradientColors.length];
      
      return PieChartSectionData(
        color: gradientColors[0],
        value: entry.value * _pieAnimation.value, // Smooth entry animation
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: isTouched ? 120.0 : 100.0, // Expand when touched
        titleStyle: TextStyle(
          fontSize: isTouched ? 16 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _getCategoryIcon(entry.key), // Smart category icon
                  color: gradientColors[0],
                  size: 16,
                ),
              )
            : null,
        badgePositionPercentageOffset: isTouched ? 1.3 : 0,
      );
    }).toList();
  }

  IconData _getCategoryIcon(dynamic category) {
    // Choose icons that make sense for each category
    final categoryName = category.toString().toLowerCase();
    if (categoryName.contains('food') || categoryName.contains('restaurant')) {
      return Icons.restaurant;
    } else if (categoryName.contains('transport') || categoryName.contains('car')) {
      return Icons.directions_car;
    } else if (categoryName.contains('entertainment') || categoryName.contains('movie')) {
      return Icons.movie;
    } else if (categoryName.contains('shopping') || categoryName.contains('clothes')) {
      return Icons.shopping_bag;
    } else if (categoryName.contains('health') || categoryName.contains('medical')) {
      return Icons.local_hospital;
    } else if (categoryName.contains('education') || categoryName.contains('book')) {
      return Icons.school;
    } else if (categoryName.contains('bill') || categoryName.contains('utility')) {
      return Icons.receipt;
    }
    return Icons.category; // Fallback for unknown categories
  }

  Widget _buildDailyTrendsChart(TransactionProvider provider) {
    final dailyData = provider.getDailyData();
    
    // Keep it simple - show message if no daily data yet
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
    
    // Simple check for monthly data availability
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