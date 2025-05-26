part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAccounts extends AccountEvent {}

class AddAccount extends AccountEvent {
  final AccountModel account;

  AddAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class UpdateAccount extends AccountEvent {
  final AccountModel account;

  UpdateAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class ChangePasswordAccount extends AccountEvent {
  final String userId;
  final String password;

  ChangePasswordAccount(this.userId, this.password);

  @override
  List<Object?> get props => [password];
}

class DeleteAccount extends AccountEvent {
  final String accountId;

  DeleteAccount(this.accountId);

  @override
  List<Object?> get props => [accountId];
}
