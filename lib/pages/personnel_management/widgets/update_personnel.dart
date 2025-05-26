import 'dart:io';

import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import '../../../common/widgets/drop_down_menu/drop_down_menu.dart';
import '../../../common/widgets/layouts/headers/headers.dart';
import '../../../common/widgets/layouts/sidebars/sidebar.dart';
import '../../../common/widgets/text_form/text_form_field.dart';
import '../../../constants/sizes.dart';
import '../../../data/model/personnel_management.dart';
import '../../../router/routers_name.dart';
import '../bloc/persional_bloc.dart';

// ignore: must_be_immutable
class UpdatePersonnel extends StatefulWidget {
  PersionalManagement employee;
  UpdatePersonnel({super.key, required this.employee});

  @override
  State<UpdatePersonnel> createState() => _UpdatePersonnelState();
}

class _UpdatePersonnelState extends State<UpdatePersonnel> {
  final fullNameController = TextEditingController();
  final genderController = TextEditingController();
  final positionController = TextEditingController();
  final departmentController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final birthDateController = TextEditingController();
  final codeController = TextEditingController();
  final statusController = TextEditingController();
  final avatarController = TextEditingController();

  final educationLevels = ['Cao đẳng', 'Đại học', 'Sau đại học'];
  @override
  void initState() {
    codeController.text = widget.employee.code!;
    fullNameController.text = widget.employee.name;
    genderController.text = widget.employee.gender;
    addressController.text = widget.employee.avatar!;
    positionController.text = widget.employee.positionId.toString();
    departmentController.text = widget.employee.departmentId.toString();
    phoneController.text = widget.employee.phone;
    emailController.text = widget.employee.email;
    addressController.text = widget.employee.address;
    birthDateController.text = widget.employee.dateOfBirth;
    statusController.text = widget.employee.status.toString();
    super.initState();
  }

  // XFile? avatarFile;
  // Future<XFile?> pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   return pickedFile;
  // }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final globalStorage = getIt<GlobalStorage>();
    final departments = globalStorage.departments!;
    final positions = globalStorage.positions!;

    String? selectedDepartmentId;
    String? selectedPositionId;

    if (selectedDepartmentId == null) {
      selectedDepartmentId = widget.employee.departmentId;
    }
    if (selectedPositionId == null) {
      selectedPositionId = widget.employee.positionId;
    }
    return Scaffold(
      body: BlocConsumer<PersionalBloc, PersionalState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "Cập nhật thành viên thành công.",
                )));
            context.go(RouterName.employeePage);
          } else if (state.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Lỗi ! Cập nhập thành viên không thành công.",
                    style: TextStyle(color: Colors.white))));
            context.pop();
          }
        },
        builder: (context, state) {
          return Row(
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
                                heading: 'Cập nhật nhân viên',
                                breadcrumbItems: [RouterName.addEmployee],
                              ),
                              const Gap(20),
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
                                    children: [
                                      Image.network(
                                        avatarController.text,
                                        // width: 100,
                                        // height: 200,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Text(
                                              '❌ Lỗi khi tải ảnh: $error');
                                        },
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Mã nhân viên',
                                        hint: 'Nhập mã nhân viên',
                                        controller: codeController,
                                      ),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Họ tên',
                                        hint: 'Nhập họ tên',
                                        controller: fullNameController,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TDropDownMenu(
                                        menus: const ['Nam', 'Nữ'],
                                        controller: genderController,
                                        text: 'Giới tính',
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      GestureDetector(
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                          );
                                          if (pickedDate != null) {
                                            birthDateController.text =
                                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: TTextFormField(
                                            textAlign: true,
                                            text: 'Ngày sinh',
                                            hint: 'Chọn ngày sinh',
                                            controller: birthDateController,
                                          ),
                                        ),
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      Row(
                                        children: [
                                          Text(
                                            'Chức vụ',
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
                                                positionController.text,
                                            controller: positionController,
                                            width: 200,
                                            trailingIcon: const Icon(
                                                Icons.arrow_drop_down),
                                            dropdownMenuEntries: positions
                                                .map((position) =>
                                                    DropdownMenuEntry<String>(
                                                      label: position.name!,
                                                      value: position.id!,
                                                    ))
                                                .toList(),
                                            onSelected: (value) {
                                              selectedPositionId = value;
                                            },
                                            hintText: 'Chọn chức vụ',
                                          ),
                                        ],
                                      ),
                                      // TDropDownMenu(
                                      //   menus: positions,
                                      //   controller: positionController,
                                      //   text: 'Chức vụ',
                                      // ),
                                      const Gap(TSizes.spaceBtwItems),
                                      Row(
                                        children: [
                                          Text(
                                            'Phòng ban',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          const Gap(
                                            TSizes.spaceBtwItems,
                                          ),
                                          DropdownMenu(
                                            initialSelection:
                                                departmentController.text,
                                            controller: departmentController,
                                            width: 200,
                                            trailingIcon: const Icon(
                                                Icons.arrow_drop_down),
                                            dropdownMenuEntries: departments
                                                .map((department) =>
                                                    DropdownMenuEntry<String>(
                                                      label: department.name!,
                                                      value: department.id!,
                                                    ))
                                                .toList(),
                                            onSelected: (value) {
                                              selectedDepartmentId = value;
                                            },
                                            hintText: 'Chọn phòng ban',
                                          ),
                                        ],
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Địa chỉ',
                                        hint: 'Nhập địa chỉ',
                                        controller: addressController,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Số điện thoại',
                                        hint: 'Nhập số điện thoại',
                                        controller: phoneController,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Email',
                                        hint: 'Nhập email',
                                        controller: emailController,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),

                                      TDropDownMenu(
                                        menus: const [
                                          'Đang làm việc',
                                          'Nghỉ việc',
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
                                                backgroundColor: Colors.red,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal:
                                                      TSizes.defaultSpace * 2,
                                                  vertical: 16,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Hủy',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          const Gap(TSizes.spaceBtwItems),
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
                                                  final updateEmployee = PersionalManagement(
                                                      id: widget.employee.id,
                                                      code: codeController.text,
                                                      name: fullNameController
                                                          .text,
                                                      dateOfBirth:
                                                          birthDateController
                                                              .text,
                                                      gender:
                                                          genderController.text,
                                                      positionId:
                                                          selectedPositionId!,
                                                      departmentId:
                                                          selectedDepartmentId!,
                                                      address: addressController
                                                          .text,
                                                      phone:
                                                          phoneController.text,
                                                      email:
                                                          emailController.text,
                                                      status:
                                                          statusController.text,
                                                      date:
                                                          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                                      createdAt: widget
                                                          .employee.createdAt,
                                                      updatedAt:
                                                          DateTime.now());
                                                  context
                                                      .read<PersionalBloc>()
                                                      .add(PersionalUpdateEvent(
                                                        updateEmployee,
                                                        widget.employee
                                                            .departmentId,
                                                      ));
                                                }
                                              },
                                              child: state.isLoading
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.white)
                                                  : Text(
                                                      'Cập nhật',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: Colors.white,
                                                          ),
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
              )
            ],
          );
        },
      ),
    );
  }
}
