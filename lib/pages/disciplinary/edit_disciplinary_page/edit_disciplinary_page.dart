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
import 'package:admin_hrm/pages/reward/bloc/reward_state.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditDisciplinaryPage extends StatelessWidget {
  const EditDisciplinaryPage({super.key, this.disciplinaryModel});
  final DisciplinaryModel? disciplinaryModel;
  @override
  Widget build(BuildContext context) {
    final globalKey = getIt<GlobalStorage>();
    final personals = globalKey.personalManagers!;

    final employee = personals!.firstWhere(
      (element) => element.id == disciplinaryModel?.employeeId,
    );
    TextEditingController codeController = TextEditingController(
      text: disciplinaryModel?.code ?? '',
    );
    TextEditingController disciplinaryTypeController = TextEditingController(
      text: disciplinaryModel?.disciplinaryType ?? '',
    );
    TextEditingController disciplinaryValueController = TextEditingController(
      text: disciplinaryModel?.disciplinaryValue.toString() ?? '',
    );
    TextEditingController reasonController = TextEditingController(
      text: disciplinaryModel?.reason ?? '',
    );
    TextEditingController severityController = TextEditingController(
      text: disciplinaryModel?.severity ?? '',
    );
    TextEditingController statusController = TextEditingController(
      text: disciplinaryModel?.status ?? '',
    );

    TextEditingController approveByController =
        TextEditingController(text: disciplinaryModel!.approvedBy);

    final _formKey = GlobalKey<FormState>();

    return BlocConsumer<DisciplinaryBloc, DisciplinaryState>(
        listener: (context, state) {
      if (state is DisciplinarySuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sửa kỷ luật thành công'),
          ),
        );
        context.go(RouterName.disciplinaryPage);
        // context.go(RouterName.rewardPage);
      } else if (state is RewardError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sửa phần thưởng thất bại: '),
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
                                                    employee.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
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
                                                              id: disciplinaryModel
                                                                  ?.id,
                                                              employeeId:
                                                                  employee.id!,
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
                                                              .add(UpdateDisciplinary(
                                                                  disciplinary));
                                                        }
                                                      },
                                                      child: state
                                                              is DisciplinaryLoading
                                                          ? const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white)
                                                          : Text(
                                                              'Sửa kỷ luật',
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
