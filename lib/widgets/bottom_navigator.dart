import 'package:anxi_pro/color_scheme.dart';
import 'package:anxi_pro/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    int _selectedTabIndex = tabInfo[widget.currentTab].tabIndex;

    return Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: dark_purple,
        ),
        // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          items: [
            _buildItem(tabItem: TabItem.dashboard),
            _buildItem(tabItem: TabItem.calender),
            _buildItem(tabItem: TabItem.chart),
            _buildItem(tabItem: TabItem.person),
          ],
          currentIndex: _selectedTabIndex,
          selectedItemColor: yellow,
          unselectedItemColor: purple_3,
          onTap: (index) => widget.onSelectTab(TabItem.values[index]),
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ));
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {
    String label = tabInfo[tabItem].tabname;
    IconData icon = tabInfo[tabItem].tabIcon;
    return BottomNavigationBarItem(icon: Icon(icon, size: 30.0), label: label);
  }
}
