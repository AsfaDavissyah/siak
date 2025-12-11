import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siak/screens/admin/form_acc_siswa_page.dart';
import '../../services/siswa_service.dart';

class PendingSiswaPage extends StatelessWidget {
  PendingSiswaPage({super.key});

  final siswaService = SiswaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ACC Pendaftaran Siswa")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("role", isEqualTo: "siswa")
            .where("isApproved", isEqualTo: false)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Tidak ada siswa menunggu ACC"));
          }

          final list = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final user = list[index];
              final data = user.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(data["name"], 
                        style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Username: ${data['username']}"),
                      Text("Email: ${data['email']}"),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormAccSiswaPage(
                                uid: user.id,
                                userData: data,
                              ),
                            ),
                          );
                        },
                        child: const Text("Isi data & ACC"),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
