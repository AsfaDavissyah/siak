import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/nilai_service.dart';

class InputNilaiGuruPage extends StatefulWidget {
  const InputNilaiGuruPage({super.key});

  @override
  State<InputNilaiGuruPage> createState() => _InputNilaiGuruPageState();
}

class _InputNilaiGuruPageState extends State<InputNilaiGuruPage> {
  final NilaiService nilaiService = NilaiService();

  final TextEditingController mapelC = TextEditingController();
  final TextEditingController tugasC = TextEditingController();
  final TextEditingController utsC = TextEditingController();
  final TextEditingController uasC = TextEditingController();

  String? guruNamaLogin;
  String? selectedSiswaId;
  String? selectedSiswaNama;
  String? selectedKelas;

  final String guruId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    ambilNamaGuru();
  }

  Future<void> ambilNamaGuru() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        guruNamaLogin = data['name'];
      });
    }
  }

  // INPUT FIELD STYLED
  Widget buildInput({
    required String label,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
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
        title: const Text("Input Nilai"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Isi nilai siswa dengan benar.",
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // PILIH SISWA
            // =========================
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("siswa")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final siswaList = snapshot.data!.docs;

                return DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "Pilih Siswa",
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: siswaList.map((doc) {
                    final s = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: s['uid'],
                      child: Text("${s['nama']} - ${s['kelas']}"),
                      onTap: () {
                        selectedSiswaNama = s["nama"];
                        selectedKelas = s["kelas"];
                      },
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedSiswaId = value as String);
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // INPUT MAPEL
            buildInput(label: "Mata Pelajaran", controller: mapelC),
            const SizedBox(height: 16),

            buildInput(
              label: "Nilai Tugas",
              controller: tugasC,
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 16),

            buildInput(
              label: "Nilai UTS",
              controller: utsC,
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 16),

            buildInput(
              label: "Nilai UAS",
              controller: uasC,
              keyboard: TextInputType.number,
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedSiswaId == null ||
                      selectedSiswaNama == null ||
                      selectedKelas == null ||
                      mapelC.text.isEmpty ||
                      tugasC.text.isEmpty ||
                      utsC.text.isEmpty ||
                      uasC.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lengkapi semua data terlebih dahulu"),
                      ),
                    );
                    return;
                  }

                  await nilaiService.tambahNilai(
                    siswaId: selectedSiswaId!,
                    siswaNama: selectedSiswaNama!,
                    kelas: selectedKelas!,
                    mapel: mapelC.text,
                    tugas: int.parse(tugasC.text),
                    uts: int.parse(utsC.text),
                    uas: int.parse(uasC.text),
                    guruId: guruId,
                    guruNama: guruNamaLogin ?? "Guru",
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Simpan Nilai",
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
