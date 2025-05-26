part of 'sidebar_bloc.dart';

class SideBarEvent extends Equatable {
  const SideBarEvent();
  @override
  List<Object> get props => [];
}

class ChangeActiveItemEvent extends SideBarEvent {
  final String route;
  const ChangeActiveItemEvent({required this.route});
  @override
  List<Object> get props => [route];
}

class ChangeHoverItemEvent extends SideBarEvent {
  final String route;
  const ChangeHoverItemEvent({required this.route});
  @override
  List<Object> get props => [route];
}

class MenuOnTapEvent extends SideBarEvent {
  final String route;
  final BuildContext context;
  const MenuOnTapEvent({required this.route, required this.context});
  @override
  List<Object> get props => [route];
}