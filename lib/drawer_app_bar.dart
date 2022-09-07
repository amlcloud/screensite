import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/main.dart';
import 'package:screensite/state/theme_state_notifier.dart';
import 'package:screensite/search/search_page.dart';
import 'package:screensite/lists/lists_page.dart';

class DrawerAppBar {
  static final List<String> _tabs = ['search', 'lists'];

  static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      // automaticallyImplyLeading: false,
      title: Align(
        alignment: Alignment.centerLeft,
        // child: SizedBox(
        //     width: 300,
        //     child: TabBar(
        //       tabs: _tabs
        //           .map((t) => Tab(
        //               iconMargin: EdgeInsets.all(0),
        //               child:
        //                   // GestureDetector(
        //                   //     behavior: HitTestBehavior.translucent,
        //                   //onTap: () => navigatePage(text, context),
        //                   //child:
        //                   Text(t.toUpperCase(),
        //                       overflow: TextOverflow.fade,
        //                       softWrap: false,
        //                       style: TextStyle(
        //                           color:
        //                               // Theme.of(context).brightness == Brightness.light
        //                               //     ? Color(DARK_GREY)
        //                               //:
        //                               Colors.white))))
        //           .toList(),
        //       onTap: (index) {
        //         Navigator.of(context).pushNamed(_tabs[index]);
        //       },
        //     ))
      ),
      actions: [
        ThemeIconButton(),
        IconButton(
            onPressed: () {
              ref.read(isLoggedIn.notifier).value = false;
              FirebaseAuth.instance.signOut();
              // print("Signed out");
            },
            icon: Icon(Icons.exit_to_app))
      ],
    );
  }
}

class ThemeIconButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkState = ref.watch(themeStateNotifierProvider);
    return IconButton(
        tooltip: 'dark/light mode',
        onPressed: () {
          ref.read(themeStateNotifierProvider.notifier).changeTheme();
        },
        icon: Icon(isDarkState == true
            ? Icons.nightlight
            : Icons.nightlight_outlined));
  }
}
