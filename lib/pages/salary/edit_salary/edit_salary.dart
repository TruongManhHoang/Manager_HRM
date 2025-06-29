import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
import 'package:admin_hrm/common/widgets/formatter/input_format.dart';
import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/personnel_management.dart';
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

class EditSalaryPage extends StatefulWidget {
  const EditSalaryPage({super.key, required this.salary});
  final SalaryModel salary;

  @override
  State<EditSalaryPage> createState() => _EditSalaryPageState();
}

class _EditSalaryPageState extends State<EditSalaryPage> {
  late final GlobalStorage globalStorage;
  List<PersionalManagement>? personals;

  final codeController = TextEditingController();
  final employeeIdController = TextEditingController();
  final baseSalaryController = TextEditingController();
  final kpiBonusController = TextEditingController();
  final rewardBonusController = TextEditingController();
  final disciplinaryDeductionController = TextEditingController();
  final attendanceBonusController = TextEditingController();
  final approveByController = TextEditingController();
  final totalSalaryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    globalStorage = getIt<GlobalStorage>();
    _selectedUserId = widget.salary.employeeId;
    personals = globalStorage.personalManagers;
    codeController.text = widget.salary.code!;
    employeeIdController.text =
        widget.salary.employeeId; // Format initial values to VND
    final formatter = NumberFormat('#,##0', 'vi_VN');
    baseSalaryController.text =
        '${formatter.format(widget.salary.baseSalary.toInt())} ₫';
    kpiBonusController.text =
        '${formatter.format(widget.salary.kpiBonus.toInt())} ₫';
    rewardBonusController.text =
        '${formatter.format(widget.salary.rewardBonus.toInt())} ₫';
    disciplinaryDeductionController.text =
        '${formatter.format(widget.salary.disciplinaryDeduction.toInt())} ₫';
    attendanceBonusController.text = widget.salary.attendanceBonus.toString();
    approveByController.text = widget.salary.approvedBy;
    totalSalaryController.text =
        '${formatter.format(widget.salary.totalSalary!.toInt())} ₫';

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

  String? _selectedUserId;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  void _submitForm() {
    final selectedUser = personals!.firstWhere((u) => u.id == _selectedUserId);
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final newSalary = SalaryModel(
        id: widget.salary.id,
        code: codeController.text,
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

      BlocProvider.of<SalaryBloc>(context).add(UpdateSalary(newSalary));
    }
  }

  final _formKey = GlobalKey<FormState>();
  DateTime now = DateTime.now();
  @override
  void dispose() {
    // Remove listeners khi dispose
    baseSalaryController.removeListener(_calculateTotalSalary);
    kpiBonusController.removeListener(_calculateTotalSalary);
    rewardBonusController.removeListener(_calculateTotalSalary);
    disciplinaryDeductionController.removeListener(_calculateTotalSalary);
    attendanceBonusController.removeListener(_calculateTotalSalary);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalaryBloc, SalaryState>(
      listener: (context, state) {
        if (state is SalarySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sửa lương thành công'),
            ),
          );
          context.go(RouterName.salaryPage);
        } else if (state is SalaryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sửa lương thất bại: ${state.error}'),
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
                                                    final selectedPerson =
                                                        personals?.firstWhere(
                                                      (p) => p.id == value,
                                                    );
                                                    employeeIdController.text =
                                                        selectedPerson?.name ??
                                                            '';
                                                  });
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
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'khen thưởng',
                                        hint: 'Nhập khen thưởng (₫)',
                                        controller: rewardBonusController,
                                        keyboardType: TextInputType.number,
                                        isFormatted: true,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'kỷ luật',
                                        hint: 'Nhập kỷ luật (₫)',
                                        controller:
                                            disciplinaryDeductionController,
                                        keyboardType: TextInputType.number,
                                        isFormatted: true,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Lương cơ bản',
                                        hint: 'Nhập lương cơ bản (₫)',
                                        controller: baseSalaryController,
                                        keyboardType: TextInputType.number,
                                        isFormatted: true,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Thưởng KPI',
                                        hint: 'Nhập thưởng KPI (₫)',
                                        controller: kpiBonusController,
                                        keyboardType: TextInputType.number,
                                        isFormatted: true,
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
                                                      'Sửa lương',
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
