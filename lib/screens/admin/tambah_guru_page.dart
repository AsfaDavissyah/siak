import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/guru_service.dart';

class TambahGuruPage extends StatefulWidget {
  const TambahGuruPage({super.key});

  @override
  State<TambahGuruPage> createState() => _TambahGuruPageState();
}

class _TambahGuruPageState extends State<TambahGuruPage> {
  final TextEditingController nipC = TextEditingController();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController mapelC = TextEditingController();

  String? selectedUid;

  final guruService = GuruService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Guru")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("role", isEqualTo: "guru")
                  .where("linkedId", isEqualTo: "")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final users = snapshot.data!.docs;

                return DropdownButtonFormField(
                  value: selectedUid,
                  hint: const Text("Pilih Akun Guru"),
                  items: users.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(data["username"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedUid = value);
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            TextField(controller: nipC, decoration: const InputDecoration(labelText: "NIP")),
            TextField(controller: namaC, decoration: const InputDecoration(labelText: "Nama Guru")),
            TextField(controller: mapelC, decoration: const InputDecoration(labelText: "Mata Pelajaran")),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                if (selectedUid == null) return;

                await guruService.tambahGuru(
                  uid: selectedUid!,
                  nip: nipC.text,
                  nama: namaC.text,
                  mapel: mapelC.text,
                );

                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
