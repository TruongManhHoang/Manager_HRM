import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/kpi/kpi_metric/kpi_metric.dart';
import 'package:admin_hrm/data/model/kpi/kpi_model.dart';
import 'package:admin_hrm/data/model/personnel_management.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_bloc.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_event.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_state.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class KPIFormPage extends StatefulWidget {
  const KPIFormPage({super.key, this.initialKPI});
  final KPIModel? initialKPI;

  @override
  State<KPIFormPage> createState() => _KPIFormPageState();
}

class _KPIFormPageState extends State<KPIFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _departmentIdController = TextEditingController();
  final _periodController = TextEditingController();
  final _evaluatorIdController = TextEditingController();
  final _notesController = TextEditingController();
  final _targetScoreController = TextEditingController();

  List<PersionalManagement> _users = [];
  String? _selectedUserId;
  String? _selectedStatus = 'Đang đánh giá';
  List<KPIMetric> _metrics = [];

  final List<String> _statusOptions = [
    'Đang đánh giá',
    'Đã hoàn thành',
    'Cần cải thiện',
    'Xuất sắc'
  ];

  bool _isLoadingUsers = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('personnel').get();
    setState(() {
      _users = snapshot.docs
          .map((doc) => PersionalManagement.fromJson(doc.data()))
          .toList();
      _isLoadingUsers = false;
    });

    if (widget.initialKPI != null) {
      final initial = widget.initialKPI!;
      final matchedUser = _users.firstWhere(
        (u) => u.code == initial.userId,
        orElse: () => _users.first,
      );
      _selectedUserId = matchedUser.id;
      _departmentIdController.text = matchedUser.departmentId;
      _periodController.text = initial.period;
      _evaluatorIdController.text = initial.evaluatorId ?? '';
      _notesController.text = initial.notes ?? '';
      _metrics = List<KPIMetric>.from(initial.metrics);
    }
  }

  double _calculateTotalScore() {
    return _metrics.fold(0.0, (sum, m) => sum + m.score * m.weight);
  }

  void _addMetricField() {
    setState(() {
      _metrics.add(KPIMetric(name: '', description: '', weight: 0, score: 0));
    });
  }

  void _removeMetricField(int index) {
    setState(() {
      _metrics.removeAt(index);
    });
  }

  void _submitForm() {
    final selectedUser = _users.firstWhere((u) => u.id == _selectedUserId);
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final newKPI = KPIModel(
        id: widget.initialKPI?.id ?? '',
        userId: selectedUser.id ?? '',
        departmentId: selectedUser.departmentId,
        period: _periodController.text,
        metrics: _metrics,
        totalScore: _calculateTotalScore(),
        evaluatorId: _evaluatorIdController.text.isNotEmpty
            ? _evaluatorIdController.text
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        createdAt: widget.initialKPI?.createdAt ?? now,
        updatedAt: now,
      );
      if (widget.initialKPI != null) {
        BlocProvider.of<KPIBloc>(context).add(UpdateKPI(newKPI));
      } else {
        BlocProvider.of<KPIBloc>(context).add(AddKPI(newKPI));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KPIBloc, KPIState>(
      listener: (context, state) {
        if (state is KPISuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Lưu thành công')));
          context.pop(true);
        } else if (state is KPIError) {
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
                    Expanded(
                      child: Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const TBreadcrumsWithHeading(
                                heading: 'KPI',
                                breadcrumbItems: [RouterName.addKpi],
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
                                      _isLoadingUsers
                                          ? const CircularProgressIndicator()
                                          : DropdownButtonFormField<String>(
                                              value: _selectedUserId,
                                              decoration: const InputDecoration(
                                                  labelText: 'Chọn nhân sự'),
                                              items: _users.map((user) {
                                                return DropdownMenuItem<String>(
                                                  value: user.id,
                                                  child: Text(
                                                      '${user.name} (${user.code})'),
                                                );
                                              }).toList(),
                                              onChanged: (userId) {
                                                final selected =
                                                    _users.firstWhere(
                                                        (u) => u.id == userId);
                                                setState(() {
                                                  _selectedUserId = selected.id;
                                                  _departmentIdController.text =
                                                      selected.departmentId;
                                                });
                                              },
                                              validator: (value) =>
                                                  value == null
                                                      ? 'Vui lòng chọn nhân sự'
                                                      : null,
                                            ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TextFormField(
                                        controller: _departmentIdController,
                                        decoration: const InputDecoration(
                                            labelText: 'Phòng ban'),
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TextFormField(
                                        controller: _periodController,
                                        decoration: const InputDecoration(
                                            labelText:
                                                'Thời gian (VD: 05/2024)'),
                                        validator: (value) =>
                                            value!.isEmpty ? 'Bắt buộc' : null,
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      // Thêm trường mục tiêu điểm số
                                      TextFormField(
                                        controller: _targetScoreController,
                                        decoration: const InputDecoration(
                                            labelText: 'Mục tiêu điểm số'),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true)
                                            return 'Bắt buộc';
                                          if (double.tryParse(value!) == null)
                                            return 'Phải là số';
                                          return null;
                                        },
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      // Thêm dropdown trạng thái
                                      DropdownButtonFormField<String>(
                                        value: _selectedStatus,
                                        decoration: const InputDecoration(
                                            labelText: 'Trạng thái'),
                                        items: _statusOptions.map((status) {
                                          return DropdownMenuItem<String>(
                                            value: status,
                                            child: Text(status),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedStatus = value;
                                          });
                                        },
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Chỉ số KPI',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextButton.icon(
                                            onPressed: _addMetricField,
                                            icon: const Icon(Icons.add),
                                            label: const Text('Thêm chỉ số'),
                                          )
                                        ],
                                      ),
                                      // Hiển thị tổng điểm hiện tại
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color:
                                                  Colors.blue.withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Tổng điểm hiện tại:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(
                                                '${_calculateTotalScore().toStringAsFixed(1)} điểm',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                      ..._metrics.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final metric = entry.value;
                                        return Card(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  initialValue: metric.name,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              'Tên chỉ số'),
                                                  onChanged: (val) =>
                                                      _metrics[index] =
                                                          _metrics[index]
                                                              .copyWith(
                                                                  name: val),
                                                  validator: (value) =>
                                                      value!.isEmpty
                                                          ? 'Bắt buộc'
                                                          : null,
                                                ),
                                                const Gap(TSizes.spaceBtwItems),
                                                TextFormField(
                                                  initialValue:
                                                      metric.description,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Mô tả'),
                                                  onChanged: (val) =>
                                                      _metrics[index] =
                                                          _metrics[index]
                                                              .copyWith(
                                                                  description:
                                                                      val),
                                                ),
                                                const Gap(TSizes.spaceBtwItems),
                                                TextFormField(
                                                  initialValue:
                                                      metric.weight.toString(),
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              'Trọng số'),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (val) => _metrics[
                                                          index] =
                                                      _metrics[index].copyWith(
                                                          weight:
                                                              double.tryParse(
                                                                      val) ??
                                                                  0),
                                                  validator: (value) {
                                                    if (value?.isEmpty ?? true)
                                                      return 'Bắt buộc';
                                                    final weight =
                                                        double.tryParse(value!);
                                                    if (weight == null)
                                                      return 'Phải là số';
                                                    if (weight <= 0)
                                                      return 'Phải > 0';
                                                    if (weight > 1)
                                                      return 'Phải ≤ 1.0';
                                                    return null;
                                                  },
                                                ),
                                                const Gap(8),
                                                TextFormField(
                                                  initialValue:
                                                      metric.score.toString(),
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Điểm số'),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (val) => _metrics[
                                                          index] =
                                                      _metrics[index].copyWith(
                                                          score:
                                                              double.tryParse(
                                                                      val) ??
                                                                  0),
                                                  validator: (value) {
                                                    if (value?.isEmpty ?? true)
                                                      return 'Bắt buộc';
                                                    final score =
                                                        double.tryParse(value!);
                                                    if (score == null)
                                                      return 'Phải là số';
                                                    if (score < 0)
                                                      return 'Phải ≥ 0';
                                                    if (score > 100)
                                                      return 'Phải ≤ 100';
                                                    return null;
                                                  },
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.delete_forever,
                                                        color: Colors.red),
                                                    onPressed: () =>
                                                        _removeMetricField(
                                                            index),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      const Gap(TSizes.spaceBtwItems),
                                      TextFormField(
                                        controller: _evaluatorIdController,
                                        decoration: const InputDecoration(
                                            labelText: 'Người đánh giá'),
                                      ),
                                      const Gap(TSizes.spaceBtwItems),
                                      TextFormField(
                                        controller: _notesController,
                                        decoration: const InputDecoration(
                                            labelText: 'Ghi chú'),
                                        maxLines: 3,
                                      ),
                                      const Gap(TSizes.spaceBtwSections),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  TSizes.defaultSpace * 2,
                                              vertical: 16,
                                            ),
                                          ),
                                          onPressed: _submitForm,
                                          child: Text(widget.initialKPI != null
                                              ? 'Sửa KPI'
                                              : 'Thêm KPI'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
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
