import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/drop_down_menu/drop_down_menu.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
import 'package:admin_hrm/common/widgets/formatter/input_format.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/contract/contract_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/contract/bloc/contract_bloc.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:admin_hrm/utils/code_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddContract extends StatelessWidget {
  const AddContract({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController codeContractController = TextEditingController();
    TextEditingController contractTypeController = TextEditingController();
    TextEditingController salaryController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();
    TextEditingController employeeController = TextEditingController();
    TextEditingController statusController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final List<String> contractType = [
      'Chính thức',
      'Thử việc',
    ];
    final globalStorage = getIt<GlobalStorage>();
    final persionals = globalStorage.personalManagers;

    // Tự động generate mã hợp đồng
    final existingContracts = globalStorage.contracts ?? [];
    final existingCodes =
        existingContracts.map((c) => c.contractCode ?? '').toList();
    codeContractController.text = CodeGenerator.generateCode(
      CodeGenerator.contractPrefix,
      existingCodes,
    );

    String? selectPersonalId;
    final _globalKey = GlobalKey<FormState>();
    return BlocConsumer<ContractBloc, ContractState>(
        listener: (context, state) {
      if (state.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm hợp đồng thành công'),
          ),
        );
        context.go(RouterName.contractPage);
      } else if (state.isFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm hợp đồng thất bại: ${state.error}'),
          ),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        body: Row(
          children: [
            const Expanded(
              child: Sidebar(),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const Header(),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey[200],
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const TBreadcrumsWithHeading(
                              heading: 'Hợp đồng',
                              breadcrumbItems: [
                                RouterName.addContract,
                              ],
                            ),
                            Container(
                                width: 600,
                                padding:
                                    const EdgeInsets.all(TSizes.defaultSpace),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Form(
                                        key: _globalKey,
                                        child: Column(
                                          children: [
                                            TTextFormField(
                                              textAlign: true,
                                              hint: 'Mã được tạo tự động',
                                              text: 'Mã hợp đồng',
                                              controller:
                                                  codeContractController,
                                              enabled: false,
                                            ),
                                            Gap(TSizes.spaceBtwItems),
                                            Row(
                                              children: [
                                                Text(
                                                  "nhân viên" ?? '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                ),
                                                const Gap(
                                                    TSizes.spaceBtwSections),
                                                DropdownMenu(
                                                  initialSelection:
                                                      employeeController.text,
                                                  controller:
                                                      employeeController,
                                                  width: 200,
                                                  trailingIcon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  dropdownMenuEntries:
                                                      persionals!
                                                          .map((personal) =>
                                                              DropdownMenuEntry<
                                                                  String>(
                                                                label: personal
                                                                    .name,
                                                                value: personal
                                                                    .id!,
                                                              ))
                                                          .toList(),
                                                  onSelected: (value) {
                                                    selectPersonalId = value;
                                                  },
                                                  hintText: 'Chọn nhân viên',
                                                ),
                                              ],
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TDropDownMenu(
                                                menus: contractType,
                                                controller:
                                                    contractTypeController,
                                                text: 'Loại hợp đồng'),
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              hint: 'Nhập lương cơ bản',
                                              text: 'Lương cơ bản',
                                              controller: salaryController,
                                              keyboardType:
                                                  TextInputType.number,
                                              isFormatted: true,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              hint: 'Nhập Mô tả',
                                              text: 'Mô tả',
                                              controller: descriptionController,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),

                                            /// Ngày bắt đầu
                                            GestureDetector(
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2100),
                                                );
                                                if (pickedDate != null) {
                                                  String formattedDate =
                                                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                                  startDateController.text =
                                                      formattedDate;
                                                }
                                              },
                                              child: AbsorbPointer(
                                                child: TTextFormField(
                                                  textAlign: true,
                                                  text: 'Ngày bắt đầu',
                                                  hint: 'Chọn ngày bắt đầu',
                                                  controller:
                                                      startDateController,
                                                ),
                                              ),
                                            ),

                                            /// Khoảng cách
                                            const Gap(TSizes.spaceBtwItems),

                                            /// Ngày kết thúc
                                            GestureDetector(
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2100),
                                                );
                                                if (pickedDate != null) {
                                                  String formattedDate =
                                                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                                  endDateController.text =
                                                      formattedDate;
                                                }
                                              },
                                              child: AbsorbPointer(
                                                child: TTextFormField(
                                                  textAlign: true,
                                                  text: 'Ngày kết thúc',
                                                  hint: 'Chọn ngày kết thúc',
                                                  controller: endDateController,
                                                ),
                                              ),
                                            ),

                                            const Gap(TSizes.spaceBtwItems),
                                            TDropDownMenu(
                                                menus: const [
                                                  'Hoạt động',
                                                  'Đã kết thúc',
                                                ],
                                                text: 'Trạng thái:',
                                                controller: statusController),

                                            const Gap(TSizes.spaceBtwSections),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextButton(
                                                      style: TextButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: TSizes
                                                                      .defaultSpace *
                                                                  2,
                                                              vertical: 16)),
                                                      onPressed: () {
                                                        context.go(RouterName
                                                            .contractPage);
                                                      },
                                                      child: Text(
                                                        'Hủy',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                ),
                                                const Gap(TSizes.defaultSpace),
                                                Expanded(
                                                  child: TextButton(
                                                      style: TextButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue,
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: TSizes
                                                                      .defaultSpace *
                                                                  2,
                                                              vertical: 16)),
                                                      onPressed: () {
                                                        // Handle form submission
                                                        if (_globalKey
                                                            .currentState!
                                                            .validate()) {
                                                          // Debug: In ra giá trị để kiểm tra
                                                          print(
                                                              'Salary text: "${salaryController.text}"');
                                                          final rawSalary =
                                                              CurrencyInputFormatter
                                                                  .getRawValue(
                                                                      salaryController
                                                                          .text);
                                                          print(
                                                              'Raw salary: $rawSalary');

                                                          final contract =
                                                              ContractModel(
                                                            salary: rawSalary
                                                                .toInt(),
                                                            contractCode:
                                                                codeContractController
                                                                    .text
                                                                    .trim(),
                                                            employeeId:
                                                                selectPersonalId,
                                                            contractType:
                                                                contractTypeController
                                                                    .text
                                                                    .trim(),
                                                            description:
                                                                descriptionController
                                                                    .text
                                                                    .trim(),
                                                            status:
                                                                statusController
                                                                    .text
                                                                    .trim(),
                                                            startDate:
                                                                dateFormat.parse(
                                                                    startDateController
                                                                        .text),
                                                            endDate: dateFormat
                                                                .parse(
                                                                    endDateController
                                                                        .text),
                                                            employeeName: persionals
                                                                .firstWhere(
                                                                    (personal) =>
                                                                        personal
                                                                            .id ==
                                                                        selectPersonalId)
                                                                .name,
                                                          );

                                                          // Process data
                                                          context
                                                              .read<
                                                                  ContractBloc>()
                                                              .add(CreateContract(
                                                                  contract));
                                                        }
                                                      },
                                                      child: Text(
                                                        'Thêm hợp đồng',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ))
                                  ],
                                )),
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
    });
  }
}
