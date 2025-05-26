import 'package:admin_hrm/common/widgets/breadcrumb/t_breadcrums_with_heading.dart';
import 'package:admin_hrm/common/widgets/method/method.dart';
import 'package:admin_hrm/constants/sizes.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_bloc.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_event.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_state.dart';
import 'package:admin_hrm/pages/disciplinary/table/data_table_disciplinary.dart';
import 'package:admin_hrm/router/routers_name.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DisciplinaryPageDesktop extends StatelessWidget {
  const DisciplinaryPageDesktop({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const TBreadcrumsWithHeading(
                heading: 'Kỷ luật',
                breadcrumbItems: [],
              ),
              const Row(
                children: [
                  Text(
                    'Kỷ luật',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ],
              ),
              const Gap(TSizes.spaceBtwItems),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () async {
                              final result = await context
                                  .push(RouterName.addDisciplinary);
                              if (result == true) {
                                context
                                    .read<DisciplinaryBloc>()
                                    .add(LoadDisciplinary());
                              }
                            },
                            child: Text(
                              'Thêm kỷ luật',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            )),
                        const Gap(10),
                        BlocBuilder<DisciplinaryBloc, DisciplinaryState>(
                            builder: (context, state) {
                          if (state is DisciplinaryLoaded) {
                            return TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  exportDynamicExcel(
                                    fileName: 'Danh sách kỷ luật',
                                    headers: [
                                      'Mã kỷ luật',
                                      'Mã nhân viên',
                                      'Lý do',
                                      'Loại kỷ luật',
                                      'Giá trị kỷ luật',
                                      'Mức độ kỷ luật',
                                      'Trạng thái',
                                      'Ngày khen thưởng',
                                    ],
                                    dataRows: state.disciplinary
                                        .map((disciplinary) => [
                                              disciplinary.id,
                                              disciplinary.employeeId,
                                              disciplinary.reason,
                                              disciplinary.disciplinaryType,
                                              disciplinary.disciplinaryValue,
                                              disciplinary.severity,
                                              disciplinary.status,
                                              disciplinary.disciplinaryDate,
                                            ])
                                        .toList(),
                                  );
                                },
                                child: Text(
                                  'Xuất danh sách kỷ luật',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                ));
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ],
                    ),
                    const Gap(TSizes.spaceBtwItems),
                    const DataTableDisciplinary()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
