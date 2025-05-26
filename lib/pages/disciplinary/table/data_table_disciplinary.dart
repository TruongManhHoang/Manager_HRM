import 'package:admin_hrm/constants/colors.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_bloc.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_state.dart';
import 'package:admin_hrm/pages/disciplinary/table/table_source_disciplinary.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../constants/sizes.dart';

class DataTableDisciplinary extends StatefulWidget {
  const DataTableDisciplinary({super.key});

  @override
  State<DataTableDisciplinary> createState() => _DataTableDisciplinaryState();
}

class _DataTableDisciplinaryState extends State<DataTableDisciplinary> {
  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: TColors.dark,
        );
    return BlocBuilder<DisciplinaryBloc, DisciplinaryState>(
      builder: (context, state) {
        if (state is DisciplinaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DisciplinaryLoaded) {
          return TPaginatedDataTable(
            minWidth: 700,
            tableHeight: 500,
            dataRowHeight: TSizes.xl * 1.45,
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
                  child: Text('Mã kỷ luật',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Nhân viên',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Loại kỷ luật',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Lý do',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Giá trị kỷ luật',
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: baseStyle),
                ),
              ),
              DataColumn2(
                label: Center(
                  child: Text('Mức độ kỷ luật',
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
            source: DisciplinaryTableRows(
              context,
              state.disciplinary,
            ),
          );
        } else if (state is DisciplinaryError) {
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
