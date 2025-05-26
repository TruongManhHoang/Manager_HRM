import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/pages/position/bloc/position_bloc.dart';
import 'package:admin_hrm/pages/position/table/table_positon.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../constants/sizes.dart';

class DataTablePositon extends StatelessWidget {
  const DataTablePositon({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: TColors.dark,
        );
    return BlocBuilder<PositionBloc, PositionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.isSuccess) {
          return TPaginatedDataTable(
            minWidth: 700,
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
                  child: Text('Mã chức vụ',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Loại chức vụ',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Tên chức vụ',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Hệ số lương',
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
                  child: Text('Ngày tạo',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Cập nhật',
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
            source:
                TablePositionRows(context: context, positions: state.positions),
          );
        } else if (state.isFailure) {
          return const Center(
            child: Text(
              'Đã xảy ra lỗi khi tải dữ liệu.',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'Không có dữ liệu.',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }
      },
    );
  }
}
