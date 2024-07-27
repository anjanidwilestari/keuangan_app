import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengaturan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Developer: Nama Anda'),
            Text('NIM: 123456789'),
            // Tambahkan logika untuk mengubah password di sini
          ],
        ),
      ),
    );
  }
}
