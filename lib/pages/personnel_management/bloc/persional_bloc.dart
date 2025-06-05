import 'dart:io';

import 'package:admin_hrm/data/repository/department_repository.dart';
import 'package:admin_hrm/data/repository/persional_repository.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/model/personnel_management.dart';

part 'persional_event.dart';
part 'persional_state.dart';

class PersionalBloc extends Bloc<PersionalEvent, PersionalState> {
  final PersionalRepository personnelRepository;
  final DepartmentRepository departmentRepository;
  final GlobalStorage globalStorage;
  PersionalBloc(
      {required this.personnelRepository,
      required this.globalStorage,
      required this.departmentRepository})
      : super(const PersionalState()) {
    on<PersionalCreateEvent>(_onCreateEvent);
    on<PersionalLoadEvent>(_onLoadEvent);
    on<PersionalUpdateEvent>(_onUpdateEvent);
    on<PersionalDeleteEvent>(_onDeleteEvent);
    on<PersonalFetchEvent>(_onPersonalFetchEvent);
    on<SearchPersionalEvent>(_onSearchPersionalEvent);
    on<FilterPersionalByStatusEvent>(_onFilterPersionalByStatusEvent);
  }

  String removeDiacritics(String text) {
    const vietnamese =
        'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
    const normalized =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuuuuuuuyyyyyd';

    String result = text.toLowerCase();

    for (int i = 0; i < vietnamese.length; i++) {
      result = result.replaceAll(vietnamese[i], normalized[i]);
    }

    return result;
  }

  void _onFilterPersionalByStatusEvent(
      FilterPersionalByStatusEvent event, Emitter<PersionalState> emit) {
    if (event.status == 'Tất cả') {
      emit(state.copyWith(personnel: globalStorage.personalManagers));
    } else {
      final filtered = globalStorage.personalManagers
          ?.where((p) => p.status == event.status)
          .toList();
      emit(state.copyWith(personnel: filtered));
    }
  }

  void _onSearchPersionalEvent(
      SearchPersionalEvent event, Emitter<PersionalState> emit) {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    try {
      // ✅ LUÔN TÌM KIẾM TRONG DANH SÁCH GỐC
      final allPersonnel = globalStorage.personalManagers ?? [];

      // Nếu query rỗng, trả lại toàn bộ danh sách gốc
      if (event.query.trim().isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          personnel: allPersonnel, // ✅ Trả về danh sách gốc
        ));
        return;
      }

      // ✅ Chuyển đổi query thành không dấu
      final normalizedQuery = removeDiacritics(event.query.trim());

      // ✅ TÌM KIẾM TRONG DANH SÁCH GỐC, KHÔNG PHẢI state.personnel
      final personnel = allPersonnel.where((p) {
        // ✅ Tìm kiếm theo tên (có dấu và không dấu)
        final originalName = p.name.toLowerCase();
        final normalizedName = removeDiacritics(p.name);
        final nameMatch = originalName.contains(event.query.toLowerCase()) ||
            normalizedName.contains(normalizedQuery);

        // ✅ Tìm kiếm theo mã nhân viên (có dấu và không dấu)
        final originalCode = (p.code ?? '').toLowerCase();
        final normalizedCode = removeDiacritics(p.code ?? '');
        final codeMatch = originalCode.contains(event.query.toLowerCase()) ||
            normalizedCode.contains(normalizedQuery);

        // ✅ Tìm kiếm theo email (nếu có)
        final emailMatch =
            (p.email ?? '').toLowerCase().contains(event.query.toLowerCase());

        // ✅ Tìm kiếm theo số điện thoại (nếu có)
        final phoneMatch = (p.phone ?? '').contains(event.query);

        return nameMatch || codeMatch || emailMatch || phoneMatch;
      }).toList();

      emit(state.copyWith(
          isLoading: false, isSuccess: true, personnel: personnel));
    } catch (e) {
      emit(state.copyWith(
          isSuccess: false, isFailure: true, errorMessage: e.toString()));
    }
  }

  void _onPersonalFetchEvent(
      PersonalFetchEvent event, Emitter<PersionalState> emit) {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    try {
      final personal = globalStorage.personalModel;

      emit(state.copyWith(
          isLoading: false, isSuccess: true, persionalManagement: personal));
    } catch (e) {
      emit(state.copyWith(
          isSuccess: false, isFailure: true, errorMessage: e.toString()));
    }
  }

  void _onCreateEvent(
      PersionalCreateEvent event, Emitter<PersionalState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      await personnelRepository.createPersonnel(event.personnelManagement);
      final departmentId = event.personnelManagement.departmentId;
      if (departmentId != null && departmentId.isNotEmpty) {
        await departmentRepository.increaseEmployeeCount(departmentId);
      }
      add(const PersionalLoadEvent());
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, errorMessage: e.toString()));
    }
  }

  void _onLoadEvent(
      PersionalLoadEvent event, Emitter<PersionalState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      final personnel = await personnelRepository.getAllPersonnel();

      globalStorage.fetchAllPersonalManagers(personnel);
      emit(state.copyWith(
          isLoading: false, personnel: personnel, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, errorMessage: e.toString()));
    }
  }

  void _onUpdateEvent(
      PersionalUpdateEvent event, Emitter<PersionalState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      await personnelRepository.updatePersional(event.personnelManagement);
      final newDeptId = event.personnelManagement.departmentId;
      final oldDeptId = event.oldDepartmentId;

      if (oldDeptId != null && oldDeptId != newDeptId) {
        // Giảm số lượng nhân viên phòng cũ
        await departmentRepository.decreaseEmployeeCount(oldDeptId);

        // Tăng số lượng nhân viên phòng mới
        if (newDeptId != null && newDeptId.isNotEmpty) {
          await departmentRepository.increaseEmployeeCount(newDeptId);
        }
      }
      add(const PersionalLoadEvent());
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, errorMessage: e.toString()));
    }
  }

  void _onDeleteEvent(
      PersionalDeleteEvent event, Emitter<PersionalState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      await personnelRepository.deletePersonnel(event.id);
      final departmentId = event.departmentId;
      if (departmentId != null && departmentId.isNotEmpty) {
        await departmentRepository.decreaseEmployeeCount(departmentId);
      }

      add(const PersionalLoadEvent());
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, errorMessage: e.toString()));
    }
  }

  Future<String?> uploadImageToFirebase(XFile file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final avatarRef = storageRef.child(
          'avatars/${DateTime.now().millisecondsSinceEpoch}_${file.name}');
      final uploadTask = await avatarRef.putFile(File(file.path));
      final downloadUrl = await avatarRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
