import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/router.dart';
import 'package:screensite/theme.dart';
import 'package:theme/theme_mode.dart';

class MainApp extends ConsumerWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    bool isDarkTheme = ref.watch(themeModeSNP);
    print('theme: ${isDarkTheme}');
    return
        // DefaultTabController(
        //     initialIndex: 0,
        //     length: 3,
        //     child:
        // MaterialApp(
        //   title: 'Sanctions Screener',
        //   themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        //   theme: lightTheme,
        //   darkTheme: ThemeData.dark().copyWith(
        //       // highlightColor: Colors.orange,
        //       // colorScheme:
        //       //     ColorScheme.dark().copyWith(secondary: Colors.orange)
        //       ),

        //   initialRoute: '/',
        //   onGenerateRoute: generateRoutes({
        //     '/': (context, settings) => LandingPage(),
        //     // '/': (context, settings) => SearchPage(),
        //     '/login': (context, settings) => LoginPage(),
        //     '/search': (context, settings) => SearchPage(),
        //     '/cases': (context, settings) => CasesPage(),
        //     '/lists': (context, settings) => ListsPage(),
        //   })),
        DefaultTabController(
            initialIndex: 0,
            length: 3,
            child: MaterialApp.router(
              title: 'Sanctions Screener',
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              routeInformationProvider: router.routeInformationProvider,
              themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
              theme: lightTheme,
              darkTheme: ThemeData.dark().copyWith(
                  // highlightColor: Colors.orange,
                  // colorScheme:
                  //     ColorScheme.dark().copyWith(secondary: Colors.orange)
                  ),
            ));
  }
}
