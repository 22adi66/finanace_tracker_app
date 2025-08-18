enum TransactionType { income, expense }

enum TransactionCategory {
  // Income categories
  salary,
  freelance,
  business,
  investment,
  gift,
  other_income,
  
  // Expense categories
  food,
  transportation,
  entertainment,
  shopping,
  bills,
  healthcare,
  education,
  travel,
  other_expense,
}

extension TransactionCategoryExtension on TransactionCategory {
  String get displayName {
    switch (this) {
      case TransactionCategory.salary:
        return 'Salary';
      case TransactionCategory.freelance:
        return 'Freelance';
      case TransactionCategory.business:
        return 'Business';
      case TransactionCategory.investment:
        return 'Investment';
      case TransactionCategory.gift:
        return 'Gift';
      case TransactionCategory.other_income:
        return 'Other Income';
      case TransactionCategory.food:
        return 'Food & Dining';
      case TransactionCategory.transportation:
        return 'Transportation';
      case TransactionCategory.entertainment:
        return 'Entertainment';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.bills:
        return 'Bills & Utilities';
      case TransactionCategory.healthcare:
        return 'Healthcare';
      case TransactionCategory.education:
        return 'Education';
      case TransactionCategory.travel:
        return 'Travel';
      case TransactionCategory.other_expense:
        return 'Other Expense';
    }
  }

  String get icon {
    switch (this) {
      case TransactionCategory.salary:
        return '💼';
      case TransactionCategory.freelance:
        return '💻';
      case TransactionCategory.business:
        return '🏢';
      case TransactionCategory.investment:
        return '📈';
      case TransactionCategory.gift:
        return '🎁';
      case TransactionCategory.other_income:
        return '💰';
      case TransactionCategory.food:
        return '🍽️';
      case TransactionCategory.transportation:
        return '🚗';
      case TransactionCategory.entertainment:
        return '🎬';
      case TransactionCategory.shopping:
        return '🛍️';
      case TransactionCategory.bills:
        return '💡';
      case TransactionCategory.healthcare:
        return '🏥';
      case TransactionCategory.education:
        return '📚';
      case TransactionCategory.travel:
        return '✈️';
      case TransactionCategory.other_expense:
        return '💸';
    }
  }

  bool get isIncome {
    return [
      TransactionCategory.salary,
      TransactionCategory.freelance,
      TransactionCategory.business,
      TransactionCategory.investment,
      TransactionCategory.gift,
      TransactionCategory.other_income,
    ].contains(this);
  }

  static List<TransactionCategory> get incomeCategories {
    return [
      TransactionCategory.salary,
      TransactionCategory.freelance,
      TransactionCategory.business,
      TransactionCategory.investment,
      TransactionCategory.gift,
      TransactionCategory.other_income,
    ];
  }

  static List<TransactionCategory> get expenseCategories {
    return [
      TransactionCategory.food,
      TransactionCategory.transportation,
      TransactionCategory.entertainment,
      TransactionCategory.shopping,
      TransactionCategory.bills,
      TransactionCategory.healthcare,
      TransactionCategory.education,
      TransactionCategory.travel,
      TransactionCategory.other_expense,
    ];
  }
}

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final String description;
  final DateTime date;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    required this.date,
    required this.createdAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => TransactionType.expense,
      ),
      category: TransactionCategory.values.firstWhere(
        (e) => e.toString().split('.').last == map['category'],
        orElse: () => TransactionCategory.other_expense,
      ),
      description: map['description'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type.toString().split('.').last,
      'category': category.toString().split('.').last,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    String? description,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
