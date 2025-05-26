import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common/widgets/layouts/sidebars/bloc/sidebar_bloc.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _notify(Route<dynamic> route, BuildContext context) {
    final settings = route.settings;
    if (settings.name != null) {
      final bloc = BlocProvider.of<SideBarBloc>(context, listen: false);
      bloc.add(ChangeActiveItemEvent(route: settings.name!));
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) _notify(route, route.navigator!.context);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) _notify(newRoute, newRoute.navigator!.context);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute) _notify(previousRoute, previousRoute.navigator!.context);
  }
}
