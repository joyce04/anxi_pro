
import 'package:anxi_pro/widgets/bottom_navigator.dart';
import 'package:anxi_pro/widgets/tab_navigator.dart';
import 'package:anxi_pro/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:anxi_pro/color_scheme.dart';
import 'record_my_state.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TabItem _currentTab = TabItem.dashboard;
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.dashboard: GlobalKey<NavigatorState>(),
    TabItem.calender: GlobalKey<NavigatorState>(),
    TabItem.chart: GlobalKey<NavigatorState>(),
    TabItem.person: GlobalKey<NavigatorState>(),
    TabItem.export: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple,
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.dark,
      ),
      bottomNavigationBar: BottomNavigation(
        currentTab: _currentTab,
        onSelectTab: _selectTab,
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            child: Stack(children: <Widget>[
              _buildOffStageNavigator(TabItem.dashboard),
              _buildOffStageNavigator(TabItem.calender),
              _buildOffStageNavigator(TabItem.chart),
              _buildOffStageNavigator(TabItem.person),
            ]),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RecordMyState()));
        },
      ),
    );
  }

  Widget _buildOffStageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(navigatorKey: _navigatorKeys[tabItem], tabItem: tabItem),
    );
  }
}
