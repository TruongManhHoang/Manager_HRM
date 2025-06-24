import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/pages/department/bloc/department_bloc.dart';
import 'package:admin_hrm/pages/department/bloc/department_state.dart';
import 'package:admin_hrm/pages/department/table/table_source_department.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../constants/sizes.dart';

class DataTableDepartment extends StatelessWidget {
  const DataTableDepartment({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: TColors.dark,
        );
    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DepartmentLoaded) {
          return TPaginatedDataTable(
            minWidth: 700,
            tableHeight: 500,
            rowsPerPage: 5,
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
                  child: Text('Mã phòng ban',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Tên phòng ban',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Mô tả',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Số lượng nhân viên',
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
                  child: Text('Số điện thoại',
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
            source: DepartmentTableRows(
              context,
              state.departments,
            ),
          );
        } else
          return Center(
            child: Text(
              'Không có dữ liệu',
              style: const TextStyle(color: Colors.red),
            ),
          );
      },
    );
  }
}
