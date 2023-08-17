import 'package:final_presence_app/school_class/dtos/export_dto.dart';

abstract interface class PdfController {
  Future<void> generatePDF(
      {required List<ExportDTO> dtos, required int lessons});
}
