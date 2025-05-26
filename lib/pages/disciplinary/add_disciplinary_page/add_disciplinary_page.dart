import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/drop_down_menu/drop_down_menu.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/disciplinary/disciplinary_model.dart';
import 'package:admin_hrm/data/model/reward/reward_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_bloc.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_event.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_state.dart';
import 'package:admin_hrm/pages/position/bloc/position_bloc.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_bloc.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_event.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_state.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddDisciplinaryPage extends StatelessWidget {
  const AddDisciplinaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalKey = getIt<GlobalStorage>();
    final personals = globalKey.personalManagers!;
    final personal = globalKey.personalModel;
    String? selectedPersonalId;
    TextEditingController personalIdController = TextEditingController();
    TextEditingController codeController = TextEditingController();
    TextEditingController disciplinaryTypeController = TextEditingController();
    TextEditingController disciplinaryValueController = TextEditingController();
    TextEditingController reasonController = TextEditingController();
    TextEditingController severityController = TextEditingController();
    TextEditingController approveByController =
        TextEditingController(text: personal!.name);
    TextEditingController statusController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return BlocConsumer<DisciplinaryBloc, DisciplinaryState>(
        listener: (context, state) {
      if (state is DisciplinarySuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm kỷ luật thành công'),
          ),
        );
        context.go(RouterName.disciplinaryPage);
        // context.go(RouterName.rewardPage);
      } else if (state is RewardError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm phần thưởng thất bại: '),
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
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const TBreadcrumsWithHeading(
                              heading: 'Kỷ luật',
                              breadcrumbItems: [
                                RouterName.addDisciplinary,
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
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TTextFormField(
                                              textAlign: true,
                                              text: 'Mã kỷ luật',
                                              hint: 'Nhập mã kỷ luật',
                                              controller: codeController,
                                            ),
                                            const Gap(
                                              TSizes.spaceBtwItems,
                                            ),
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
                                                      personalIdController.text,
                                                  controller:
                                                      personalIdController,
                                                  width: 200,
                                                  trailingIcon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  dropdownMenuEntries: personals
                                                      .map((personal) =>
                                                          DropdownMenuEntry<
                                                              String>(
                                                            label:
                                                                personal.name!,
                                                            value: personal.id!,
                                                          ))
                                                      .toList(),
                                                  onSelected: (value) {
                                                    selectedPersonalId = value;
                                                  },
                                                  hintText: 'Chọn nhân viên',
                                                ),
                                              ],
                                            ),
                                            Gap(
                                              TSizes.spaceBtwItems,
                                            ),
                                            TDropDownMenu(
                                              menus: const [
                                                'Chậm tiến độ',
                                                'Thái độ làm việc',
                                                'Khác'
                                              ],
                                              controller:
                                                  disciplinaryTypeController,
                                              text: 'Loại kỷ luật',
                                            ),
                                            Gap(
                                              TSizes.spaceBtwItems,
                                            ),
                                            TTextFormField(
                                              textAlign: true,
                                              text: 'Lý do kỷ luật',
                                              hint: 'Nhập lý do kỷ luật',
                                              controller: reasonController,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              text: 'Giá trị kỷ luật',
                                              hint: 'Nhập giá trị kỷ luật',
                                              controller:
                                                  disciplinaryValueController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TDropDownMenu(
                                              menus: const [
                                                'Nghiêm trọng',
                                                'Thường',
                                                'Nhẹ'
                                              ],
                                              controller: severityController,
                                              text: 'Mức độ kỷ luật',
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              text: 'Người duyệt',
                                              hint: 'Nhập người duyệt',
                                              controller: approveByController,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TDropDownMenu(
                                              menus: const [
                                                'Hoạt động',
                                                'Ngừng hoạt động'
                                              ],
                                              controller: statusController,
                                              text: 'Trạng thái',
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
                                                        context.pop();
                                                      },
                                                      child: Text(
                                                        'Huỷ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                ),
                                                const Gap(TSizes.spaceBtwItems),
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
                                                        // Handle form submissio
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          final disciplinary = DisciplinaryModel(
                                                              employeeId:
                                                                  selectedPersonalId!,
                                                              code:
                                                                  codeController
                                                                      .text,
                                                              disciplinaryType:
                                                                  disciplinaryTypeController
                                                                      .text,
                                                              disciplinaryValue:
                                                                  int.parse(
                                                                      disciplinaryValueController
                                                                          .text),
                                                              reason:
                                                                  reasonController
                                                                      .text,
                                                              severity:
                                                                  severityController
                                                                      .text,
                                                              status:
                                                                  statusController
                                                                      .text,
                                                              approvedBy:
                                                                  approveByController
                                                                      .text);

                                                          context
                                                              .read<
                                                                  DisciplinaryBloc>()
                                                              .add(AddDisciplinary(
                                                                  disciplinary));
                                                        }
                                                      },
                                                      child: state
                                                              is RewardLoading
                                                          ? const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white)
                                                          : Text(
                                                              'Thêm kỷ luật',
                                                              style: Theme.of(
                                                                      context)
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
