import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'add_income_page.dart';
import 'add_expense_page.dart';
import 'cash_flow_page.dart';
import 'settings_page.dart';
import '../database/database_helper.dart';
import '../models/transaction.dart';

class HomePage extends StatelessWidget {
  Future<List<Transaction>> _getTransactions() async {
    // Retrieve all transactions from the database
    return await DatabaseHelper.instance.readAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beranda')),
      body: FutureBuilder<List<Transaction>>(
        future: _getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<Transaction> transactions = snapshot.data!;
            Map<DateTime, double> incomeData = {};
            Map<DateTime, double> expenseData = {};

            for (var transaction in transactions) {
              DateTime date = DateTime(transaction.date.year,
                  transaction.date.month, transaction.date.day);
              if (transaction.type == 'income') {
                incomeData[date] = (incomeData[date] ?? 0) + transaction.amount;
              } else if (transaction.type == 'expense') {
                expenseData[date] =
                    (expenseData[date] ?? 0) + transaction.amount;
              }
            }

            // Convert maps to lists of FlSpot for the chart
            List<FlSpot> incomeSpots = incomeData.entries
                .map((e) =>
                    FlSpot(e.key.millisecondsSinceEpoch.toDouble(), e.value))
                .toList();
            List<FlSpot> expenseSpots = expenseData.entries
                .map((e) =>
                    FlSpot(e.key.millisecondsSinceEpoch.toDouble(), e.value))
                .toList();

            double totalIncome =
                incomeData.values.fold(0, (sum, item) => sum + item);
            double totalExpense =
                expenseData.values.fold(0, (sum, item) => sum + item);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Total Pemasukan: Rp ${totalIncome.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18.0)),
                  Text(
                      'Total Pengeluaran: Rp ${totalExpense.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18.0)),
                  SizedBox(height: 20),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: incomeSpots,
                            isCurved: true,
                            color: Colors.green, // Single color
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                          LineChartBarData(
                            spots: expenseSpots,
                            isCurved: true,
                            color: Colors.red, // Single color
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true),
                        lineTouchData: LineTouchData(enabled: true),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddIncomePage()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              Text('Tambah Pemasukan')
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddExpensePage()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.remove),
                              Text('Tambah Pengeluaran')
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CashFlowPage()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.list),
                              Text('Detail Cash Flow')
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsPage()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.settings),
                              Text('Pengaturan')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
