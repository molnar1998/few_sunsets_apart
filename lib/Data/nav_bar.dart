import 'package:few_sunsets_apart/Data/page_control.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<StatefulWidget> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = PageControl.page;
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      surfaceTintColor: Colors.orange[100],
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          if (index == 0 && currentPageIndex != 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1 && currentPageIndex != 1) {
            Navigator.pushReplacementNamed(context, '/message');
          } else if (index == 2 && currentPageIndex != 2) {
            Navigator.pushReplacementNamed(context, '/setting');
          }
          PageControl.updatePage(index);
        });
      },
      elevation: 6,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Badge(
            label: Text('2'),
            child: Icon(Icons.messenger_sharp),
          ),
          label: 'Messages',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
