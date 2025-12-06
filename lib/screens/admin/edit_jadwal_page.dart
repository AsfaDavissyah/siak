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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Jadwal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: mapelC, decoration: const InputDecoration(labelText: "Mapel")),
            TextField(controller: kelasC, decoration: const InputDecoration(labelText: "Kelas")),
            TextField(controller: hariC, decoration: const InputDecoration(labelText: "Hari")),
            TextField(controller: jamC, decoration: const InputDecoration(labelText: "Jam")),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                await jadwalService.updateJadwal(widget.id, {
                  "mapel": mapelC.text,
                  "kelas": kelasC.text,
                  "hari": hariC.text,
                  "jam": jamC.text,
                });

                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
