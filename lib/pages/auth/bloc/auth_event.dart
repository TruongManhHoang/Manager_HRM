import 'package:admin_hrm/data/model/account/account_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email, password;

  LoginRequested(this.email, this.password);
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested(this.email);
}

class RegisterRequested extends AuthEvent {
  AccountModel accountModel;
  RegisterRequested(this.accountModel);
}

class ChangePasswordRequested extends AuthEvent {
  final String newPassword;
  ChangePasswordRequested(this.newPassword);
}

class DeleteAccountRequested extends AuthEvent {
  final String accountId;
  DeleteAccountRequested(this.accountId);
}

class LogoutRequested extends AuthEvent {}

class AuthStarted extends AuthEvent {}
