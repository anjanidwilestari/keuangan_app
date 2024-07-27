import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/transaction.dart';

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  DateTime? _selectedDate;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _saveExpense() async {
    if (_selectedDate != null &&
        _amountController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      final transaction = Transaction(
        type: 'expense',
        amount: int.parse(_amountController.text),
        description: _descriptionController.text,
        date: _selectedDate!,
      );
      await DatabaseHelper.instance.create(transaction);
      Navigator.pop(context);
    } else {
      // Handle case when some fields are not filled
      print("Please complete all fields!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Pengeluaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: Text(_selectedDate == null
                  ? 'Pilih Tanggal'
                  : DateFormat.yMMMd().format(_selectedDate!)),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Nominal'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Keterangan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveExpense, child: Text('Simpan')),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('<< Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
