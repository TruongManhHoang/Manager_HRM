import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show Uint8List, rootBundle;

class ReportPageTable extends StatefulWidget {
  const ReportPageTable({super.key});

  @override
  State<ReportPageTable> createState() => _ReportPageTableState();
}

class _ReportPageTableState extends State<ReportPageTable> {
  String selectedReport = 'Phòng ban';
  late String userRole;

  // Định nghĩa quyền truy cập cho từng role
  final Map<String, List<String>> rolePermissions = {
    'admin': [
      'Phòng ban',
      'Nhân viên',
      'Lương',
      'Báo cáo chấm công',
    ],
    'quản lý': [
      'Phòng ban',
      'Nhân viên',
      'Báo cáo chấm công',
    ],
    'kế toán': [
      'Nhân viên',
      'Lương',
      'Báo cáo chấm công',
    ],
    'employee': [
      'Báo cáo chấm công',
    ],
  };

  List<String> get availableReports {
    final globalStorage = getIt<GlobalStorage>();
    userRole = globalStorage.role ?? 'employee';
    return rolePermissions[userRole] ?? ['Báo cáo chấm công'];
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo selectedReport dựa trên quyền của user
    final reports = availableReports;
    if (reports.isNotEmpty) {
      selectedReport = reports.first;
    }
  }

  void _exportReport() {
    if (selectedReport == 'Phòng ban') {
      exportDepartmentReport();
    } else if (selectedReport == 'Nhân viên') {
      exportEmployeeReport();
    } else if (selectedReport == 'Lương') {
      exportSalaryReport();
    } else if (selectedReport == 'Báo cáo chấm công') {
      exportAttendanceReport();
    }
  }

  void exportAttendanceReport() async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final globalStorage = getIt<GlobalStorage>();
    final attendances = globalStorage.attendances;
    final currentUser = globalStorage.personalModel;
    final departments = globalStorage.departments;
    final dateFormatter = DateFormat('dd/MM/yyyy');

    final userDepartment = globalStorage.departments!.firstWhere(
      (element) => element.id == currentUser!.departmentId,
    );
    final userPosition = globalStorage.positions!
        .firstWhere((element) => element.id == currentUser!.positionId);

    pdf.addPage(pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text('BÁO CÁO CHẤM CÔNG ',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    fontSize: 18, font: ttf, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Thời gian xuất báo cáo: ${dateFormatter.format(now)}',
              style: pw.TextStyle(font: ttf)),
          pw.SizedBox(height: 20),

          // Thông tin người viết báo cáo
          pw.Text('Người viết báo cáo',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
          pw.Text('Tên: ${currentUser!.name}', style: pw.TextStyle(font: ttf)),
          pw.Text('Chức vụ: ${userPosition.name}',
              style: pw.TextStyle(font: ttf)),
          pw.Text('Phòng ban: ${userDepartment.name}',
              style: pw.TextStyle(font: ttf)),
          pw.Text('Địa chỉ email: ${currentUser.email}',
              style: pw.TextStyle(font: ttf)),
          pw.Text('Số điện thoại: ${currentUser.phone}',
              style: pw.TextStyle(font: ttf)),
          pw.SizedBox(height: 20),

          // Thống kê tổng quan
          pw.Text('Thống kê tổng quan:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
          pw.Text('Tổng số phòng ban: ${departments?.length ?? 0}',
              style: pw.TextStyle(font: ttf)),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headerStyle: pw.TextStyle(
              font: ttf,
              fontWeight: pw.FontWeight.bold,
              fontSize: 13,
            ),
            cellStyle: pw.TextStyle(
              font: ttf,
              fontSize: 12,
            ),
            cellPadding: const pw.EdgeInsets.all(4),
            columnWidths: {
              0: const pw.FixedColumnWidth(30),
              1: const pw.FixedColumnWidth(60),
              2: const pw.FixedColumnWidth(100),
              3: const pw.FixedColumnWidth(120),
              4: const pw.FixedColumnWidth(70),
              5: const pw.FixedColumnWidth(70),
            },
            border: pw.TableBorder.all(
              color: PdfColors.grey400,
              width: 0.5,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            headers: [
              'STT',
              'Tên nhân viên',
              'Thời gian vào',
              'Thời gian ra',
              'công theo ngày',
              'Ngày chấm công'
            ],
            data: attendances?.asMap().entries.map((entry) {
                  final index = entry.key;
                  final attendance = entry.value;
                  return [
                    (index + 1).toString(),
                    attendance.userName,
                    dateFormatter.format(attendance.checkInTime!),
                    dateFormatter.format(attendance.checkOutTime!),
                    attendance.numberOfHours.toString(),
                    attendance.date,
                  ];
                }).toList() ??
                [],
          ),
        ],
      ),
    ));
    Uint8List bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute(
          "download", "bao_cao_cham_cong_${dateFormatter.format(now)}.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xuất báo cáo chấm công!')),
    );
  }

  void exportDepartmentReport() async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final globalStorage = getIt<GlobalStorage>();
    final personals = globalStorage.personalManagers;
    final currentUser = globalStorage.personalModel;
    final departments = globalStorage.departments;
    final dateFormatter = DateFormat('dd/MM/yyyy');

    final userDepartment = globalStorage.departments!.firstWhere(
      (element) => element.id == currentUser!.departmentId,
    );
    final userPosition = globalStorage.positions!
        .firstWhere((element) => element.id == currentUser!.positionId);

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text('BÁO CÁO PHÒNG BAN',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 18, font: ttf, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Thời gian xuất báo cáo: ${dateFormatter.format(now)}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),

            // Thông tin người viết báo cáo
            pw.Text('Người viết báo cáo',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
            pw.Text('Tên: ${currentUser!.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Chức vụ: ${userPosition.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Phòng ban: ${userDepartment.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Địa chỉ email: ${currentUser.email}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Số điện thoại: ${currentUser.phone}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),

            // Thống kê tổng quan
            pw.Text('Thống kê tổng quan:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
            pw.Text('Tổng số phòng ban: ${departments?.length ?? 0}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                font: ttf,
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
              ),
              cellStyle: pw.TextStyle(
                font: ttf,
                fontSize: 10,
              ),
              cellPadding: const pw.EdgeInsets.all(4),
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(60),
                2: const pw.FixedColumnWidth(100),
                3: const pw.FixedColumnWidth(120),
                4: const pw.FixedColumnWidth(70),
              },
              border: pw.TableBorder.all(
                color: PdfColors.grey400,
                width: 0.5,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              headers: ['STT', 'Mã PB', 'Tên phòng ban', 'Mô tả', 'Ngày tạo'],
              data: departments?.asMap().entries.map((entry) {
                    final index = entry.key;
                    final department = entry.value;
                    return [
                      (index + 1).toString(),
                      department.code ?? 'N/A',
                      department.name,
                      department.description,
                      department.createdAt != null
                          ? dateFormatter.format(department.createdAt!)
                          : 'N/A',
                    ];
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );

    Uint8List bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute(
          "download", "bao_cao_phong_ban_${dateFormatter.format(now)}.pdf")
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
    final personals = globalStorage.personalManagers;
    final currentUser = globalStorage.personalModel; // Người tạo báo cáo
    final role = globalStorage.role;

    // Thông tin người tạo báo cáo
    final userDepartment = globalStorage.departments!.firstWhere(
      (element) => element.id == currentUser!.departmentId,
    );
    final userPosition = globalStorage.positions!
        .firstWhere((element) => element.id == currentUser!.positionId);

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text('BÁO CÁO NHÂN SỰ TỔNG HỢP',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 18, font: ttf, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Thời gian xuất báo cáo: ${dateFormatter.format(now)}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),

            // Thông tin người viết báo cáo
            pw.Text('Người viết báo cáo',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
            pw.Text('Tên: ${currentUser!.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Chức vụ: ${userPosition.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Phòng ban: ${userDepartment.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Địa chỉ email: ${currentUser.email}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Số điện thoại: ${currentUser.phone}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),

            // Thống kê tổng quan
            pw.Text('Thống kê tổng quan:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
            pw.Text('Tổng số nhân viên: ${personals?.length ?? 0}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),

            // Bảng danh sách nhân viên
            // Trong hàm exportEmployeeReport()
            pw.Table.fromTextArray(
              // ✅ Tăng kích thước font và spacing
              headerStyle: pw.TextStyle(
                font: ttf,
                fontWeight: pw.FontWeight.bold,
                fontSize: 13, // Tăng từ 8 lên 10
              ),
              cellStyle: pw.TextStyle(
                font: ttf,
                fontSize: 12, // Tăng từ 8 lên 9
              ),

              // ✅ Thêm padding cho cells
              cellPadding: const pw.EdgeInsets.all(4),

              // ✅ Tùy chỉnh độ rộng cột
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(60),
                2: const pw.FixedColumnWidth(80),
                3: const pw.FixedColumnWidth(70),
                4: const pw.FixedColumnWidth(70),
                5: const pw.FixedColumnWidth(100),
                6: const pw.FixedColumnWidth(80),
                7: const pw.FixedColumnWidth(120),
                8: const pw.FixedColumnWidth(80),
                9: const pw.FixedColumnWidth(70),
                10: const pw.FixedColumnWidth(60),
                11: const pw.FixedColumnWidth(70),
              },

              // ✅ Thêm viền bảng
              border: pw.TableBorder.all(
                color: PdfColors.grey400,
                width: 0.5,
              ),

              // ✅ Màu nền cho header
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),

              headers: [
                'STT',
                'Mã NV',
                'Tên',
                'Ngày sinh',
                'GT',
                'Địa chỉ',
                'SĐT',
                'Email',
                'Phòng ban',
                'Chức vụ',
                'Trạng thái',
                'Ngày vào',
              ],

              data: personals?.asMap().entries.map((entry) {
                    final index = entry.key;
                    final person = entry.value;

                    final personDept = globalStorage.departments!.firstWhere(
                      (dept) => dept.id == person.departmentId,
                      orElse: () => globalStorage.departments!.first,
                    );

                    final personPos = globalStorage.positions!.firstWhere(
                      (pos) => pos.id == person.positionId,
                      orElse: () => globalStorage.positions!.first,
                    );

                    return [
                      (index + 1).toString(),
                      person.code ?? 'N/A',
                      person.name,
                      person.dateOfBirth,
                      person.gender, // ✅ Cắt ngắn địa chỉ nếu quá dài
                      person.address.length > 20
                          ? '${person.address.substring(0, 20)}...'
                          : person.address,
                      person.phone,
                      // ✅ Cắt ngắn email nếu quá dài
                      person.email.length > 25
                          ? '${person.email.substring(0, 25)}...'
                          : person.email,
                      personDept.name,
                      personPos.name ?? 'N/A',
                      person.status ?? 'N/A',
                      person.createdAt != null
                          ? dateFormatter.format(person.createdAt!)
                          : 'N/A',
                    ];
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );

    Uint8List bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute(
          "download", "bao_cao_nhan_su_${dateFormatter.format(now)}.pdf")
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
    final salaries = globalStorage.salaries;
    final currentUser = globalStorage.personalModel;
    final userDepartment = globalStorage.departments!.firstWhere(
      (element) => element.id == currentUser!.departmentId,
    );
    final userPosition = globalStorage.positions!
        .firstWhere((element) => element.id == currentUser!.positionId);

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text('BÁO CÁO BẢNG LƯƠNG NHÂN SỰ',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 18, font: ttf, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Ngày xuất báo cáo: ${dateFormatter.format(now)}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),

            // Thông tin người viết báo cáo
            pw.Text('Người viết báo cáo',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
            pw.Text('Tên: ${currentUser!.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Chức vụ: ${userPosition.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Phòng ban: ${userDepartment.name}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Địa chỉ email: ${currentUser.email}',
                style: pw.TextStyle(font: ttf)),
            pw.Text('Số điện thoại: ${currentUser.phone}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),

            // Thống kê tổng quan
            pw.Text('Thống kê tổng quan:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
            pw.Text('Tổng số bảng lương: ${salaries?.length ?? 0}',
                style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),

            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                font: ttf,
                fontWeight: pw.FontWeight.bold,
                fontSize: 13,
              ),
              cellStyle: pw.TextStyle(
                font: ttf,
                fontSize: 12,
              ),
              cellPadding: const pw.EdgeInsets.all(3),
              columnWidths: {
                0: const pw.FixedColumnWidth(25),
                1: const pw.FixedColumnWidth(60),
                2: const pw.FixedColumnWidth(70),
                3: const pw.FixedColumnWidth(60),
                4: const pw.FixedColumnWidth(50),
                5: const pw.FixedColumnWidth(60),
                6: const pw.FixedColumnWidth(50),
                7: const pw.FixedColumnWidth(50),
                8: const pw.FixedColumnWidth(60),
                9: const pw.FixedColumnWidth(70),
                10: const pw.FixedColumnWidth(60),
              },
              border: pw.TableBorder.all(
                color: PdfColors.grey400,
                width: 0.5,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              headers: [
                'STT',
                'Mã BL',
                'Tên NV',
                'Lương CB',
                'Thưởng KPI',
                'Khen thưởng',
                'Kỷ luật',
                'Ngày công',
                'Tổng lương',
                'Người duyệt',
                'Ngày tạo',
              ],
              data: salaries?.asMap().entries.map((entry) {
                    final index = entry.key;
                    final salary = entry.value;

                    // Tìm thông tin nhân viên
                    final employee = globalStorage.personalManagers?.firstWhere(
                      (emp) => emp.id == salary.employeeId,
                      orElse: () => globalStorage.personalManagers!.first,
                    );
                    // Format số tiền
                    final formatter = NumberFormat('#,###');

                    return [
                      (index + 1).toString(),
                      salary.code ?? 'N/A', employee?.name ?? 'N/A',
                      '${formatter.format(salary.baseSalary)} VNĐ',
                      '${formatter.format(salary.kpiBonus)} VNĐ',
                      '${formatter.format(salary.rewardBonus)} VNĐ',
                      // ignore: unnecessary_null_comparison
                      salary.disciplinaryDeduction != null
                          ? '${formatter.format(salary.disciplinaryDeduction)} VNĐ'
                          : 'N/A',
                      salary.attendanceBonus.toString(),
                      salary.totalSalary != null
                          ? '${formatter.format(salary.totalSalary)} VNĐ'
                          : 'N/A',
                      salary.approvedBy,
                      salary.payDate != null
                          ? dateFormatter.format(salary.payDate!)
                          : 'N/A',
                    ];
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );

    Uint8List bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute(
          "download", "bao_cao_bang_luong_${dateFormatter.format(now)}.pdf")
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
              const Gap(8),
              // Hiển thị role người dùng
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Text(
                  'Quyền: $userRole',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
              const Gap(20),
              Text(
                'Chọn loại báo cáo bạn muốn xuất',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
              ),
              const Gap(16),
              // Hiển thị thông báo quyền hạn
              if (availableReports.length == 1 && userRole == 'Employee')
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bạn chỉ có quyền xem báo cáo chấm công',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              DropdownButtonFormField<String>(
                value: selectedReport,
                items: availableReports
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
