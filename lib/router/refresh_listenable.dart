import 'package:flutter/cupertino.dart';

import '../common/widgets/layouts/sidebars/bloc/sidebar_bloc.dart';

class RouteNotifier extends ChangeNotifier {
  final SideBarBloc _sideBarBloc;

  RouteNotifier(this._sideBarBloc);

  void onRouteChanged(String? routeName) {
    if (routeName != null && !_sideBarBloc.isActive(routeName)) {
      _sideBarBloc.add(ChangeActiveItemEvent(route: routeName));
    }
    notifyListeners();
  }
}
