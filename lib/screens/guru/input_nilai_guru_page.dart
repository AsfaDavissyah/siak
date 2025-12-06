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

  @override
  void initState() {
    super.initState();
    ambilNamaGuru();
  }

  Future<void> ambilNamaGuru() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        guruNamaLogin = data['name']; // SESUAI UserModel kamu
      });
    }
  }

  String? selectedSiswaId;
  String? selectedSiswaNama;
  String? selectedKelas;

  final String guruId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Nilai")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ✅ PILIH SISWA (AMAN DARI NULL)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("siswa")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final siswaList = snapshot.data!.docs;

                return DropdownButtonFormField(
                  hint: const Text("Pilih Siswa"),
                  items: siswaList.map((doc) {
                    final s = doc.data() as Map<String, dynamic>;

                    final nama = s['nama'] ?? "Tanpa Nama";
                    final kelas = s['kelas'] ?? "-";

                    return DropdownMenuItem(
                      value: s['uid'],
                      child: Text("$nama - $kelas"),
                      onTap: () {
                        selectedSiswaNama = nama;
                        selectedKelas = kelas;
                      },
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedSiswaId = value as String);
                  },
                );
              },
            ),

            TextField(
              controller: mapelC,
              decoration: const InputDecoration(labelText: "Mapel"),
            ),
            TextField(
              controller: tugasC,
              decoration: const InputDecoration(labelText: "Nilai Tugas"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: utsC,
              decoration: const InputDecoration(labelText: "Nilai UTS"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: uasC,
              decoration: const InputDecoration(labelText: "Nilai UAS"),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
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
              child: const Text("Simpan Nilai"),
            ),
          ],
        ),
      ),
    );
  }
}
