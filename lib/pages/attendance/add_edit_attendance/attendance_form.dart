import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

import 'package:admin_hrm/pages/attendance/bloc/attendance_bloc.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_event.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_state.dart';
import 'package:admin_hrm/data/model/attendance/attendance_model.dart';

class AttendanceForm extends StatefulWidget {
  final AttendanceModel? attendance;
  const AttendanceForm({super.key, this.attendance});

  @override
  State<AttendanceForm> createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  final _formKey = GlobalKey<FormState>();
  final userIdCtrl = TextEditingController();
  final userNameCtrl = TextEditingController();
  final workLocationCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  DateTime date = DateTime.now();
  DateTime? checkInTime;
  DateTime? checkOutTime;
  bool isLate = false;
  bool isAbsent = false;

  List<Map<String, String>> personnelList = [];
  bool isLoadingPersonnel = true;
  String? selectedPersonalId;
  final globalStorage = getIt<GlobalStorage>();
  late final personnels = globalStorage.personalManagers;
  @override
  void initState() {
    super.initState();
    // _loadPersonnel();
    if (personnels!.isNotEmpty) {
      final first = personnels!.first;
      selectedPersonalId = first.id;
      userIdCtrl.text = first.id!;
      userNameCtrl.text = first.name ?? '';
    }
    if (widget.attendance != null) {
      final a = widget.attendance!;
      userIdCtrl.text = a.userId;
      userNameCtrl.text = a.userName ?? '';
      workLocationCtrl.text = a.workLocation ?? '';
      notesCtrl.text = a.notes ?? '';
      date = DateTime.parse(a.date!);
      checkInTime = a.checkInTime;
      checkOutTime = a.checkOutTime;
      isLate = a.isLate;
      isAbsent = a.isAbsent;
    }
  }

  // Future<void> _loadPersonnel() async {
  //   final snapshot =
  //       await FirebaseFirestore.instance.collection('personnel').get();

  //   personnelList = snapshot.docs.map((doc) {
  //     final data = doc.data();
  //     return {
  //       'id': data['id'] as String,
  //       'name': data['name'] as String,
  //     };
  //   }).toList();

  //   setState(() {
  //     isLoadingPersonnel = false;
  //   });
  // }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => date = picked);
  }

  Future<void> _pickTime({required bool isCheckIn}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      final dt =
          DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
      setState(() {
        if (isCheckIn) {
          checkInTime = dt;
        } else {
          checkOutTime = dt;
        }
      });
    }
  }

  double? calculateWorkingUnit(DateTime? checkInTime, DateTime? checkOutTime) {
    if (checkInTime != null && checkOutTime != null) {
      final totalMinutes = checkOutTime.difference(checkInTime).inMinutes;
      final hours = totalMinutes / 60.0;

      final workingUnit = hours / 8.0;

      // Giới hạn tối đa là 1 công
      return workingUnit.clamp(0.0, 1.0);
    }

    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final model = AttendanceModel(
      id: widget.attendance?.id ?? '',
      userId: selectedPersonalId ?? '',
      userName: userNameCtrl.text.trim(),
      date: date.toIso8601String().substring(0, 10),
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      workLocation: workLocationCtrl.text.trim(),
      numberOfHours: calculateWorkingUnit(checkInTime, checkOutTime),
      notes: notesCtrl.text.trim(),
      isLate: isLate,
      isAbsent: isAbsent,
      createdAt: widget.attendance?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final bloc = context.read<AttendanceBloc>();
    if (widget.attendance != null) {
      bloc.add(UpdateAttendance(model));
    } else {
      bloc.add(AddAttendance(model));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Lưu thành công')));
          context.pop(true);
        } else if (state is AttendanceError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const TBreadcrumsWithHeading(
                              heading: 'Chấm công',
                              breadcrumbItems: [RouterName.addAttendance],
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
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Nhân viên',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        const Gap(TSizes.spaceBtwItems),
                                        DropdownMenu(
                                          initialSelection: userIdCtrl.text,
                                          controller: userIdCtrl,
                                          width: 200,
                                          trailingIcon:
                                              const Icon(Icons.arrow_drop_down),
                                          dropdownMenuEntries: personnels!
                                              .map((personal) =>
                                                  DropdownMenuEntry<String>(
                                                    label: personal.name!,
                                                    value: personal.id!,
                                                  ))
                                              .toList(),
                                          onSelected: (value) {
                                            setState(() {
                                              selectedPersonalId = value;
                                              final selected = personnels!
                                                  .firstWhere(
                                                      (e) => e.id == value);
                                              userNameCtrl.text =
                                                  selected.name ?? '';
                                            });
                                          },
                                          hintText: 'Chọn nhân viên',
                                        ),
                                      ],
                                    ),
                                    const Gap(8),
                                    TextFormField(
                                      controller: userNameCtrl,
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                          labelText:
                                              'Tên nhân viên (tự động điền)'),
                                    ),
                                    const Gap(8),
                                    ListTile(
                                      title: Text(
                                          'Ngày: ${date.toLocal().toString().split(' ')[0]}'),
                                      trailing:
                                          const Icon(Icons.calendar_today),
                                      onTap: _pickDate,
                                    ),
                                    ListTile(
                                      title: Text(checkInTime != null
                                          ? 'Giờ vào: ${TimeOfDay.fromDateTime(checkInTime!).format(context)}'
                                          : 'Chọn giờ vào'),
                                      trailing: const Icon(Icons.access_time),
                                      onTap: () => _pickTime(isCheckIn: true),
                                    ),
                                    ListTile(
                                      title: Text(checkOutTime != null
                                          ? 'Giờ ra: ${TimeOfDay.fromDateTime(checkOutTime!).format(context)}'
                                          : 'Chọn giờ ra'),
                                      trailing: const Icon(Icons.access_time),
                                      onTap: () => _pickTime(isCheckIn: false),
                                    ),
                                    TextFormField(
                                      controller: workLocationCtrl,
                                      decoration: const InputDecoration(
                                          labelText: 'Địa điểm làm việc'),
                                    ),
                                    const Gap(8),
                                    TextFormField(
                                      controller: notesCtrl,
                                      decoration: const InputDecoration(
                                          labelText: 'Ghi chú'),
                                      maxLines: 2,
                                    ),
                                    const Gap(8),
                                    Row(
                                      children: [
                                        Checkbox(
                                            value: isLate,
                                            onChanged: (v) => setState(
                                                () => isLate = v ?? false)),
                                        const Text('Đi trễ'),
                                        const Gap(20),
                                        Checkbox(
                                            value: isAbsent,
                                            onChanged: (v) => setState(
                                                () => isAbsent = v ?? false)),
                                        const Text('Vắng mặt'),
                                      ],
                                    ),
                                    const Gap(16),
                                    ElevatedButton(
                                        onPressed: _submit,
                                        child: widget.attendance != null
                                            ? const Text('Sửa chấm công')
                                            : const Text('Thêm chấm công')),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
