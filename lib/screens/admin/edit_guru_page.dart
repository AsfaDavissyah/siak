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

  Widget buildInput({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 1.3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Data Guru"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Text(
              "Perbarui informasi guru dengan benar.",
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            buildInput(label: "NIP", controller: nipC),
            const SizedBox(height: 16),

            buildInput(label: "Nama Guru", controller: namaC),
            const SizedBox(height: 16),

            buildInput(label: "Mata Pelajaran", controller: mapelC),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await guruService.updateGuru(widget.id, {
                    "nip": nipC.text,
                    "nama": namaC.text,
                    "mapel": mapelC.text,
                  });

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Update Data",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
