import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
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

import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
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
  }

  String? _selectedUserId;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  void _updateUserData(String? userId) {
    if (userId == null) return;

    final attendancesForUser =
        attendances!.where((u) => u.userId == userId).toList();
    final reward = rewards!.where((u) => u.employeeId == userId).toList();
    final disciplinaryAction =
        disciplinary!.where((u) => u.employeeId == userId).toList();
    final contractsForUser =
        contracts!.where((u) => u.employeeId == userId).toList();
    final kpiForUser = kpis!.where((u) => u.userId == userId).toList();

    final totalAttendanceHours = attendancesForUser.fold<double>(
      0.0,
      (sum, item) => sum + (item.numberOfHours ?? 0),
    );

    final totalDisciplinary = disciplinaryAction.fold<double>(
      0.0,
      (sum, item) => sum + (item.disciplinaryValue ?? 0),
    );

    final totalRewardValue = reward.fold<double>(
      0.0,
      (sum, item) => sum + (item.rewardValue ?? 0),
    );

    final baseSalary = contractsForUser.fold<double>(
      0.0,
      (sum, item) => sum + (item.salary ?? 0),
    );
    final kpiBonus = kpiForUser.fold<double>(
      0.0,
      (sum, item) => sum + (item.totalScore ?? 0),
    );
    const workingDaysInMonth = 26.0;
    final totalAttendanceDays = totalAttendanceHours / 8.0;
    final salaryPerDay = baseSalary / workingDaysInMonth;
    final salaryByAttendance = salaryPerDay * totalAttendanceDays;

    final totalSalary =
        salaryByAttendance + totalRewardValue - totalDisciplinary + kpiBonus;

    setState(() {
      attendanceBonusController.text =
          totalAttendanceHours.toStringAsFixed(2); // nếu muốn hiện số giờ
      disciplinaryDeductionController.text = totalDisciplinary.toString();
      baseSalaryController.text = baseSalary.toString();
      rewardBonusController.text = totalRewardValue.toString();
      totalSalaryController.text = totalSalary.toStringAsFixed(2);
      // kpiBonusController.text = kpiBonus.toString();
    });
  }

  void _submitForm() {
    final selectedUser = personals!.firstWhere((u) => u.id == _selectedUserId);
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final newSalary = SalaryModel(
        code: codeController.text,
        employeeId: selectedUser.id!,
        baseSalary: double.tryParse(baseSalaryController.text) ?? 0.0,
        kpiBonus: double.tryParse(kpiBonusController.text) ?? 0.0,
        rewardBonus: double.tryParse(rewardBonusController.text) ?? 0.0,
        disciplinaryDeduction:
            double.tryParse(disciplinaryDeductionController.text) ?? 0.0,
        attendanceBonus: double.tryParse(attendanceBonusController.text) ?? 0.0,
        approvedBy: approveByController.text,
        totalSalary: double.tryParse(totalSalaryController.text) ?? 0.0,
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
              content: Text('Thêm lương thành công'),
            ),
          );
          context.go(RouterName.salaryPage);
        } else if (state is SalaryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thêm lương thất bại: ${state.error}'),
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
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Mã bảng lương',
                                        hint: 'Nhập mã bảng lương',
                                        controller: codeController,
                                      ),
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
                                          Gap(
                                            TSizes.spaceBtwItems,
                                          ),
                                          DropdownMenu(
                                            initialSelection:
                                                employeeIdController.text,
                                            controller: employeeIdController,
                                            width: 200,
                                            trailingIcon: const Icon(
                                                Icons.arrow_drop_down),
                                            dropdownMenuEntries: personals!
                                                .map((personal) =>
                                                    DropdownMenuEntry<String>(
                                                      label: personal.name!,
                                                      value: personal.id!,
                                                    ))
                                                .toList(),
                                            onSelected: (value) {
                                              setState(() {
                                                _selectedUserId = value;
                                                employeeIdController.text =
                                                    value!;
                                              });
                                              _updateUserData(
                                                  value); // <- Gọi cập nhật dữ liệu
                                            },
                                            hintText: 'Chọn nhân viên',
                                          ),
                                        ],
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Số công trong tháng',
                                        hint: '',
                                        controller: attendanceBonusController,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'khen thưởng',
                                        hint: '',
                                        controller: rewardBonusController,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'kỷ luật',
                                        hint: '',
                                        controller:
                                            disciplinaryDeductionController,
                                        keyboardType: TextInputType.number,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Lương cơ bản',
                                        hint: '',
                                        controller: baseSalaryController,
                                        keyboardType: TextInputType.number,
                                      ),
                                      // const Gap(TSizes.spaceBtwItems),
                                      // TTextFormField(
                                      //   textAlign: true,
                                      //   text: 'Thưởng KPI',
                                      //   hint: '',
                                      //   controller: kpiBonusController,
                                      //   keyboardType: TextInputType.number,
                                      // ),
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
                                                backgroundColor: Colors.blue,
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
