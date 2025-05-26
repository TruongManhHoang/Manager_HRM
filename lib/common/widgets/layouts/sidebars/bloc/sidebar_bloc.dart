import 'package:admin_hrm/constants/device_utility.dart';
import 'package:admin_hrm/router/routers_name.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'sidebar_event.dart';
part 'sidebar_state.dart';

class SideBarBloc extends HydratedBloc<SideBarEvent, SideBarState> {
  SideBarBloc() : super(const SideBarState()) {
    on<ChangeActiveItemEvent>(_onChangeActiveItem);
    on<ChangeHoverItemEvent>(_onChangeHoverItem);
    on<MenuOnTapEvent>(_onMenuOnTap);
  }

  void _onChangeActiveItem(
      ChangeActiveItemEvent event, Emitter<SideBarState> emit) {
    debugPrint('Active item changed to: ${event.route}');
    emit(state.copyWith(activeItem: event.route));
  }

  bool isActive(String route) {
    return state.activeItem == route;
  }

  bool isHovering(String route) {
    return state.hoverItem == route;
  }

  void _onChangeHoverItem(
      ChangeHoverItemEvent event, Emitter<SideBarState> emit) {
    debugPrint('hover: ${event.route}, current: ${state.hoverItem}');
    if (!isActive(event.route)) {
      emit(state.copyWith(hoverItem: event.route));
    }
  }

  void _onMenuOnTap(MenuOnTapEvent event, Emitter<SideBarState> emit) {
    if (!isActive(event.route)) {
      add(ChangeActiveItemEvent(route: event.route));
      debugPrint('Navigating to: ${event.route}');
      if (TDeviceUtils.isMobileScreen(event.context)) {
        Navigator.of(event.context).pop();
      }
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        GoRouter.of(event.context).goNamed(event.route);
      } else {
        GoRouter.of(event.context).go(RouterName.login);
      }
    }
  }

  @override
  SideBarState? fromJson(Map<String, dynamic> json) {
    return SideBarState(
      activeItem: json['activeItem'] ?? '',
      hoverItem: json['hoverItem'] ?? '',
    );
  }

  @override
  Map<String, dynamic>? toJson(SideBarState state) {
    return {
      'activeItem': state.activeItem,
      'hoverItem': state.hoverItem,
    };
  }
}
