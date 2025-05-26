import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/pages/account/bloc/account_bloc.dart';
import 'package:admin_hrm/pages/account/table/table_source_account.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_bloc.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_event.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_state.dart';
import 'package:admin_hrm/pages/reward/table/table_source_reward.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../constants/sizes.dart';

class DataTableAccount extends StatefulWidget {
  const DataTableAccount({super.key});

  @override
  State<DataTableAccount> createState() => _DataTableAccountState();
}

class _DataTableAccountState extends State<DataTableAccount> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // BlocProvider.of<RewardBloc>(context).add(LoadRewards());
  }

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: TColors.dark,
        );
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AccountLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AccountLoaded) {
          return TPaginatedDataTable(
            minWidth: 700,
            tableHeight: 500,
            dataRowHeight: TSizes.xl * 1.45,
            columns: [
              DataColumn2(
                label: Center(
                  child: Text('STT',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Mã tài khoản',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Tên tài khoản',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Email',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Password',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Vai trò',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Trạng thái',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Hành động',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
            ],
            source: TableSourceAccount(
              context,
              state.accounts,
            ),
          );
        } else if (state is AccountError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
