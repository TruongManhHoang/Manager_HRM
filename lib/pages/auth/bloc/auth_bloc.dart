import 'package:admin_hrm/data/repository/user_repository.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../local/storage.dart';
import '../../../service/auth_service.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final UserRepository userRepository;
  final GlobalStorage globalStorage;

  AuthBloc(
      {required this.authService,
      required this.userRepository,
      required this.globalStorage})
      : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final credential =
            await authService.signIn(event.email, event.password);
        final user = credential.user;
        if (user == null) {
          emit(AuthFailure("Không tìm thấy người dùng."));
          return;
        }

        final appUser = await userRepository.fetchUserProfile();

        final personal =
            await userRepository.fetchPersonalProfile(appUser.employeeId);

        await globalStorage.updateAuthenticationState(
          displayName: appUser.name,
          role: appUser.role,
          userId: appUser.id,
          password: appUser.password,
        );

        await globalStorage.addPersonalModel(personal);
        emit(AuthSuccess(appUser));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<ChangePasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.changePassword(event.newPassword);
        // emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<DeleteAccountRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.deleteUserByUid(event.accountId);
        // emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final credential = await authService.signUp(
          accountModel: event.accountModel,
        );
        debugPrint('User registered successfully: ${credential.user}');
        final appUser = await userRepository.fetchUserProfile();
        // await StorageLocal.saveUser(appUser);
        emit(AuthSuccess(appUser));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.sendPasswordResetEmail(event.email);
        emit(ForgotPasswordSent());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.signOut();
        await globalStorage.clearAuthenticationState();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthStarted>((event, emit) async {
      emit(AuthLoading());
      try {
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          final appUser = await userRepository.fetchUserProfile();

          emit(AuthSuccess(appUser));
        } else {
          emit(AuthFailure("Chưa đăng nhập"));
        }
      } catch (e) {
        emit(AuthFailure("Lỗi load user: ${e.toString()}"));
      }
    });
  }
}
