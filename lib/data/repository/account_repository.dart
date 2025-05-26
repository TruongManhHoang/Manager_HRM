import 'package:admin_hrm/data/model/account/account_model.dart';
import 'package:admin_hrm/service/account_service.dart';

class AccountRepository {
  final AccountService accountService;
  AccountRepository({required this.accountService});

  Future<List<AccountModel>> getAllAccounts() async {
    try {
      return await accountService.getAllAccounts();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addAccount(AccountModel account) async {
    try {
      await accountService.addAccount(account);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAccount(AccountModel account) async {
    try {
      await accountService.updateAccount(account);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(String password, String userId) async {
    try {
      await accountService.changePassword(password, userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount(String accountId) async {
    try {
      await accountService.deleteAccount(accountId);
    } catch (e) {
      rethrow;
    }
  }
}
