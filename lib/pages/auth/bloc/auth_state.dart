import 'package:admin_hrm/data/model/account/account_model.dart';
import 'package:admin_hrm/data/model/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AccountModel accountModel;
  AuthSuccess(this.accountModel);

  @override
  List<Object?> get props => [accountModel];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordSent extends AuthState {}
