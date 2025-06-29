import 'package:admin_hrm/common/widgets/images/t_circular_image.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/menu/menu_item.dart';
import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_event.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:admin_hrm/utils/enum/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final storageKey = getIt<GlobalStorage>();
    final personal = storageKey.personalModel;
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(color: TColors.grey, width: 1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(TSizes.spaceBtwSections),
              TCircularImage(
                width: 100,
                height: 100,
                image: personal!.avatar,
                fit: BoxFit.cover,
                backgroundColor: Colors.transparent,
                imageType: ImageType.network,
              ),
              Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 100,
                        height: 30,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TSizes.sm),
                        ),
                        child: Text(
                          storageKey.role ?? 'Chưa cập nhật',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .apply(color: Colors.green),
                        ),
                      ),
                    ),
                    Text(
                      'Danh sách',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),

                    // Menu items
                    const MenuItem(
                        icon: Iconsax.element_3,
                        title: 'Tổng quan',
                        router: RouterName.dashboard),
                    const MenuItem(
                        icon: Iconsax.profile_2user,
                        title: 'Nhân viên',
                        router: RouterName.employeePage),
                    const MenuItem(
                        icon: Iconsax.building_3,
                        title: 'Phòng ban',
                        router: RouterName.departmentPage),
                    const MenuItem(
                        icon: Iconsax.document_text,
                        title: 'Hợp đồng',
                        router: RouterName.contractPage),
                    const MenuItem(
                        icon: Iconsax.medal,
                        title: 'Chức vụ',
                        router: RouterName.positionPage),
                    const MenuItem(
                        icon: Iconsax.gift1,
                        title: 'Khen thưởng',
                        router: RouterName.rewardPage),
                    const MenuItem(
                        icon: Iconsax.shield_slash,
                        title: 'Kỷ luật',
                        router: RouterName.disciplinaryPage),
                    const MenuItem(
                        icon: Iconsax.wallet,
                        title: 'Lương',
                        router: RouterName.salaryPage),
                    const MenuItem(
                        icon: Iconsax.user,
                        title: 'Tài khoản',
                        router: RouterName.accountPage),
                    const MenuItem(
                        icon: Iconsax.clock,
                        title: 'Chấm công',
                        router: RouterName.attendancePage),
                    const MenuItem(
                        icon: Iconsax.chart_2,
                        title: 'KPI',
                        router: RouterName.kpiPage),
                    const MenuItem(
                        icon: Iconsax.document1,
                        title: 'Xuất báo cáo',
                        router: RouterName.reportPage),
                    const Gap(TSizes.spaceBtwItems),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Iconsax.logout_1),
                          const Gap(TSizes.sm),
                          GestureDetector(
                            onTap: () {
                              _confirmDelete(context);
                            },
                            child: const Text(
                              'Đăng xuất',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _confirmDelete(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Xác nhận xoá'),
      content: Text('Bạn có chắc chắn muốn đăng xuất không?'),
      actions: [
        TextButton(
          child: const Text('Không'),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
        TextButton(
          child: const Text('Có', style: TextStyle(color: Colors.red)),
          onPressed: () {
            context.read<AuthBloc>().add(LogoutRequested());
            context.go(RouterName.splashScreen);
          },
        ),
      ],
    ),
  );
}

void exportPdfForWeb() async {
  final pdf = pw.Document();
  final globalStorage = getIt<GlobalStorage>();
  final positions = globalStorage.positions;
  final departments = globalStorage.departments;
  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        children: [
          pw.Text('BÁO CÁO DANH SÁCH PHÒNG BAN',
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text('Thời gian xuất báo cáo: ${DateTime.now()}'),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
              headers: ['STT', 'Mã PB', 'Tên phòng ban', 'Mô tả'],
              data: List.generate(
                departments!.length,
                (index) => [
                  index + 1,
                  departments[index].code,
                  departments[index].name,
                  departments[index].description ?? 'Không có mô tả',
                ],
              )),
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
}
