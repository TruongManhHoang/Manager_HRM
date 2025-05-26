import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/drop_down_menu/drop_down_menu.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/position/position_model.dart';
import 'package:admin_hrm/pages/position/bloc/position_bloc.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddPosition extends StatelessWidget {
  const AddPosition({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController namePositionController = TextEditingController();
    TextEditingController codePositionController = TextEditingController();
    TextEditingController coefficientPositionController =
        TextEditingController();
    TextEditingController positionTypeController = TextEditingController();
    TextEditingController descriptionPositionController =
        TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return BlocConsumer<PositionBloc, PositionState>(
        listener: (context, state) {
      if (state.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm chức vụ thành công'),
          ),
        );
        context.go(RouterName.positionPage);
      } else if (state.isFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm chức vụ thất bại: ${state.error}'),
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
                              heading: 'Chức vụ',
                              breadcrumbItems: [
                                RouterName.addPosition,
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
                                              hint: 'Mã chức vụ',
                                              text: 'Tên chức vụ',
                                              controller:
                                                  codePositionController,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              hint: 'Nhập tên chức vụ',
                                              text: 'Tên chức vụ',
                                              controller:
                                                  namePositionController,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TDropDownMenu(
                                                menus: const [
                                                  'Nhân viên',
                                                  'Quản lý',
                                                  'Giám đốc',
                                                ],
                                                controller:
                                                    positionTypeController,
                                                text: 'Chức vụ'),
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              hint: 'Nhập hệ số chức vụ',
                                              text: 'Hệ số chức vụ',
                                              controller:
                                                  coefficientPositionController,
                                            ),
                                            const Gap(TSizes.spaceBtwItems),
                                            TTextFormField(
                                              textAlign: true,
                                              hint: 'Nhập mô tả chức vụ',
                                              text: 'Mô tả chức vụ',
                                              controller:
                                                  descriptionPositionController,
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
                                                        // Handle form submission

                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          final position =
                                                              PositionModel(
                                                            name:
                                                                namePositionController
                                                                    .text,
                                                            positionSalary:
                                                                int.parse(
                                                                    coefficientPositionController
                                                                        .text),
                                                            description:
                                                                descriptionPositionController
                                                                    .text,
                                                            positionType:
                                                                positionTypeController
                                                                    .text,
                                                            code:
                                                                codePositionController
                                                                    .text,
                                                          );
                                                          context
                                                              .read<
                                                                  PositionBloc>()
                                                              .add(CreatePosition(
                                                                  position));
                                                          // Process data
                                                          // context.go(RouterName
                                                          //     .positionPage);
                                                        }
                                                      },
                                                      child: state.isLoading
                                                          ? const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white)
                                                          : Text(
                                                              'Thêm chức vụ',
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
