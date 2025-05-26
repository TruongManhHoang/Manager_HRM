import 'package:admin_hrm/data/repository/user_repository.dart';
import 'package:admin_hrm/di/locator.dart';
import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_bloc.dart';
import 'package:admin_hrm/pages/auth/bloc/auth_event.dart';
import 'package:admin_hrm/router/app_routers.dart';
import 'package:admin_hrm/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'common/widgets/layouts/sidebars/bloc/sidebar_bloc.dart';
import 'constants/web_material_scroll.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<SideBarBloc>(
            create: (context) => SideBarBloc(),
          ),
          BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(
                  authService: getIt<AuthService>(),
                  userRepository: getIt<UserRepository>(),
                  globalStorage: getIt<GlobalStorage>())
                ..add(AuthStarted())),
        ],
        child: MaterialApp.router(
          title: 'Admin Dai Hoc',
          themeMode: ThemeMode.light,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
          routerDelegate: AppRouter.router.routerDelegate,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
        ));
  }
}
