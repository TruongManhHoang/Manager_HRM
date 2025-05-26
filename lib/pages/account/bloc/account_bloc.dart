import 'package:admin_hrm/data/model/account/account_model.dart';
import 'package:admin_hrm/data/repository/account_repository.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;

  AccountBloc({
    required this.repository,
  }) : super(AccountInitial()) {
    on<LoadAccounts>(_onLoadAccounts);
    on<AddAccount>(_onAddAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<ChangePasswordAccount>(_onChangePasswordAccount);
  }

  Future<void> _onLoadAccounts(
      LoadAccounts event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      debugPrint('Loading accounts...');
      final accounts = await repository.getAllAccounts();

      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError('Không thể tải danh sách tài khoản'));
    }
  }

  Future<void> _onChangePasswordAccount(
      ChangePasswordAccount event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      debugPrint('Changing password for account...');
      debugPrint('User ID: ${event.userId}');
      debugPrint('New Password: ${event.password}');
      await repository.changePassword(event.password, event.userId);
      emit(AccountSuccess());
    } catch (e) {
      emit(AccountError('Đổi mật khẩu thất bại'));
    }
  }

  Future<void> _onAddAccount(
      AddAccount event, Emitter<AccountState> emit) async {
    try {
      debugPrint('Adding account: ${event.account}');
      await repository.addAccount(event.account);

      emit(AccountSuccess());
      add(LoadAccounts());
    } catch (e) {
      emit(AccountError('Thêm tài khoản thất bại'));
    }
  }

  Future<void> _onUpdateAccount(
      UpdateAccount event, Emitter<AccountState> emit) async {
    try {
      debugPrint('Updating account: ${event.account}');
      await repository.updateAccount(event.account);
      emit(AccountSuccess());
      add(LoadAccounts());
    } catch (e) {
      emit(AccountError('Cập nhật tài khoản thất bại'));
    }
  }

  Future<void> _onDeleteAccount(
      DeleteAccount event, Emitter<AccountState> emit) async {
    try {
      await repository.deleteAccount(event.accountId);
      emit(AccountSuccess());
      add(LoadAccounts());
    } catch (e) {
      emit(AccountError('Xóa tài khoản thất bại'));
    }
  }
}
