import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/pages/salary/bloc/salary_bloc.dart';
import 'package:admin_hrm/pages/salary/table/table_source_salary.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../constants/sizes.dart';

class DataTableSalary extends StatelessWidget {
  const DataTableSalary({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: TColors.dark,
        );
    return BlocBuilder<SalaryBloc, SalaryState>(
      builder: (context, state) {
        if (state is SalaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SalaryLoaded && state.salaries.isEmpty) {
          return const Center(child: Text('Không có dữ liệu bảng lương.'));
        } else if (state is SalaryLoaded) {
          return TPaginatedDataTable(
            minWidth: 700,
            tableHeight: 500,
            rowsPerPage: 5,
            dataRowHeight: 65,
            columns: [
              DataColumn2(
                label: Center(
                  child: Text('STT',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
                fixedWidth: 60, // Cố định chiều rộng nếu muốn
              ),
              DataColumn2(
                label: Center(
                  child: Text('Mã bảng lương',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Tên nhân viên',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Lương cơ bản',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Số ngày công',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Khen thưởng',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Kỷ luật',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Thưởng KPI',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Tổng lương thực lĩnh',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Ngày tạo',
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
            source: TableSourceSalary(
              context,
              state.salaries,
            ),
          );
        } else if (state is SalaryFailure) {
          return Center(
            child: Text(
              state.error,
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
