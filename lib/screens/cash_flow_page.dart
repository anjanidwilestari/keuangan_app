import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction.dart';

class CashFlowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Cash Flow')),
      body: FutureBuilder<List<Transaction>>(
        future: DatabaseHelper.instance.readAllTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions found.'));
          }
          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              bool isIncome = transaction.type == 'income';
              return ListTile(
                title: Text(transaction.description),
                subtitle: Text('Rp ${transaction.amount}'),
                trailing: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
