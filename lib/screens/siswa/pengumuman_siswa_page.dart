import 'package:flutter/material.dart';

class PengumumanSiswaPage extends StatelessWidget {
  const PengumumanSiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengumuman")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.campaign, size: 70, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "Belum ada pengumuman",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
