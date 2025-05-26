import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/drop_down_menu/drop_down_menu.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/contract/contract_model.dart';
import 'package:admin_hrm/pages/contract/bloc/contract_bloc.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditContract extends StatelessWidget {
  const EditContract({super.key, required this.contract});
  final ContractModel contract;
  @override
  Widget build(BuildContext context) {
    TextEditingController codeContractController = TextEditingController(
      text: contract.contractCode ?? '',
    );
    TextEditingController contractTypeController = TextEditingController(
      text: contract.contractType ?? '',
    );
    TextEditingController salaryController = TextEditingController(
      text: contract.salary != null
          ? NumberFormat('#,###').format(contract.salary)
          : '',
    );
    TextEditingController startDateController = TextEditingController(
      text: contract.startDate != null
          ? DateFormat('dd/MM/yyyy').format(contract.startDate!)
          : '',
    );
    TextEditingController endDateController = TextEditingController(
      text: contract.endDate != null
          ? DateFormat('dd/MM/yyyy').format(contract.endDate!)
          : '',
    );
    TextEditingController employeeController = TextEditingController(
      text: contract.employeeId ?? '',
    );
    TextEditingController statusController = TextEditingController(
      text: contract.status ?? '',
    );
    TextEditingController descriptionController = TextEditingController(
      text: contract.description ?? '',
    );
    final dateFormat = DateFormat('dd/MM/yyyy');
    final List<String> contractType = [
      'Chính thức',
      'Thử việc',
    ];
    final List<String> employee = [
      '001',
      '002',
      '003',
    ];
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
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
                                              hint: 'Mã hợp đồng',
                                              text: 'Mã hợp đồng',
                                              controller:
                                                  codeContractController,
                                            ),
                                            Gap(TSizes.spaceBtwItems),
                                            Row(
                                              children: [
                                                Text(
                                                  'Nhân viên:',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                                const Gap(TSizes.spaceBtwItems),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300)),
                                                  child: Text(
                                                    contract.employeeId!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
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
                                              hint: 'Nhập lương',
                                              text: 'Lương',
                                              controller: salaryController,
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
                                                      formattedDate; // ✅ dùng đúng controller
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
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              hint: 'Nhập Mô tả',
                                              text: 'Mô tả',
                                              controller: descriptionController,
                                            ),
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
                                                          final contractModel =
                                                              ContractModel(
                                                                  id: contract
                                                                      .id,
                                                                  salary: int
                                                                          .tryParse(
                                                                        salaryController.text.replaceAll(
                                                                            RegExp(r'[^\d]'),
                                                                            ''),
                                                                      ) ??
                                                                      0,
                                                                  contractCode:
                                                                      codeContractController
                                                                          .text
                                                                          .trim(),
                                                                  employeeId:
                                                                      employeeController
                                                                          .text
                                                                          .trim(),
                                                                  createdAt: contract
                                                                      .createdAt,
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
                                                                  startDate: dateFormat.parse(
                                                                      startDateController
                                                                          .text),
                                                                  endDate: dateFormat.parse(
                                                                      endDateController
                                                                          .text),
                                                                  updatedAt:
                                                                      DateTime
                                                                          .now());

                                                          // Process data
                                                          context
                                                              .read<
                                                                  ContractBloc>()
                                                              .add(UpdateContract(
                                                                  contractModel));
                                                        }
                                                      },
                                                      child: Text(
                                                        'Cập nhật hợp đồng',
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
