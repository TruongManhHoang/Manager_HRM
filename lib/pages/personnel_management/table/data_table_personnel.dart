import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/pages/personnel_management/table/table_personnel.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../constants/sizes.dart';
import '../bloc/persional_bloc.dart';

class DataTableEmployee extends StatelessWidget {
  const DataTableEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: TColors.dark,
        );
    return BlocConsumer<PersionalBloc, PersionalState>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Unknown error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isFailure) {
          return Center(child: Text('Lỗi: ${state.errorMessage}'));
        }

        if (state.isSuccess) {
          final employees = state.personnel;

          if (employees!.isEmpty) {
            return const Center(child: Text('Không có dữ liệu nhân viên.'));
          }

          return TPaginatedDataTable(
            tableHeight: 500,
            dataRowHeight: TSizes.xl * 1.2,
            columns: [
              DataColumn2(
                label: Center(
                  child: Text(
                    'STT',
                    style: baseStyle,
                  ),
                ),
                fixedWidth: 60, // Cố định chiều rộng nếu muốn
              ),
              DataColumn2(
                  label: Center(
                      child: Text('Mã nhân viên',
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: baseStyle))),
              DataColumn2(
                  label: Center(
                      child: Text('avatar',
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: baseStyle))),
              DataColumn2(
                  label: Center(
                      child: Text(
                'Họ tên',
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: baseStyle,
              ))),
              DataColumn2(
                  label: Center(
                child: Text(
                  'Giới tính',
                  maxLines: 2,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: baseStyle,
                ),
              )),
              DataColumn2(
                  label: Center(
                      child: Text(
                'Ngày sinh',
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: baseStyle,
              ))),
              DataColumn2(
                  label: Center(
                      child: Text(
                'Số điện thoại',
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: baseStyle,
              ))),
              DataColumn2(
                  label: Center(
                      child: Text('Email',
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: baseStyle))),
              DataColumn2(
                  label: Center(
                      child: Text('Địa chỉ',
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: baseStyle))),
              DataColumn2(
                  label: Center(
                      child: Text('Chức vụ',
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: baseStyle))),
              DataColumn2(
                  label: Center(
                      child: Text('Phòng ban',
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: baseStyle))),
              DataColumn2(
                  label: Center(
                      child: Text('Ngày bắt đầu',
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: baseStyle))),
              DataColumn2(
                  label: Center(
                      child: Text('Trạng thái',
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: baseStyle))),
              DataColumn2(
                  label: Center(
                      child: Text('Chức năng khác',
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: baseStyle))),
            ],
            source: TableEmployeeRows(context, employees),
            rowsPerPage: 10,
          );
        }

        return const SizedBox();
      },
    );
  }
}
