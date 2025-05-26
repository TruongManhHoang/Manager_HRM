
part of 'sidebar_bloc.dart';

class SideBarState extends Equatable {
  final String activeItem;
  final String hoverItem;

  const SideBarState({
    this.activeItem = RouterName.dashboard,
    this.hoverItem = '',
  });
  SideBarState copyWith({
    String? activeItem,
    String? hoverItem,
    BuildContext? context,
  }) {
    return SideBarState(
      activeItem: activeItem ?? this.activeItem,
      hoverItem: hoverItem ?? this.hoverItem,

    );
  }
  @override
  List<Object?> get props => [activeItem, hoverItem];

}