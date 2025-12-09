import 'package:flutter/material.dart';
import '../../services/jadwal_service.dart';

class EditJadwalPage extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const EditJadwalPage({
    super.key,
    required this.id,
    required this.data,
  });

  @override
  State<EditJadwalPage> createState() => _EditJadwalPageState();
}

class _EditJadwalPageState extends State<EditJadwalPage> {
  late TextEditingController mapelC;
  late TextEditingController kelasC;
  late TextEditingController hariC;
  late TextEditingController jamC;

  final jadwalService = JadwalService();

  @override
  void initState() {
    super.initState();
    mapelC = TextEditingController(text: widget.data["mapel"]);
    kelasC = TextEditingController(text: widget.data["kelas"]);
    hariC = TextEditingController(text: widget.data["hari"]);
    jamC = TextEditingController(text: widget.data["jam"]);
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
        title: const Text("Edit Jadwal"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Text(
              "Perbarui jadwal pelajaran dengan benar.",
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            buildInput(label: "Mata Pelajaran", controller: mapelC),
            const SizedBox(height: 16),

            buildInput(label: "Kelas", controller: kelasC),
            const SizedBox(height: 16),

            buildInput(label: "Hari", controller: hariC),
            const SizedBox(height: 16),

            buildInput(label: "Jam", controller: jamC),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await jadwalService.updateJadwal(widget.id, {
                    "mapel": mapelC.text,
                    "kelas": kelasC.text,
                    "hari": hariC.text,
                    "jam": jamC.text,
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
                  "Update Jadwal",
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
