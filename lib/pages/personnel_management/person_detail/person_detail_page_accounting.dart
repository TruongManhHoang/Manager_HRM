import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/layouts/headers/headers.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar_accounting.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar_manager.dart';
import 'package:admin_hrm/common/widgets/layouts/sidebars/sidebar_user.dart';
import 'package:admin_hrm/common/widgets/text_form/text_form_field.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/data/model/department/department_model.dart';
import 'package:admin_hrm/data/model/personnel_management.dart';
import 'package:admin_hrm/data/model/position/position_model.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/account/bloc/account_bloc.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_event.dart';
import 'package:admin_hrm/pages/chatbot/chat_bot.dart';
import 'package:admin_hrm/pages/personnel_management/bloc/persional_bloc.dart';
import 'package:admin_hrm/pages/personnel_management/widgets/build_row_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class PersonDetailPageAccounting extends StatefulWidget {
  const PersonDetailPageAccounting({
    super.key,
  });

  @override
  State<PersonDetailPageAccounting> createState() =>
      _PersonDetailPageAccountingState();
}

class _PersonDetailPageAccountingState
    extends State<PersonDetailPageAccounting> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  final repeatPasswordController = TextEditingController();

  String avatarUrl = '';
  final globalStorage = getIt<GlobalStorage>();
  String accountId = '';
  // Add state variables for password visibility
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureRepeatPassword = true;

  final date = DateTime.now();
  final _globalKey = GlobalKey<FormState>();
  String? currentUser;
  @override
  void initState() {
    super.initState();
    accountId = globalStorage.userId ?? '';
    currentUser = globalStorage.password;
  }

  Widget _buildSidebar() {
    final userRole = globalStorage.role?.toLowerCase().trim() ?? 'employee';

    switch (userRole) {
      case 'kế toán':
        return const SidebarAccounting();
      case 'quản lý':
        return const SidebarManager();
      default:
        return const SidebarUser();
    }
  }

  Future<void> _checkInOut(
      String type, PersionalManagement personalManagers) async {
    final now = DateTime.now();
    final userId = personalManagers.id;
    // Định dạng ngày yyyy-MM-dd để lưu và truy vấn
    final todayStr =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    try {
      // Tìm attendance hôm nay của user
      final query = await FirebaseFirestore.instance
          .collection('attendances')
          .where('userId', isEqualTo: userId)
          .where('date', isEqualTo: todayStr)
          .get();
      final already = query.docs.isNotEmpty ? query.docs.first : null;
      if (type == 'in') {
        if (already != null && already.data().containsKey('checkInTime')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã chấm công vào hôm nay!')),
          );
          return;
        }
        final docRef = already != null
            ? already.reference
            : FirebaseFirestore.instance.collection('attendances').doc();
        await docRef.set({
          'id': docRef.id,
          'userId': userId,
          'userName': personalManagers.name,
          'numberOfHours': 1,
          'date': todayStr,
          'checkInTime': now.toIso8601String(),
        }, SetOptions(merge: true));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chấm công vào thành công!')),
        );
      } else {
        if (already == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bạn chưa chấm công vào!')),
          );
          return;
        }
        if (already.data().containsKey('checkOutTime')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã chấm công ra hôm nay!')),
          );
          return;
        }
        await already.reference.set({
          'checkOutTime': now.toIso8601String(),
        }, SetOptions(merge: true));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chấm công ra thành công!')),
        );
      }
      setState(() {}); // reload lịch sử
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chấm công: $e')),
      );
    }
  }

  String? validatePassword(String? value, {bool isNew = false}) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu${isNew ? ' mới' : ''}';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> _fetchAttendanceHistory(
      String userId) async {
    final result = await FirebaseFirestore.instance
        .collection('attendances')
        .where('userId', isEqualTo: userId)
        // .orderBy('date', descending: true)
        .limit(30)
        .get();
    return result.docs.map((e) => e.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đổi mật khẩu thành công')),
          );
          context.pop();
        } else if (state is AccountError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: Row(
          children: [
            Expanded(child: _buildSidebar()),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const Header(),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Quản lý thông tin nhân viên',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(fontSize: 20),
                                    ),
                                  ],
                                ),
                                Gap(TSizes.spaceBtwItems),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        final state =
                                            context.read<PersionalBloc>().state;
                                        final personal =
                                            state.persionalManagement;
                                        if (personal == null) return;
                                        showDialog(
                                          barrierColor: Colors.transparent,
                                          context: context,
                                          builder: (
                                            context,
                                          ) {
                                            final today = DateTime.now();
                                            final dateStr =
                                                "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
                                            return Dialog(
                                              shadowColor: Colors.black54,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              elevation: 8,
                                              backgroundColor: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24,
                                                        vertical: 28),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue[50],
                                                        shape: BoxShape.circle,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Icon(
                                                          Icons.access_time,
                                                          size: 48,
                                                          color:
                                                              Colors.blue[700]),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      'Chấm công ngày',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      dateStr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .blue[700],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 22),
                                                    ),
                                                    const SizedBox(height: 18),
                                                    SizedBox(
                                                      width: 500,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    ElevatedButton
                                                                        .icon(
                                                                  onPressed:
                                                                      () async {
                                                                    await _checkInOut(
                                                                        'in',
                                                                        personal);
                                                                    context
                                                                        .pop();
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .login,
                                                                      color: Colors
                                                                          .white),
                                                                  label: const Text(
                                                                      'Chấm công vào',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            16),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12)),
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 16),
                                                              Expanded(
                                                                child:
                                                                    ElevatedButton
                                                                        .icon(
                                                                  onPressed:
                                                                      () async {
                                                                    await _checkInOut(
                                                                        'out',
                                                                        personal);
                                                                    context
                                                                        .pop();
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .logout,
                                                                      color: Colors
                                                                          .white),
                                                                  label: const Text(
                                                                      'Chấm công ra',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blue,
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            16),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12)),
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Gap(TSizes
                                                              .spaceBtwItems),
                                                          Center(
                                                            child: ElevatedButton
                                                                .icon(
                                                                    onPressed:
                                                                        () {
                                                                      context
                                                                          .pop();
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .white),
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      fixedSize:
                                                                          const Size(
                                                                              270,
                                                                              40),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                    ),
                                                                    label:
                                                                        const Text(
                                                                      'Hủy',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Gap(
                                                        TSizes.spaceBtwItems),
                                                    Text(
                                                      'Vui lòng xác nhận đúng thời gian thực tế.',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .grey[600]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(10),
                                          backgroundColor: Colors.blue),
                                      child: Text(
                                        'Chấm công',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    Gap(10),
                                    ElevatedButton(
                                        onPressed: () {
                                          final parentContext = context;
                                          showDialog(
                                              barrierColor: Colors.transparent,
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return FractionallySizedBox(
                                                        widthFactor: 0.45,
                                                        child: Dialog(
                                                          shadowColor:
                                                              Colors.black54,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          elevation: 8,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        24,
                                                                    vertical:
                                                                        28),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .blue[50],
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16),
                                                                  child: Icon(
                                                                      Iconsax
                                                                          .password_check,
                                                                      size: 48,
                                                                      color: Colors
                                                                              .blue[
                                                                          700]),
                                                                ),
                                                                const SizedBox(
                                                                    height: 16),
                                                                Text(
                                                                  'Đổi mật khẩu',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium
                                                                      ?.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                ),
                                                                const SizedBox(
                                                                    height: 4),
                                                                Form(
                                                                  key:
                                                                      _globalKey,
                                                                  child: Column(
                                                                    children: [
                                                                      TTextFormField(
                                                                        hint:
                                                                            'Nhập mật khẩu cũ',
                                                                        text:
                                                                            'Mật khẩu cũ',
                                                                        textAlign:
                                                                            true,
                                                                        controller:
                                                                            oldPasswordController,
                                                                        obscureText:
                                                                            _obscureOldPassword,
                                                                        suffixIcon:
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            _obscureOldPassword
                                                                                ? Icons.visibility_off
                                                                                : Icons.visibility,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              _obscureOldPassword = !_obscureOldPassword;
                                                                            });
                                                                          },
                                                                        ),
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Vui lòng nhập mật khẩu cũ';
                                                                          }
                                                                          if (value.length <
                                                                              6) {
                                                                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),
                                                                      const Gap(
                                                                          TSizes
                                                                              .spaceBtwItems),
                                                                      TTextFormField(
                                                                        hint:
                                                                            'Nhập mật khẩu mới',
                                                                        text:
                                                                            'Mật khẩu mới',
                                                                        textAlign:
                                                                            true,
                                                                        controller:
                                                                            newPasswordController,
                                                                        obscureText:
                                                                            _obscureNewPassword,
                                                                        suffixIcon:
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            _obscureNewPassword
                                                                                ? Icons.visibility_off
                                                                                : Icons.visibility,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              _obscureNewPassword = !_obscureNewPassword;
                                                                            });
                                                                          },
                                                                        ),
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Vui lòng nhập mật khẩu mới';
                                                                          }
                                                                          if (value.length <
                                                                              6) {
                                                                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                                                                          }
                                                                          if (oldPasswordController.text.isNotEmpty &&
                                                                              value == oldPasswordController.text) {
                                                                            return 'Mật khẩu mới không được trùng với mật khẩu cũ';
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),
                                                                      const Gap(
                                                                          TSizes
                                                                              .spaceBtwItems),
                                                                      TTextFormField(
                                                                        hint:
                                                                            'Nhập lại mật khẩu mới',
                                                                        text:
                                                                            'Mật khẩu nhập lại',
                                                                        textAlign:
                                                                            true,
                                                                        controller:
                                                                            repeatPasswordController,
                                                                        obscureText:
                                                                            _obscureRepeatPassword,
                                                                        suffixIcon:
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            _obscureRepeatPassword
                                                                                ? Icons.visibility_off
                                                                                : Icons.visibility,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              _obscureRepeatPassword = !_obscureRepeatPassword;
                                                                            });
                                                                          },
                                                                        ),
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Vui lòng nhập lại mật khẩu mới';
                                                                          }
                                                                          if (value !=
                                                                              newPasswordController.text) {
                                                                            return 'Mật khẩu nhập lại không khớp với mật khẩu mới';
                                                                          }
                                                                          if (value.length <
                                                                              6) {
                                                                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Gap(TSizes
                                                                    .spaceBtwSections),
                                                                SizedBox(
                                                                  width: 500,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ElevatedButton(
                                                                              onPressed: () {
                                                                                context.pop();
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.red,
                                                                              ),
                                                                              child: Text(
                                                                                'Hủy',
                                                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                                                                              ))),
                                                                      const Gap(
                                                                          10),
                                                                      Expanded(
                                                                        child: ElevatedButton(
                                                                            onPressed: () {
                                                                              if (_globalKey.currentState!.validate()) {
                                                                                if (newPasswordController.text != repeatPasswordController.text) {
                                                                                  ScaffoldMessenger.of(parentContext).showSnackBar(
                                                                                    const SnackBar(content: Text('Mật khẩu mới và nhập lại không trùng khớp!')),
                                                                                  );
                                                                                  return;
                                                                                }
                                                                                // Kiểm tra mật khẩu cũ phải đúng

                                                                                if (oldPasswordController.text != (currentUser)) {
                                                                                  ScaffoldMessenger.of(parentContext).showSnackBar(
                                                                                    const SnackBar(content: Text('Mật khẩu cũ không đúng!')),
                                                                                  );
                                                                                  return;
                                                                                }
                                                                                parentContext.read<AccountBloc>().add(
                                                                                      ChangePasswordAccount(
                                                                                        accountId,
                                                                                        newPasswordController.text,
                                                                                      ),
                                                                                    );
                                                                                parentContext.read<AuthBloc>().add(
                                                                                      ChangePasswordRequested(newPasswordController.text),
                                                                                    );
                                                                              }
                                                                              if (state is AccountSuccess) {
                                                                                oldPasswordController.clear();
                                                                                newPasswordController.clear();
                                                                                repeatPasswordController.clear();
                                                                              }
                                                                            },
                                                                            child: state is AccountLoading
                                                                                ? const CircularProgressIndicator()
                                                                                : Text(
                                                                                    'Đổi mật khẩu',
                                                                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                                                                                  )),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ));
                                                  },
                                                );
                                              });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(10),
                                        ),
                                        child: Text(
                                          'Đổi mật khẩu',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        )),
                                  ],
                                ),
                                const Gap(20),
                                Center(
                                  child: BlocBuilder<PersionalBloc,
                                      PersionalState>(
                                    builder: (context, state) {
                                      final personal =
                                          state.persionalManagement;
                                      final globalStorage =
                                          getIt<GlobalStorage>();
                                      PositionModel? position;
                                      try {
                                        position =
                                            globalStorage.positions?.firstWhere(
                                          (e) => e.id == personal!.positionId,
                                        );
                                      } catch (e) {
                                        position = null;
                                      }

                                      DepartmentModel? department;
                                      try {
                                        department = globalStorage.departments
                                            ?.firstWhere(
                                          (e) => e.id == personal!.departmentId,
                                        );
                                      } catch (e) {
                                        department = null;
                                      }
                                      if (state.isLoading) {
                                        return const CircularProgressIndicator();
                                      } else if (state.isSuccess &&
                                          personal != null) {
                                        return Container(
                                          width: 750,
                                          padding: const EdgeInsets.all(
                                              TSizes.defaultSpace),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Thông tin chi tiết nhân viên',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall!
                                                    .copyWith(fontSize: 18),
                                              ),
                                              const Gap(
                                                  TSizes.spaceBtwSections),
                                              Center(
                                                  child: Image.network(
                                                personal.avatar ?? '',
                                                width: 220,
                                                height: 270,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Icon(Icons.person,
                                                        size: 100),
                                              )),
                                              const Gap(
                                                  TSizes.spaceBtwSections),
                                              BuildRowItem(
                                                  label1: 'Mã nhân viên: ',
                                                  text1: personal.code ?? '',
                                                  label2: 'Họ và tên: ',
                                                  text2: personal.name),
                                              const Gap(TSizes.spaceBtwItems),
                                              BuildRowItem(
                                                  label1: 'Giới tính: ',
                                                  text1: personal.gender,
                                                  label2: 'Ngày sinh: ',
                                                  text2: personal.dateOfBirth),
                                              const Gap(TSizes.spaceBtwItems),
                                              BuildRowItem(
                                                  label1: 'Email: ',
                                                  text1: personal.email,
                                                  label2: 'Số điện thoại: ',
                                                  text2: personal.phone),
                                              const Gap(TSizes.spaceBtwItems),
                                              BuildRowItem(
                                                  label1: 'Chức vụ: ',
                                                  text1: position?.name ??
                                                      'Không xác định',
                                                  label2: 'Phòng ban: ',
                                                  text2: department?.name ??
                                                      'Không xác định'),
                                              const Gap(TSizes.spaceBtwItems),
                                              BuildRowItem(
                                                  label1: 'Trạng thái: ',
                                                  text1: personal.status ?? '',
                                                  label2: 'Ngày tạo: ',
                                                  text2: personal.date),
                                              const Gap(
                                                  TSizes.spaceBtwSections),
                                              Text('Lịch sử chấm công',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium),
                                              FutureBuilder<
                                                  List<Map<String, dynamic>>>(
                                                future: _fetchAttendanceHistory(
                                                    personal.id!),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  }
                                                  final data =
                                                      snapshot.data ?? [];
                                                  if (data.isEmpty) {
                                                    return const Text(
                                                        'Chưa có lịch sử chấm công');
                                                  }
                                                  return SizedBox(
                                                    height: 200,
                                                    child: ListView.separated(
                                                      itemCount: data.length,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      separatorBuilder:
                                                          (_, __) =>
                                                              const Divider(),
                                                      itemBuilder:
                                                          (context, idx) {
                                                        final att = data[idx];
                                                        return ListTile(
                                                          title: Text(
                                                              'Ngày: ${att['date'] ?? ''}'),
                                                          subtitle: Text(
                                                            'Vào: ${att['checkInTime'] != null ? att['checkInTime'].toString().substring(11, 19) : '-'}  |  Ra: ${att['checkOutTime'] != null ? att['checkOutTime'].toString().substring(11, 19) : '-'}',
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return const Text('Không có dữ liệu');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Chatbot floating button
                        Positioned(
                          bottom: 32,
                          right: 32, // Đổi từ left sang right để nằm góc phải
                          child: ChatBotFloatingButton(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
      },
    );
  }
}
