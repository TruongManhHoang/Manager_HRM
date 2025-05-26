import 'package:admin_hrm/common/widgets/layouts/sidebars/bloc/sidebar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSidebar extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final List<Widget> pages;
  final BuildContext context;

  const CustomSidebar({
    Key? key,
    required this.title,
    required this.icon,
    required this.items,
    required this.pages,
    required this.context,
  }) : super(key: key);

  @override
  _NavigatorBarState createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<CustomSidebar> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SideBarBloc()),
        // Add more providers here
      ],
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(widget.icon, size: 20, color: Colors.grey),
            SizedBox(width: 10),
            Text(
              widget.title,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
        children: widget.items.asMap().entries.map((entry) {
          int index = entry.key;
          String item = entry.value;

          return _buildRowWithDivider(
              item, index, context, widget.pages[index]);
        }).toList(),
      ),
    );
  }

  Widget _buildRowWithDivider(
      String title, int index, BuildContext context, Widget targetPage) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            // ()=> siderBarController.index.value = 0,
            // selected: siderBarController.index.value == 0,
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetPage),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? Colors.blueAccent
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.circle_outlined,
                    color: selectedIndex == index ? Colors.black : Colors.grey,
                    size: 15,
                  ),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          selectedIndex == index ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 0.5,
          height: 0,
          color: Colors.grey,
        ),
      ],
    );
  }
}
