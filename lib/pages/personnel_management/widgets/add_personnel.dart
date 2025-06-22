import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/drop_down_menu/drop_down_menu.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/personnel_management.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/personnel_management/bloc/persional_bloc.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:admin_hrm/utils/helpers/helper_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:http/http.dart' as http;

class AddEmployeeForm extends StatefulWidget {
  const AddEmployeeForm({super.key});

  @override
  State<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  String? uploadedImageUrl;

  Future<Map<String, dynamic>?> pickImageWeb() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      return {
        'fileName': result.files.single.name,
        'fileBytes': result.files.single.bytes,
      };
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController();
    final fullNameController = TextEditingController();
    final genderController = TextEditingController();
    final positionController = TextEditingController();
    final departmentController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    final educationLevelController = TextEditingController();
    final birthDateController = TextEditingController();
    final statusController = TextEditingController();

    // final positions = ['Nhân viên', 'Quản lý', 'Trưởng phòng'];
    // final departments = ['Phòng nhân sự', 'Phòng kế toán'];
    final educationLevels = ['Cao đẳng', 'Đại học', 'Sau đại học'];

    final globalStorage = getIt<GlobalStorage>();
    final departments = globalStorage.departments!;
    final positions = globalStorage.positions!;
    Future<String?> uploadToCloudinary(
        Uint8List fileBytes, String fileName) async {
      const cloudName = 'dfxx9hded'; // Thay bằng của bạn
      const uploadPreset = 'manage_hrm'; // Đã tạo trong Dashboard

      final uri =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(http.MultipartFile.fromBytes('file', fileBytes,
            filename: fileName));

      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = jsonDecode(res.body);
        return data['secure_url']; // ✅ Link ảnh public để lưu vào Firebase
      } else {
        print("Upload failed: ${response.statusCode}");
        return null;
      }
    }

    Future<void> pickAndUploadImage() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final imageUrl = await uploadToCloudinary(
            result.files.single.bytes!, result.files.single.name);
        setState(() {
          uploadedImageUrl = imageUrl;
        });
        if (imageUrl != null) {
          print("✅ Uploaded Image URL: $imageUrl");
        }
      }
    }

    String? selectedDepartmentId;
    String? selectedPositionId;
    return Scaffold(
      body: BlocConsumer<PersionalBloc, PersionalState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "Thêm thành viên thành công.",
                )));
            context.go(RouterName.employeePage);
          } else if (state.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Thêm thành viên không thành công.",
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
                              Container(
                                width: 600,
                                padding:
                                    const EdgeInsets.all(TSizes.defaultSpace),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Form(
                                  key: GlobalKey<FormState>(),
                                  child: Column(
                                    children: [
                                      uploadedImageUrl == null
                                          ? GestureDetector(
                                              onTap: pickAndUploadImage,
                                              child: Container(
                                                height: 200,
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(16),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.grey[200],
                                                ),
                                                child: const Text(
                                                  'Thêm ảnh nhân viên',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            )
                                          : Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    uploadedImageUrl!,
                                                    // width: 100,
                                                    height: 300,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Icon(Icons.person,
                                                            size: 100),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: IconButton(
                                                    icon: const Icon(Icons.edit,
                                                        color: Colors.white),
                                                    onPressed:
                                                        pickAndUploadImage,
                                                  ),
                                                )
                                              ],
                                            ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TTextFormField(
                                        textAlign: true,
                                        text: 'Mã nhân viên',
                                        hint: 'Nhập mã nhân viên',
                                        controller: codeController,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
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
                                        validator: (value) {},
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
                                        menus: educationLevels,
                                        controller: educationLevelController,
                                        text: 'Trình độ',
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TDropDownMenu(
                                          text: 'Trạng thái',
                                          menus: const [
                                            'Đang làm việc',
                                            'Ngừng làm việc',
                                            'Nghỉ việc',
                                          ],
                                          controller: statusController),
                                      const Gap(TSizes.spaceBtwSections),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red,
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
                                                          color: Colors.white),
                                                )),
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
                                              onPressed: state.isLoading
                                                  ? null
                                                  : () {
                                                      print(
                                                          'file: ${uploadedImageUrl}');
                                                      final newEmployee =
                                                          PersionalManagement(
                                                        code:
                                                            codeController.text,
                                                        avatar:
                                                            uploadedImageUrl,
                                                        name: fullNameController
                                                            .text,
                                                        dateOfBirth:
                                                            birthDateController
                                                                .text,
                                                        gender: genderController
                                                            .text,
                                                        positionId:
                                                            selectedPositionId!,
                                                        departmentId:
                                                            selectedDepartmentId!,
                                                        address:
                                                            addressController
                                                                .text,
                                                        phone: phoneController
                                                            .text,
                                                        email: emailController
                                                            .text,
                                                        status: statusController
                                                            .text,
                                                        date:
                                                            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                                        positionName: positions
                                                            .firstWhere((p) =>
                                                                p.id ==
                                                                selectedPositionId)
                                                            .name,
                                                        departmentName: departments
                                                            .firstWhere((d) =>
                                                                d.id ==
                                                                selectedDepartmentId)
                                                            .name,
                                                      );
                                                      context
                                                          .read<PersionalBloc>()
                                                          .add(
                                                              PersionalCreateEvent(
                                                                  newEmployee));
                                                    },
                                              child: state.isLoading
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.white)
                                                  : Text(
                                                      'Thêm nhân viên',
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
