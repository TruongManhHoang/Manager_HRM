import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_bloc.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_state.dart';
import 'package:admin_hrm/pages/kpi/table/table_source_kpi.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../constants/sizes.dart';

class DataTableKPI extends StatelessWidget {
  const DataTableKPI({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: TColors.dark,
        );
    return BlocBuilder<KPIBloc, KPIState>(
      builder: (context, state) {
        if (state is KPILoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is KPILoaded && state.kpis.isEmpty) {
          return const Center(
            child: Text(
              'Không có dữ liệu KPI.',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else if (state is KPILoaded) {
          return TPaginatedDataTable(
            minWidth: 700,
            tableHeight: 500,
            dataRowHeight: TSizes.xl * 1.45,
            columns: [
              DataColumn2(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Center(
                    child: Text('STT',
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: baseStyle),
                  ),
                ),
              ),
              DataColumn2(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Center(
                    child: Text('Tên nhân viên',
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: baseStyle),
                  ),
                ),
              ),
              DataColumn2(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Center(
                    child: Text('Nội dung KPI',
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: baseStyle),
                  ),
                ),
              ),
              DataColumn2(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Center(
                    child: Text('Phòng ban',
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: baseStyle),
                  ),
                ),
              ),
              DataColumn2(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Center(
                    child: Text('Giá trị KPI',
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: baseStyle),
                  ),
                ),
              ),
              DataColumn2(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Center(
                    child: Text('Người đánh giá',
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: baseStyle),
                  ),
                ),
              ),
              DataColumn2(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Center(
                    child: Text('Ghi chú',
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: baseStyle),
                  ),
                ),
              ),
              DataColumn2(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Center(
                    child: Text('Ngày tạo',
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: baseStyle),
                  ),
                ),
              ),
              DataColumn2(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                  child: Center(
                    child: Text('Hành động',
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: baseStyle),
                  ),
                ),
              ),
            ],
            source: KPITableRows(
              context,
              state.kpis,
            ),
          );
        } else
          // ignore: curly_braces_in_flow_control_structures
          return const Center(
            child: Text(
              'Không có dữ liệu',
              style: TextStyle(color: Colors.red),
            ),
          );
      },
    );
  }
}
