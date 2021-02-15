import 'package:anxi_pro/views/calender.dart';
import 'package:anxi_pro/views/chart.dart';
import 'package:anxi_pro/views/dashboard.dart';
import 'package:anxi_pro/views/export.dart';
import 'package:anxi_pro/views/setting.dart';
import 'package:flutter/material.dart';

enum TabItem { dashboard, calender, chart, person, export }

class TabInfo {
  String tabname;
  IconData tabIcon;
  int tabIndex;

  TabInfo(this.tabname, this.tabIcon, this.tabIndex);
}

Map<TabItem, TabInfo> tabInfo = {
  TabItem.dashboard: TabInfo('dashboard', Icons.home, 0),
  TabItem.calender: TabInfo('record', Icons.calendar_today_outlined, 1),
  TabItem.chart: TabInfo('chart', Icons.bar_chart, 2),
  TabItem.export: TabInfo('export', Icons.download_rounded, 3),
  TabItem.person: TabInfo('setting', Icons.person, 4),
};

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});

  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, TabItem tabItem) {
    Widget rootView;

    if (tabItem == TabItem.dashboard) {
      rootView = Dashboard();
    } else if (tabItem == TabItem.calender) {
      rootView = Calendar();
    } else if (tabItem == TabItem.chart) {
      rootView = Chart();
    } else if (tabItem == TabItem.person) {
      rootView = Setting();
    } else if (tabItem == TabItem.export) {
      rootView = Export();
    }

    return {
      TabNavigatorRoutes.root: (context) => rootView,
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context, tabItem);

    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => routeBuilders[routeSettings.name](context));
      },
    );
  }
}
