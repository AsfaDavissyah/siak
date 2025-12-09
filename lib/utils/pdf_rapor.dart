import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class RaporPdfGenerator {
  static Future<Uint8List> generateRapor({
    required String namaSiswa,
    required String kelas,
    required List<Map<String, dynamic>> nilaiList,
  }) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text(
              "RAPOR SISWA",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),

          pw.Text("Nama : $namaSiswa"),
          pw.Text("Kelas : $kelas"),
          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            headers: [
              "Mapel",
              "Tugas",
              "UTS",
              "UAS",
              "Nilai Akhir",
              "Predikat"
            ],
            data: nilaiList.map((nilai) {
              return [
                nilai["mapel"],
                nilai["tugas"].toString(),
                nilai["uts"].toString(),
                nilai["uas"].toString(),
                nilai["nilaiAkhir"].toStringAsFixed(1),
                nilai["predikat"],
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }
}
