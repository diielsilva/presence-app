import 'package:final_presence_app/school_class/controllers/pdf_controller.dart';
import 'package:final_presence_app/school_class/dtos/export_dto.dart';
import 'package:open_document/my_files/init.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as widgets;

class PdfControllerImpl implements PdfController {
  static PdfController? _instance;

  PdfControllerImpl._();

  static PdfController get instance => _instance ??= PdfControllerImpl._();

  widgets.Row _pdfHeader() {
    return widgets.Row(
      mainAxisAlignment: widgets.MainAxisAlignment.center,
      children: [
        widgets.Text(
          "Relatório de Presença",
          style: widgets.TextStyle(
              fontSize: 22, fontWeight: widgets.FontWeight.bold),
        )
      ],
    );
  }

  widgets.Table _pdfContent({required List<ExportDTO> dtos}) {
    return widgets.Table(
      children: dtos
          .map(
            (dto) => widgets.TableRow(
              children: [
                widgets.Text("${dto.name}"),
                widgets.Text("Presencas: ${dto.presences}"),
                widgets.Text("Faltas: ${dto.absences}"),
              ],
            ),
          )
          .toList(growable: false),
    );
  }

  widgets.Row _pdfFooter({required int lessons}) {
    return widgets.Row(
      mainAxisAlignment: widgets.MainAxisAlignment.center,
      children: [
        widgets.Text(
          "Total de Aulas: $lessons",
          style: widgets.TextStyle(
              fontSize: 22, fontWeight: widgets.FontWeight.bold),
        )
      ],
    );
  }

  @override
  Future<void> generatePDF(
      {required List<ExportDTO> dtos, required int lessons}) async {
    final widgets.Document pdf = widgets.Document();
    Directory pdfFolder = await getApplicationDocumentsDirectory();
    String pdfName = "${DateTime.now().millisecondsSinceEpoch}.pdf";
    final File pdfFile = File("${pdfFolder.path}\\$pdfName");

    pdf.addPage(
      widgets.MultiPage(
        build: (context) {
          return [
            widgets.Column(
              children: [
                _pdfHeader(),
                widgets.SizedBox(height: 15),
                _pdfContent(dtos: dtos),
                widgets.SizedBox(height: 15),
                _pdfFooter(lessons: lessons)
              ],
            ),
          ];
        },
      ),
    );

    Uint8List pdfBytes = await pdf.save();

    await pdfFile.writeAsBytes(pdfBytes);
    await OpenDocument.openDocument(filePath: pdfFile.path);
  }
}
