import 'package:flutter/material.dart';
import '../../services/guru_service.dart';

class EditGuruPage extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const EditGuruPage({
    super.key,
    required this.id,
    required this.data,
  });

  @override
  State<EditGuruPage> createState() => _EditGuruPageState();
}

class _EditGuruPageState extends State<EditGuruPage> {
  late TextEditingController nipC;
  late TextEditingController namaC;
  late TextEditingController mapelC;

  final guruService = GuruService();

  @override
  void initState() {
    super.initState();
    nipC = TextEditingController(text: widget.data["nip"]);
    namaC = TextEditingController(text: widget.data["nama"]);
    mapelC = TextEditingController(text: widget.data["mapel"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Data Guru")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nipC, decoration: const InputDecoration(labelText: "NIP")),
            TextField(controller: namaC, decoration: const InputDecoration(labelText: "Nama Guru")),
            TextField(controller: mapelC, decoration: const InputDecoration(labelText: "Mata Pelajaran")),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await guruService.updateGuru(widget.id, {
                  "nip": nipC.text,
                  "nama": namaC.text,
                  "mapel": mapelC.text,
                });

                Navigator.pop(context);
              },
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
