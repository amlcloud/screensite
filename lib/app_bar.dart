import '_exports.dart';

class MyAppBar {
  static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref,
      {bool autoImplyLeading = true}) {
    return CustomAppBar(
      // automaticallyImplyLeading: autoImplyLeading,
      tabs: [
        'search',
        'lists',
        'cases',
      ],
      maxTabWidth: 50,
      onTabSelected: (BuildContext context, tabIndex, tab) =>
          ref.read(routerProvider).go('/${tab.toLowerCase()}')
      // context.go('/${tab.toLowerCase()}')
      // Navigator.of(context).pushNamed('/${tab.toLowerCase()}')
      ,
      // automaticallyImplyLeading:
      //     (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
      //         ? true
      //         : false,
      // leadingWidth:
      //     (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH) ? null : 100,
      leading: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? null
          : Padding(
              padding: EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/Logo_Dark.svg',
              )),
      // title: Text("Sanctions Screener", style: TextStyle(fontSize: 20)),
      // tabsAlignment: TabsAlignment.left,
      // onTabSelected: (context, tabIndex, tab) {
      //   Navigator.of(context).pushNamed('/${tab.toLowerCase()}');
      // }
    );
  }
}

// class MyAppBar {
//   static final List<String> _tabs = [
//     'search',
//     'lists',
//     'cases',
//   ];

//   static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref) {
//     return AppBar(
//       automaticallyImplyLeading:
//           (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
//               ? true
//               : false,
//       leadingWidth:
//           (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH) ? null : 100,
//       leading: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
//           ? null
//           : Padding(
//               padding: EdgeInsets.all(10),
//               child: SvgPicture.asset(
//                 'assets/Logo_Dark.svg',
//               )),
//       // Image.asset('assets/Logo_Dark.svg',
//       //     //'assets/amlcloud-lg.png',
//       //     height: 180,
//       //     width: 180,
//       //     colorBlendMode: BlendMode.srcIn) //Logo(),
//       // ),
//       title: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
//           ? null
//           : Align(
//               child: SizedBox(
//                   width: 800,
//                   child: TabBar(
//                     tabs: _tabs
//                         .map((t) => Tab(
//                             iconMargin: EdgeInsets.all(0),
//                             child:
//                                 // GestureDetector(
//                                 //     behavior: HitTestBehavior.translucent,
//                                 //onTap: () => navigatePage(text, context),
//                                 //child:
//                                 Text(
//                               t.toUpperCase(),
//                               overflow: TextOverflow.fade,
//                               softWrap: false,
//                               style: Theme.of(context).textTheme.titleSmall,
//                             )))
//                         .toList(),
//                     onTap: (index) {
//                       Navigator.of(context).pushNamed(_tabs[index]);
//                     },
//                   ))),
//       actions: [
//         //AppBarUserProfile(),
//         CurrentUserAvatarExtended(),
//         ThemeIconButton(),
//         IconButton(
//             onPressed: () {
//               ref.read(isLoggedIn.notifier).value = false;
//               FirebaseAuth.instance.signOut();
//               // print("Signed out");
//             },
//             icon: Icon(Icons.exit_to_app)),
//       ],
//     );
//   }
// }

// class ThemeIconButton extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     var isDarkState = ref.watch(themeStateNotifierProvider);
//     return IconButton(
//         tooltip: 'dark/light mode',
//         onPressed: () {
//           ref.read(themeStateNotifierProvider.notifier).changeTheme();
//         },
//         icon: Icon(isDarkState == true
//             ? Icons.nightlight
//             : Icons.nightlight_outlined));
//   }
// }
