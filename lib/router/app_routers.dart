import 'package:admin_hrm/data/model/account/account_model.dart';
import 'package:admin_hrm/data/model/attendance/attendance_model.dart';
import 'package:admin_hrm/data/model/contract/contract_model.dart';
import 'package:admin_hrm/data/model/department/department_model.dart';

import 'package:admin_hrm/data/model/disciplinary/disciplinary_model.dart';
import 'package:admin_hrm/data/model/kpi/kpi_model.dart';
import 'package:admin_hrm/data/model/reward/reward_model.dart';
import 'package:admin_hrm/data/model/salary/salary_model.dart';
import 'package:admin_hrm/data/repository/account_repository.dart';
import 'package:admin_hrm/data/repository/department_repository.dart';
import 'package:admin_hrm/data/repository/disciplinary_repository.dart';
import 'package:admin_hrm/data/repository/reward_repository.dart';

import 'package:admin_hrm/data/model/position/position_model.dart';
import 'package:admin_hrm/data/repository/contract_repository.dart';
import 'package:admin_hrm/data/repository/persional_repository.dart';
import 'package:admin_hrm/data/repository/positiion_repository.dart';
import 'package:admin_hrm/data/repository/salary_repository.dart';
import 'package:admin_hrm/data/repository/user_repository.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/account/account_page.dart';
import 'package:admin_hrm/pages/account/add_account/add_account_page.dart';
import 'package:admin_hrm/pages/account/bloc/account_bloc.dart';
import 'package:admin_hrm/pages/account/edit_account/edit_account_page.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
import 'package:admin_hrm/pages/attendance/add_edit_attendance/attendance_form.dart';
import 'package:admin_hrm/pages/attendance/attendance_page.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_bloc.dart';
import 'package:admin_hrm/pages/attendance/bloc/attendance_event.dart';
import 'package:admin_hrm/pages/contract/add_contract/add_contract.dart';
import 'package:admin_hrm/pages/contract/bloc/contract_bloc.dart';

import 'package:admin_hrm/pages/contract/contract_page.dart';
import 'package:admin_hrm/pages/contract/edit_contract/edit_contract.dart';
import 'package:admin_hrm/pages/department/add_deparment/add_department_page.dart';
import 'package:admin_hrm/pages/department/bloc/department_event.dart';
import 'package:admin_hrm/pages/department/bloc/department_bloc.dart';
import 'package:admin_hrm/pages/department/department_page.dart';

import 'package:admin_hrm/pages/kpi/add_edit_kpi/kpi_form_page.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_bloc.dart';
import 'package:admin_hrm/pages/kpi/bloc/kpi_event.dart';
import 'package:admin_hrm/pages/kpi/kpi_page.dart';

import 'package:admin_hrm/pages/disciplinary/add_disciplinary_page/add_disciplinary_page.dart';
import 'package:admin_hrm/pages/disciplinary/edit_disciplinary_page/edit_disciplinary_page.dart';
import 'package:admin_hrm/pages/personnel_management/person_detail/person_detail_page.dart';
import 'package:admin_hrm/pages/personnel_management/person_detail/person_detail_page_user.dart';

import 'package:admin_hrm/pages/personnel_management/personnel_page.dart';
import 'package:admin_hrm/pages/personnel_management/widgets/add_personnel.dart';
import 'package:admin_hrm/pages/department/edit_deparment/edit_deparment.dart';

import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_bloc.dart';
import 'package:admin_hrm/pages/disciplinary/bloc/disciplinary_event.dart';
import 'package:admin_hrm/pages/disciplinary/disciplinary.dart';

import 'package:admin_hrm/pages/auth/forget_password/forget_password.dart';
import 'package:admin_hrm/pages/auth/login/login_page.dart';
import 'package:admin_hrm/pages/auth/register/register_page.dart';
import 'package:admin_hrm/pages/position/bloc/position_bloc.dart';
import 'package:admin_hrm/pages/position/edit_postion/edit_position.dart';
import 'package:admin_hrm/pages/position/position_page.dart';
import 'package:admin_hrm/pages/position/add_position/add_position.dart';

import 'package:admin_hrm/pages/reward/add_reward/add_reward_page.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_bloc.dart';
import 'package:admin_hrm/pages/reward/bloc/reward_event.dart';
import 'package:admin_hrm/pages/reward/edit_reward/edit_reward_page.dart';
import 'package:admin_hrm/pages/reward/reward_page.dart';

import 'package:admin_hrm/pages/salary/add_salary/add_salary_page.dart';
import 'package:admin_hrm/pages/salary/bloc/salary_bloc.dart';
import 'package:admin_hrm/pages/salary/employee_salary_page.dart';
import 'package:admin_hrm/pages/salary/salary_page.dart';
import 'package:admin_hrm/pages/splash_screen/splash_screen.dart';
import 'package:admin_hrm/router/router_observer.dart';
import 'package:admin_hrm/service/auth_service.dart';
import 'package:admin_hrm/service/attendance_service.dart';
import 'package:admin_hrm/service/kpi_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../data/model/personnel_management.dart';

import '../pages/dash_board/bloc/dash_board_bloc.dart';
import '../pages/dash_board/dash_board.dart';
import '../pages/personnel_management/bloc/persional_bloc.dart';
import '../pages/personnel_management/widgets/update_personnel.dart';
import 'routers_name.dart';

class AppRouter {
  static final AppRouteObserver routeObserver = AppRouteObserver();

  static final GoRouter router = GoRouter(
      // initialLocation: RouterName.login,
      initialLocation: RouterName.splashScreen,
      routes: [
        GoRoute(
          path: RouterName.splashScreen,
          name: RouterName.splashScreen,
          builder: (context, state) {
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: RouterName.login,
          name: RouterName.login,
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: RouterName.forgotPassword,
          name: RouterName.forgotPassword,
          builder: (context, state) {
            return const ForgetPasswordPage();
          },
        ),
        // GoRoute(
        //   path: RouterName.register,
        //   name: RouterName.register,
        //   builder: (context, state) {
        //     return const RegisterPage();
        //   },
        // ),
        GoRoute(
          path: RouterName.dashboard,
          name: RouterName.dashboard,
          builder: (context, state) {
            return BlocProvider(
              create: (context) => DashboardBloc(),
              child: const DashBoardPage(),
            );
          },
        ),
        ShellRoute(
            builder: (context, state, child) {
              return BlocProvider(
                create: (context) => PersionalBloc(
                  personnelRepository: getIt<PersionalRepository>(),
                  departmentRepository: getIt<DepartmentRepository>(),
                  globalStorage: getIt<GlobalStorage>(),
                )..add(const PersionalLoadEvent()),
                child: Scaffold(
                  body: child,
                ),
              );
            },
            routes: [
              GoRoute(
                path: RouterName.addEmployee,
                name: RouterName.addEmployee,
                builder: (context, state) {
                  return const AddEmployeeForm();
                },
              ),
              GoRoute(
                path: RouterName.employeePage,
                name: RouterName.employeePage,
                builder: (context, state) {
                  return const EmployeePage();
                },
              ),
              GoRoute(
                path: RouterName.updateEmployee,
                name: RouterName.updateEmployee,
                builder: (context, state) {
                  return UpdatePersonnel(
                    employee: state.extra as PersionalManagement,
                  );
                },
              ),
              GoRoute(
                path: RouterName.employeeDetailPage,
                name: RouterName.employeeDetailPage,
                builder: (context, state) {
                  final employee = state.extra as PersionalManagement;
                  return PersonDetailPage(persionalManagement: employee);
                },
              ),
            ]),
        GoRoute(
          path: RouterName.employeeDetailUserPage,
          name: RouterName.employeeDetailUserPage,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => PersionalBloc(
                    personnelRepository: getIt<PersionalRepository>(),
                    departmentRepository: getIt<DepartmentRepository>(),
                    globalStorage: getIt<GlobalStorage>(),
                  )..add(const PersonalFetchEvent()),
                ),
                BlocProvider(
                  create: (context) =>
                      AccountBloc(repository: getIt<AccountRepository>()),
                ),
                BlocProvider(
                  create: (context) => AuthBloc(
                    authService: getIt<AuthService>(),
                    userRepository: getIt<UserRepository>(),
                    globalStorage: getIt<GlobalStorage>(),
                  ),
                ),
              ],
              child: const PersonDetailPageUser(),
            );
          },
        ),
        ShellRoute(
            builder: (context, state, child) {
              return BlocProvider<DepartmentBloc>(
                create: (context) => DepartmentBloc(
                    repository: getIt<DepartmentRepository>(),
                    globalStorage: getIt<GlobalStorage>())
                  ..add(GetListDepartment()),
                child: Scaffold(
                  body: child,
                ),
              );
            },
            routes: [
              GoRoute(
                path: RouterName.addDepartment,
                name: RouterName.addDepartment,
                builder: (context, state) {
                  return const AddDepartmentPage();
                },
              ),
              GoRoute(
                path: RouterName.editDepartment,
                name: RouterName.editDepartment,
                builder: (context, state) {
                  final department = state.extra as DepartmentModel;
                  return EditDepartmentPage(
                    department: department,
                  );
                },
              ),
              GoRoute(
                  path: RouterName.departmentPage,
                  name: RouterName.departmentPage,
                  builder: (context, state) {
                    return const DepartmentPage();
                  }),
            ]),
        ShellRoute(
            builder: (context, state, child) {
              return BlocProvider<PositionBloc>(
                create: (context) => PositionBloc(
                    repository: getIt<PositiionRepository>(),
                    globalStorage: getIt<GlobalStorage>())
                  ..add(GetListPosition()),
                child: Scaffold(
                  body: child,
                ),
              );
            },
            routes: [
              GoRoute(
                path: RouterName.positionPage,
                name: RouterName.positionPage,
                builder: (context, state) {
                  return const PositionPage();
                },
              ),
              GoRoute(
                path: RouterName.addPosition,
                name: RouterName.addPosition,
                builder: (context, state) {
                  return const AddPosition();
                },
              ),
              GoRoute(
                path: RouterName.editPosition,
                name: RouterName.editPosition,
                builder: (context, state) {
                  final position = state.extra as PositionModel;
                  return EditPosition(
                    positionModel: position,
                  );
                },
              ),
            ]),
        ShellRoute(
            builder: (context, state, child) {
              return MultiBlocProvider(
                  providers: [
                    BlocProvider<AccountBloc>(
                        create: (context) => AccountBloc(
                              repository: getIt<AccountRepository>(),
                            )..add(LoadAccounts())),
                    BlocProvider<AuthBloc>(
                        create: (context) => AuthBloc(
                              authService: getIt<AuthService>(),
                              userRepository: getIt<UserRepository>(),
                              globalStorage: getIt<GlobalStorage>(),
                            )),
                  ],
                  child: Scaffold(
                    body: child,
                  ));
            },
            routes: [
              GoRoute(
                path: RouterName.accountPage,
                name: RouterName.accountPage,
                builder: (context, state) {
                  return const AccountPage();
                },
              ),
              GoRoute(
                path: RouterName.addAccount,
                name: RouterName.addAccount,
                builder: (context, state) {
                  return const AddAccountPage();
                },
              ),
              GoRoute(
                path: RouterName.editAccount,
                name: RouterName.editAccount,
                builder: (context, state) {
                  final account = state.extra as AccountModel;
                  return EditAccountPage(
                    accountModel: account,
                  );
                },
              ),
            ]),
        ShellRoute(
            builder: (context, state, child) {
              return BlocProvider<ContractBloc>(
                create: (context) => ContractBloc(
                    repository: getIt<ContractRepository>(),
                    globalStorage: getIt<GlobalStorage>())
                  ..add(GetListContract()),
                child: Scaffold(
                  body: child,
                ),
              );
            },
            routes: [
              GoRoute(
                path: RouterName.contractPage,
                name: RouterName.contractPage,
                builder: (context, state) {
                  return const ContractPage();
                },
              ),
              GoRoute(
                path: RouterName.addContract,
                name: RouterName.addContract,
                builder: (context, state) {
                  return const AddContract();
                },
              ),
              GoRoute(
                path: RouterName.editContract,
                name: RouterName.editContract,
                builder: (context, state) {
                  final contract = state.extra as ContractModel;
                  return EditContract(
                    contract: contract,
                  );
                },
              ),
            ]),
        ShellRoute(
          builder: (context, state, child) {
            return BlocProvider<RewardBloc>(
              create: (context) => RewardBloc(
                getIt<RewardRepository>(),
                getIt<GlobalStorage>(),
              )..add(LoadRewards()),
              child: Scaffold(
                body: child,
              ),
            );
          },
          routes: [
            GoRoute(
              path: RouterName.addReward,
              name: RouterName.addReward,
              builder: (context, state) {
                return const AddRewardPage();
              },
            ),
            GoRoute(
              path: RouterName.editReward,
              name: RouterName.editReward,
              builder: (context, state) {
                final reward = state.extra as RewardModel;
                return EditRewardPage(
                  rewardModel: reward,
                );
              },
            ),
            GoRoute(
              path: RouterName.rewardPage,
              name: RouterName.rewardPage,
              builder: (context, state) {
                return RewardPage();
              },
            ),
          ],
        ),

        ShellRoute(
            builder: (context, state, child) {
              return BlocProvider<DisciplinaryBloc>(
                create: (context) => DisciplinaryBloc(
                  getIt<DisciplinaryRepository>(),
                  getIt<GlobalStorage>(),
                )..add(LoadDisciplinary()),
                child: Scaffold(
                  body: child,
                ),
              );
            },
            routes: [
              GoRoute(
                path: RouterName.addDisciplinary,
                name: RouterName.addDisciplinary,
                builder: (context, state) {
                  return AddDisciplinaryPage();
                },
              ),
              GoRoute(
                path: RouterName.disciplinaryPage,
                name: RouterName.disciplinaryPage,
                builder: (context, state) {
                  return const DisciplinaryPage();
                },
              ),
              GoRoute(
                path: RouterName.editDisciplinary,
                name: RouterName.editDisciplinary,
                builder: (context, state) {
                  final disciplinary = state.extra as DisciplinaryModel;
                  return EditDisciplinaryPage(
                    disciplinaryModel: disciplinary,
                  );
                },
              ),
            ]),

        ShellRoute(
            builder: (context, state, child) {
              return BlocProvider(
                create: (context) => SalaryBloc(
                  salaryRepository: getIt<SalaryRepository>(),
                )..add(GetListSalary()),
                child: Scaffold(
                  body: child,
                ),
              );
            },
            routes: [
              GoRoute(
                path: RouterName.salaryPage,
                name: RouterName.salaryPage,
                builder: (context, state) {
                  return const SalaryPage();
                },
              ),
              GoRoute(
                path: RouterName.addSalary,
                name: RouterName.addSalary,
                builder: (context, state) {
                  return AddSalaryPage();
                },
              ),
              // routes: [

              //   GoRoute(
              //     path: RouterName.editSalary,
              //     name: RouterName.editSalary,
              //     builder: (context, state) {
              //       final salary = state.extra as SalaryModel;
              //       return AddEditSalaryPage(
              //         salaryModel: salary,
              //       );
              //     },
              //   ),
              // ]),
              GoRoute(
                path: RouterName.employeeSalaryPage,
                name: RouterName.employeeSalaryPage,
                builder: (context, state) {
                  return const EmployeeSalaryPage();
                },
              ),
            ]),

        ShellRoute(
            builder: (context, state, child) {
              return BlocProvider(
                create: (context) => AttendanceBloc(
                  getIt<AttendanceService>(),
                  getIt<GlobalStorage>(),
                )..add(LoadAttendances()),
                child: Scaffold(
                  body: child,
                ),
              );
            },
            routes: [
              GoRoute(
                  path: RouterName.attendancePage,
                  name: RouterName.attendancePage,
                  builder: (context, state) {
                    return const AttendancePage();
                  },
                  routes: [
                    GoRoute(
                      path: RouterName.addAttendance,
                      name: RouterName.addAttendance,
                      builder: (context, state) {
                        return const AttendanceForm();
                      },
                    ),
                    GoRoute(
                      path: RouterName.editAttendance,
                      name: RouterName.editAttendance,
                      builder: (context, state) {
                        final attendance = state.extra as AttendanceModel;
                        return AttendanceForm(
                          attendance: attendance,
                        );
                      },
                    ),
                  ]),
            ]),
        ShellRoute(
            builder: (context, state, child) {
              return BlocProvider(
                create: (context) => KPIBloc(
                  getIt<KPIService>(),
                  getIt<GlobalStorage>(),
                )..add(LoadKPIs()),
                child: Scaffold(
                  body: child,
                ),
              );
            },
            routes: [
              GoRoute(
                  path: RouterName.kpiPage,
                  name: RouterName.kpiPage,
                  builder: (context, state) {
                    return const KPIPage();
                  },
                  routes: [
                    GoRoute(
                      path: RouterName.addKpi,
                      name: RouterName.addKpi,
                      builder: (context, state) {
                        return const KPIFormPage();
                      },
                    ),
                    GoRoute(
                      path: RouterName.editKpi,
                      name: RouterName.editKpi,
                      builder: (context, state) {
                        final kpi = state.extra as KPIModel;
                        return KPIFormPage(
                          initialKPI: kpi,
                        );
                      },
                    ),
                  ]),
            ]),
      ],

      // Định nghĩa redirection logic:
      // redirect: (BuildContext context, GoRouterState state) {
      //   final sidebarBloc = BlocProvider.of<SideBarBloc>(context);
      //   final routeName = state.name;
      //
      //   if (routeName != null && sidebarBloc.state.activeItem != routeName) {
      //     sidebarBloc.add(ChangeActiveItemEvent(route: routeName));
      //   }
      //   return null;
      // },
      observers: [
        routeObserver
      ]);
}
