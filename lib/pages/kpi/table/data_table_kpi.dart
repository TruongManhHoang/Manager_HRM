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
    return BlocBuilder<KPIBloc, KPIState>(
      builder: (context, state) {
        if (state is KPILoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is KPILoaded) {
          return TPaginatedDataTable(
            minWidth: 700,
            tableHeight: 500,
            dataRowHeight: TSizes.xl * 1.45,
            columns: const [
              DataColumn2(
                label: Center(
                  child: Text(
                    'Mã nhân sự',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text(
                    'Phòng ban',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text(
                    'Tháng',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text(
                    'Tổng điểm',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text(
                    'Người đánh giá',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text(
                    'Ghi chú',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text(
                    'Hành động',
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
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
