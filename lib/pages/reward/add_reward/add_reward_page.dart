import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/drop_down_menu/drop_down_menu.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/reward/reward_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
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

class AddRewardPage extends StatelessWidget {
  const AddRewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalKey = getIt<GlobalStorage>();
    final personals = globalKey.personalManagers!;
    final personal = globalKey.personalModel;
    String? selectedPersonalId;
    TextEditingController personalIdController = TextEditingController();
    TextEditingController codeController = TextEditingController();
    TextEditingController rewardTypeController = TextEditingController();
    TextEditingController rewardValueController = TextEditingController();
    TextEditingController reasonController = TextEditingController();
    TextEditingController approvedByController =
        TextEditingController(text: personal!.name);
    TextEditingController statusController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return BlocConsumer<RewardBloc, RewardState>(listener: (context, state) {
      if (state is RewardSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm phần thưởng thành công'),
          ),
        );
        context.go(RouterName.rewardPage);
        // context.go(RouterName.rewardPage);
      } else if (state is RewardError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm phần thưởng thất bại: ${state.message}'),
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
                              heading: 'Khen thưởng',
                              breadcrumbItems: [
                                RouterName.addReward,
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
                                              text: 'Mã khen thưởng',
                                              hint: 'Nhập mã khen thưởng',
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
                                              menus: const ['Kip', 'Khác'],
                                              controller: rewardTypeController,
                                              text: 'Loại khen thưởng',
                                            ),
                                            Gap(
                                              TSizes.spaceBtwItems,
                                            ),
                                            TTextFormField(
                                              textAlign: true,
                                              text: 'Lý do khen thưởng',
                                              hint: 'Nhập lý do khen thưởng',
                                              controller: reasonController,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              text: 'Giá trị khen thưởng',
                                              hint: 'Nhập giá trị khen thưởng',
                                              controller: rewardValueController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              text: 'Người duyệt',
                                              hint: 'Nhập người duyệt',
                                              controller: approvedByController,
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
                                                          final reward =
                                                              RewardModel(
                                                            employeeId:
                                                                selectedPersonalId!,
                                                            code: codeController
                                                                .text,
                                                            rewardType:
                                                                rewardTypeController
                                                                    .text,
                                                            reason:
                                                                reasonController
                                                                    .text,
                                                            rewardValue: int.tryParse(
                                                                    rewardValueController
                                                                        .text
                                                                        .replaceAll(
                                                                            '.',
                                                                            '')) ??
                                                                0,
                                                            approvedBy:
                                                                approvedByController
                                                                    .text,
                                                            status:
                                                                statusController
                                                                    .text,
                                                          );
                                                          context
                                                              .read<
                                                                  RewardBloc>()
                                                              .add(AddReward(
                                                                  reward));
                                                        }
                                                      },
                                                      child: state
                                                              is RewardLoading
                                                          ? const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white)
                                                          : Text(
                                                              'Thêm khen thưởng',
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
