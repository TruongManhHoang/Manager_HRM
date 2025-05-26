// add_employee_cubit.dart

import 'dart:io';

import 'package:admin_hrm/data/repository/department_repository.dart';
import 'package:admin_hrm/data/repository/persional_repository.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
