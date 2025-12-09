import 'package:flutter/material.dart';
import '../../services/siswa_service.dart';

class EditSiswaPage extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const EditSiswaPage({
    super.key,
    required this.id,
    required this.data,
  });

  @override
  State<EditSiswaPage> createState() => _EditSiswaPageState();
}

class _EditSiswaPageState extends State<EditSiswaPage> {
  late TextEditingController nisC;
  late TextEditingController namaC;
  late TextEditingController kelasC;
  late TextEditingController jurusanC;

  final siswaService = SiswaService();

  @override
  void initState() {
    super.initState();
    nisC = TextEditingController(text: widget.data["nis"]);
    namaC = TextEditingController(text: widget.data["nama"]);
    kelasC = TextEditingController(text: widget.data["kelas"]);
    jurusanC = TextEditingController(text: widget.data["jurusan"]);
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
        title: const Text("Edit Data Siswa"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Text(
              "Perbarui data siswa dengan benar.",
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            buildInput(label: "NIS", controller: nisC),
            const SizedBox(height: 16),

            buildInput(label: "Nama", controller: namaC),
            const SizedBox(height: 16),

            buildInput(label: "Kelas", controller: kelasC),
            const SizedBox(height: 16),

            buildInput(label: "Jurusan", controller: jurusanC),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await siswaService.updateSiswa(widget.id, {
                    "nis": nisC.text,
                    "nama": namaC.text,
                    "kelas": kelasC.text,
                    "jurusan": jurusanC.text,
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
                  "Update Data Siswa",
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
