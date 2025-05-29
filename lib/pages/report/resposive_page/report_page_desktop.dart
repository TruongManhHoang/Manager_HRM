import 'dart:typed_data';
import 'dart:html' as html;
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class ReportPageDesktop extends StatefulWidget {
  const ReportPageDesktop({super.key});

  @override
  State<ReportPageDesktop> createState() => _ReportPageDesktopState();
}

class _ReportPageDesktopState extends State<ReportPageDesktop> {
  String selectedReport = 'Phòng ban';

  final List<String> reportTypes = [
    'Phòng ban',
    'Nhân viên',
    'Lương',
    'Hiệu suất làm việc',
  ];

  void _exportReport() {
    if (selectedReport == 'Phòng ban') {
      exportDepartmentReport();
    } else if (selectedReport == 'Nhân viên') {
      exportEmployeeReport();
    } else if (selectedReport == 'Lương') {
      exportSalaryReport();
    } else if (selectedReport == 'Hiệu suất làm việc') {
      exportKpiReport();
    }
  }

  void exportDepartmentReport() async {
    final pdf = pw.Document();
    final now = DateTime.now();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text('BÁO CÁO DANH SÁCH PHÒNG BAN',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Thời gian xuất báo cáo: $now'),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['STT', 'Mã PB', 'Tên phòng ban', 'Mô tả'],
              data: List.generate(
                  3,
                  (index) => [
                        index + 1,
                        'PB00$index',
                        'Phòng số $index',
                        'Mô tả mẫu cho phòng $index',
                      ]),
            ),
          ],
        ),
      ),
    );

    Uint8List bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "bao_cao_phong_ban.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xuất báo cáo phòng ban!')),
    );
  }

  final dateFormatter = DateFormat('dd/MM/yyyy');
  void exportEmployeeReport() async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final globalStorage = getIt<GlobalStorage>();
    final personal = globalStorage.personalModel;
    final role = globalStorage.role;
    final department = globalStorage.departments!.firstWhere(
      (element) => element.id == personal!.departmentId,
    );
    final positions = globalStorage.positions!
        .firstWhere((element) => element.id == personal!.positionId);
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('BÁO CÁO NHÂN SỰ TỔNG HỢP',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    fontSize: 18, font: ttf, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Thời gian xuất báo cáo: ${dateFormatter.format(now)}',
                style: pw.TextStyle(
                  font: ttf,
                )),
            pw.SizedBox(height: 20),
            pw.Text('Người viết báo cáo',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Tên: ${personal!.name}', style: pw.TextStyle(font: ttf)),
            pw.Text('Chức vụ: ${role}', style: pw.TextStyle(font: ttf)),
            pw.Text('Phòng ban: ${department.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Địa chỉ email: ${personal.email}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Số điện thoại: ${personal.phone}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: [
                'STT',
                'Mã nhân viên',
                'Tên nhân viên',
                'Ngày sinh',
                'Giới tính',
                'Địa chỉ',
                'Số điện thoại',
                'Email',
                'Phòng ban',
                'Chức vụ',
                'Trạng thái',
                'Ngày vào làm',
              ],
              data: List.generate(
                  3,
                  (index) => [
                        index + 1,
                        'NV00$index',
                        personal.name,
                        personal.dateOfBirth,
                        personal.gender,
                        personal.address,
                        personal.phone,
                        personal.email,
                        department.name,
                        positions.name,
                        personal.status,
                        dateFormatter.format(personal.createdAt!)
                      ]),
            ),
          ],
        ),
      ),
    );

    Uint8List bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "bao_cao_nhan_su.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xuất báo cáo nhân viên!')),
    );
  }

  void exportSalaryReport() async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final globalStorage = getIt<GlobalStorage>();
    final personal = globalStorage.personalModel;
    final role = globalStorage.role;
    final salaries = globalStorage;;;
    final department = globalStorage.departments!.firstWhere(
      (element) => element.id == personal!.departmentId,
    );
    final positions = globalStorage.positions!
        .firstWhere((element) => element.id == personal!.positionId);
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('BÁO CÁO BẢNG LƯƠNG NHÂN SỰ',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    fontSize: 18, font: ttf, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Ngày xuất báo cáo: ${dateFormatter.format(now)}',
                style: pw.TextStyle(
                  font: ttf,
                )),
            pw.SizedBox(height: 20),
            pw.Text('Người viết báo cáo',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Tên: ${personal!.name}', style: pw.TextStyle(font: ttf)),
            pw.Text('Chức vụ: ${role}', style: pw.TextStyle(font: ttf)),
            pw.Text('Phòng ban: ${department.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Địa chỉ email: ${personal.email}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Số điện thoại: ${personal.phone}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: [
                'STT',
                'Mã bảng lương',
                'Lương cơ bản',
                'thưởng kpi',
                'Giá trị khen thưởng',
                'Giá trị kỷ luật',
                'Số ngày công',
                'tổng lương',
                'Người duyệt',
                'Ngày tạo',
              ],
              data: List.generate(
                  3,
                  (index) => [
                        index + 1,
                        'BL00$index',
                        personal.name,
                        personal.dateOfBirth,
                        personal.gender,
                        personal.address,
                        personal.phone,
                        personal.email,
                        department.name,
                        positions.name,
                        personal.status,
                        dateFormatter.format(personal.createdAt!)
                      ]),
            ),
          ],
        ),
      ),
    );

    Uint8List bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "bao_cao_nhan_su.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xuất báo cáo lương!')),
    );
  }

  void exportKpiReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xuất báo cáo lương!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Báo cáo',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      )),
              const Gap(20),
              Text(
                'Chọn loại báo cáo bạn muốn xuất',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
              ),
              const Gap(16),
              DropdownButtonFormField<String>(
                value: selectedReport,
                items: reportTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedReport = value!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _exportReport,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Xuất báo cáo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
