import 'package:flutter/material.dart';
import '../../services/guru_service.dart';

class FormAccGuruPage extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> userData;

  const FormAccGuruPage({
    super.key,
    required this.uid,
    required this.userData,
  });

  @override
  State<FormAccGuruPage> createState() => _FormAccGuruPageState();
}

class _FormAccGuruPageState extends State<FormAccGuruPage> {
  final guruService = GuruService();

  final TextEditingController nipC = TextEditingController();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController mapelC = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaC.text = widget.userData["name"]; // langsung pre-fill dari user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ACC Guru")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView(
          children: [
            TextField(
              controller: nipC,
              decoration: const InputDecoration(labelText: "NIP"),
            ),
            TextField(
              controller: namaC,
              decoration: const InputDecoration(labelText: "Nama Guru"),
            ),
            TextField(
              controller: mapelC,
              decoration: const InputDecoration(labelText: "Mata Pelajaran"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await guruService.accGuru(
                  uid: widget.uid,
                  nama: namaC.text,
                  nip: nipC.text,
                  mapel: mapelC.text,
                );

                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("ACC Guru"),
            ),
          ],
        ),
      ),
    );
  }
}
