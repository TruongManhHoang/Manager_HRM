import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
import 'package:admin_hrm/common/widgets/formatter/input_format.dart';
import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/attendance/attendance_model.dart';
import 'package:admin_hrm/data/model/contract/contract_model.dart';
import 'package:admin_hrm/data/model/disciplinary/disciplinary_model.dart';
import 'package:admin_hrm/data/model/kpi/kpi_model.dart';
import 'package:admin_hrm/data/model/personnel_management.dart';
import 'package:admin_hrm/data/model/reward/reward_model.dart';
import 'package:admin_hrm/data/model/salary/salary_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/salary/bloc/salary_bloc.dart';
import 'package:admin_hrm/utils/code_generator.dart';

import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddSalaryPage extends StatefulWidget {
  const AddSalaryPage({
    super.key,
  });

  @override
  State<AddSalaryPage> createState() => _AddSalaryPageState();
}

class _AddSalaryPageState extends State<AddSalaryPage> {
  late final GlobalStorage globalStorage;
  List<PersionalManagement>? personals;
  List<AttendanceModel>? attendances;
  List<RewardModel>? rewards;
  List<DisciplinaryModel>? disciplinary;
  List<ContractModel>? contracts;
  List<KPIModel>? kpis;
  PersionalManagement? personal;

  final codeController = TextEditingController();
  final employeeIdController = TextEditingController();
  final baseSalaryController = TextEditingController();
  final kpiBonusController = TextEditingController();
  final rewardBonusController = TextEditingController();
  final disciplinaryDeductionController = TextEditingController();
  final attendanceBonusController = TextEditingController();
  late final TextEditingController approveByController;
  final totalSalaryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    globalStorage = getIt<GlobalStorage>();

    personals = globalStorage.personalManagers;
    personal = globalStorage.personalModel;
    attendances = globalStorage.attendances;
    rewards = globalStorage.rewards;
    disciplinary = globalStorage.disciplinaryActions;
    contracts = globalStorage.contracts;
    kpis = globalStorage.kpis;
    approveByController = TextEditingController(
      text: personal?.name ?? '',
    );

    // Tự động generate mã bảng lương
    _generateSalaryCode();

    // Thêm listener để tự động tính tổng lương khi user nhập
    _addCalculationListeners();
  }

  // Thêm listeners cho các trường tiền để tự động tính tổng
  void _addCalculationListeners() {
    baseSalaryController.addListener(_calculateTotalSalary);
    kpiBonusController.addListener(_calculateTotalSalary);
    rewardBonusController.addListener(_calculateTotalSalary);
    disciplinaryDeductionController.addListener(_calculateTotalSalary);
    attendanceBonusController.addListener(_calculateTotalSalary);
  }

  // Tính tổng lương dựa trên các trường đã nhập
  void _calculateTotalSalary() {
    final baseSalary =
        CurrencyInputFormatter.getRawValue(baseSalaryController.text);
    final kpiBonus =
        CurrencyInputFormatter.getRawValue(kpiBonusController.text);
    final rewardBonus =
        CurrencyInputFormatter.getRawValue(rewardBonusController.text);
    final disciplinaryDeduction = CurrencyInputFormatter.getRawValue(
        disciplinaryDeductionController.text);
    final attendanceBonus =
        double.tryParse(attendanceBonusController.text) ?? 0.0;

    // Công thức: Lương cơ bản + KPI + Khen thưởng + Công - Kỷ luật
    final totalSalary = baseSalary +
        kpiBonus +
        rewardBonus +
        attendanceBonus -
        disciplinaryDeduction;

    // Format và hiển thị tổng lương
    final formatter = NumberFormat('#,##0', 'vi_VN');
    totalSalaryController.text = '${formatter.format(totalSalary.toInt())} ₫';
  }

  @override
  void dispose() {
    // Remove listeners khi dispose
    baseSalaryController.removeListener(_calculateTotalSalary);
    kpiBonusController.removeListener(_calculateTotalSalary);
    rewardBonusController.removeListener(_calculateTotalSalary);
    disciplinaryDeductionController.removeListener(_calculateTotalSalary);
    attendanceBonusController.removeListener(_calculateTotalSalary);
    super.dispose();
  } // Hàm tự động tạo mã bảng lương theo format BL + số thứ tự

  void _generateSalaryCode() {
    final existingSalaries = globalStorage.salaries ?? [];
    final existingCodes = existingSalaries.map((s) => s.code ?? '').toList();
    codeController.text = CodeGenerator.generateCode(
      CodeGenerator.salaryPrefix,
      existingCodes,
    );
  }

  String? _selectedUserId;

  void _updateUserData(String? userId) {
    if (userId == null) return;
    final attendancesForUser =
        attendances!.where((u) => u.userId == userId).toList();
    final reward = rewards!.where((u) => u.employeeId == userId).toList();
    final disciplinaryAction =
        disciplinary!.where((u) => u.employeeId == userId).toList();
    final contractsForUser =
        contracts!.where((u) => u.employeeId == userId).toList();
    final kpiForUser = kpis!
        .where((u) => u.userId == userId)
        .toList(); // Tính số ngày chấm công thực tế (mỗi lần chấm công = 1 ngày)
    final totalAttendanceDays = attendancesForUser.length.toDouble();
    final totalDisciplinary = disciplinaryAction.fold<double>(
      0.0,
      (sum, item) => sum + item.disciplinaryValue,
    );

    final totalRewardValue = reward.fold<double>(
      0.0,
      (sum, item) => sum + item.rewardValue,
    );
    final baseSalary = contractsForUser.fold<double>(
      0.0,
      (sum, item) => sum + item.salary,
    );
    final kpiBonus = kpiForUser.fold<double>(
      0.0,
      (sum, item) => sum + item.totalScore,
    ); // Tính lương theo công thức chuẩn
    const workingDaysInMonth = 23.0;
    // Sử dụng số ngày chấm công thực tế (mỗi lần chấm công = 1 ngày)
    final actualWorkingDays = totalAttendanceDays > workingDaysInMonth
        ? workingDaysInMonth
        : totalAttendanceDays; // Không vượt quá số ngày quy định

    final salaryPerDay = baseSalary / workingDaysInMonth;
    final salaryByAttendance = salaryPerDay * actualWorkingDays;

    // Công thức tính lương cuối: Lương theo công + Thưởng - Phạt + KPI
    final totalSalary =
        salaryByAttendance + totalRewardValue - totalDisciplinary + kpiBonus;
    setState(() {
      attendanceBonusController.text = totalAttendanceDays
          .toStringAsFixed(0); // Hiển thị số ngày chấm công (số nguyên)

      // Format tất cả các trường tiền theo VND
      final formatter = NumberFormat('#,##0', 'vi_VN');
      baseSalaryController.text = '${formatter.format(baseSalary.toInt())} ₫';
      kpiBonusController.text = '${formatter.format(kpiBonus.toInt())} ₫';
      rewardBonusController.text =
          '${formatter.format(totalRewardValue.toInt())} ₫';
      disciplinaryDeductionController.text =
          '${formatter.format(totalDisciplinary.toInt())} ₫';
      totalSalaryController.text = '${formatter.format(totalSalary.toInt())} ₫';
    });
  }

  void _submitForm() {
    final selectedUser = personals!.firstWhere((u) => u.id == _selectedUserId);
    if (_formKey.currentState!.validate()) {
      final now = DateTime
          .now(); // Chuyển đổi các giá trị đã format về số thực để lưu vào database
      final newSalary = SalaryModel(
        code: codeController.text, // Sử dụng mã đã được tạo tự động
        employeeId: selectedUser.id!,
        baseSalary:
            CurrencyInputFormatter.getRawValue(baseSalaryController.text),
        kpiBonus: CurrencyInputFormatter.getRawValue(kpiBonusController.text),
        rewardBonus:
            CurrencyInputFormatter.getRawValue(rewardBonusController.text),
        disciplinaryDeduction: CurrencyInputFormatter.getRawValue(
            disciplinaryDeductionController.text),
        attendanceBonus: double.tryParse(attendanceBonusController.text) ?? 0.0,
        approvedBy: approveByController.text,
        totalSalary:
            CurrencyInputFormatter.getRawValue(totalSalaryController.text),
        payDate: now,
      );

      BlocProvider.of<SalaryBloc>(context).add(CreateSalary(newSalary));
    }
  }

  final _formKey = GlobalKey<FormState>();
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalaryBloc, SalaryState>(
      listener: (context, state) {
        if (state is SalarySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thêm bảng lương thành công'),
            ),
          );
          context.go(RouterName.salaryPage);
        } else if (state is SalaryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thêm bảng lương thất bại: ${state.error}'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Row(
            children: [
              const Expanded(child: Sidebar()),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const Header(),
                    Expanded(
                      child: Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const TBreadcrumsWithHeading(
                                heading: 'lương',
                                breadcrumbItems: [RouterName.addSalary],
                              ),
                              Container(
                                width: 600,
                                padding:
                                    const EdgeInsets.all(TSizes.defaultSpace),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bảng lương của tháng ${now.month} năm ${now.year}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Mã bảng lương:',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                              Gap(TSizes.spaceBtwItems),
                                              Text(
                                                codeController.text,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: TColors.dark,
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // TTextFormField(
                                      //   textAlign: true,
                                      //   text: 'Mã bảng lương',
                                      //   hint: 'Mã được tạo tự động',
                                      //   controller: codeController,
                                      //   enabled:
                                      //       false,
                                      // ),
                                      const Gap(TSizes.spaceBtwItems),
                                      Row(
                                        children: [
                                          Text(
                                            'Nhân viên',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          Gap(TSizes.spaceBtwItems),
                                          Expanded(
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: _selectedUserId,
                                              decoration: InputDecoration(
                                                hintText: 'Chọn nhân viên',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[300]!),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                              ),
                                              items: (personals ?? [])
                                                  .map((personal) {
                                                return DropdownMenuItem<String>(
                                                  value: personal.id,
                                                  child: Text(
                                                    personal.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _selectedUserId = value;
                                                    // Cập nhật controller để hiển thị tên nhân viên
                                                    final selectedPerson =
                                                        personals?.firstWhere(
                                                      (p) => p.id == value,
                                                      orElse: () =>
                                                          personals!.first,
                                                    );
                                                    employeeIdController.text =
                                                        selectedPerson?.name ??
                                                            '';
                                                  });
                                                  _updateUserData(value);
                                                }
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Vui lòng chọn nhân viên';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Số công trong tháng',
                                        hint: '',
                                        controller: attendanceBonusController,
                                        enabled: false,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'khen thưởng',
                                        hint: 'Giá trị khen thưởng (₫)',
                                        controller: rewardBonusController,
                                        keyboardType: TextInputType.number,
                                        isFormatted: true,
                                        enabled: false,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'kỷ luật',
                                        hint: 'Giá trị kỷ luật (₫)',
                                        controller:
                                            disciplinaryDeductionController,
                                        keyboardType: TextInputType.number,
                                        isFormatted: true,
                                        enabled: false,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Lương cơ bản',
                                        hint: 'Giá trị cơ bản (₫)',
                                        controller: baseSalaryController,
                                        keyboardType: TextInputType.number,
                                        isFormatted: true,
                                        enabled: false,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Thưởng KPI',
                                        hint: 'Giá trị thưởng KPI (₫)',
                                        controller: kpiBonusController,
                                        keyboardType: TextInputType.number,
                                        isFormatted: true,
                                        enabled: false,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      Row(
                                        children: [
                                          Text('Tổng lương: '),
                                          const Gap(
                                            TSizes.spaceBtwItems,
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey[300]!)),
                                              child: Text(
                                                totalSalaryController.text,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: TColors.dark,
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Người thực hiện',
                                        hint: 'Nhập người thực hiện',
                                        controller: approveByController,
                                        keyboardType: TextInputType.number,
                                      ),
                                      const Gap(TSizes.spaceBtwSections),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal:
                                                      TSizes.defaultSpace * 2,
                                                  vertical: 16,
                                                ),
                                              ),
                                              onPressed: () {
                                                context.pop();
                                              },
                                              child: Text(
                                                'Hủy',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Gap(10),
                                          Expanded(
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal:
                                                      TSizes.defaultSpace * 2,
                                                  vertical: 16,
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _submitForm();
                                                }
                                              },
                                              child: state is SalaryLoading
                                                  ? const CircularProgressIndicator()
                                                  : Text(
                                                      'Thêm lương',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
