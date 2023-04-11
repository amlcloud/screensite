import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets/nav_rail.dart';

class CustomNavRail extends ConsumerWidget {
  static final CustomNavRail _navRail = CustomNavRail(key: ValueKey('navRail'));

  final Map<String, NavigationRailDestination> destinations = {
    // 'overview': const NavigationRailDestination(
    //   icon: Icon(Icons.view_quilt),
    //   label: Text('Overview'),
    // ),
    'search': const NavigationRailDestination(
      icon: Icon(Icons.search),
      label: Text('Search Centre'),
    ),
    'lists': const NavigationRailDestination(
      icon: Icon(Icons.source),
      label: Text('Sources'),
    ),
    'cases': const NavigationRailDestination(
      icon: Icon(Icons.assignment_late),
      label: Text('Alerts'),
    ),
    // 'customers': const NavigationRailDestination(
    //   icon: Icon(Icons.groups),
    //   label: Text('Customers'),
    // ),
    // 'regulations': const NavigationRailDestination(
    //   icon: Icon(Icons.segment),
    //   label: Text('Regulations'),
    // ),
    // 'reports': const NavigationRailDestination(
    //   icon: Icon(Icons.summarize),
    //   label: Text('Reports'),
    // ),
    // 'teams': const NavigationRailDestination(
    //   icon: Icon(Icons.diversity_3),
    //   label: Text('Teams'),
    // ),
    // 'profile': const NavigationRailDestination(
    //   icon: Icon(Icons.account_circle),
    //   label: Text('Profile'),
    // ),
    // 'settings': const NavigationRailDestination(
    //   icon: Icon(Icons.settings),
    //   label: Text('Settings'),
    // ),
  };

  CustomNavRail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavRail(
        onDestinationSelected: (int index) {
          print('index: $index, name: ${destinations.keys.elementAt(index)}');
          Navigator.of(context).pushNamed(
              '/' + destinations.keys.elementAt(index).toLowerCase());
        },
        destinations: destinations);
  }

  static getNavRail() => _navRail;
}
