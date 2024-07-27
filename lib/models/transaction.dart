class Transaction {
  final int? id; // Make id nullable
  final String type; // 'income' or 'expense'
  final int amount;
  final String description;
  final DateTime date;

  Transaction({
    this.id, // Optional id
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }
}
