import 'package:common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';
import 'package:sandbox/sandbox_launcher2.dart';
import 'package:screensite/adversemedia/adversemedia_page.dart';
import 'package:screensite/lists/lists_page.dart';
import 'package:screensite/login_page.dart';
import 'package:screensite/pep/pep_admin.dart';
import 'package:screensite/pep/pep_library.dart';
import 'package:screensite/sandbox_app.dart';
import 'package:screensite/search/search_page.dart';
import 'package:screensite/state/theme_state_notifier.dart';
import 'package:screensite/theme.dart';

import 'cases/cases_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kReleaseMode) {
    await dotenv.load(fileName: ".env.production");
  } else {
    await dotenv.load(fileName: ".env.development");
  }

  runApp(SandboxLauncher2(
    enabled: const String.fromEnvironment('SANDBOX') == 'true',
    app: ProviderScope(child: MainApp()),
    sandbox: SandboxApp(),
    getInitialState: () =>
        kDB.doc('sandbox/serge').get().then((doc) => doc.data()!['sandbox']),
    saveState: (state) => {
      kDB.doc('sandbox/serge').set({'sandbox': state})
    },
  ));
}

class MainApp extends ConsumerWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkTheme = ref.watch(themeStateNotifierProvider);
    return MaterialApp(
      title: 'Sanctions Screener',
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: TheApp(),
    );
  }
}

final isLoggedIn = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

final isLoading = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

class TheApp extends ConsumerStatefulWidget {
  const TheApp({Key? key}) : super(key: key);
  @override
  TheAppState createState() => TheAppState();
}

class TheAppState extends ConsumerState<TheApp> {
  @override
  void initState() {
    super.initState();
    ref.read(isLoading.notifier).value = true;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // Clear search history from state on display of login page
        ref.read(selectedSearchResult.notifier).value = null;
        ref.read(isLoggedIn.notifier).value = false;
        ref.read(isLoading.notifier).value = false;
      } else {
        ref.read(selectedSearchResult.notifier).value = null;
        ref.read(isLoggedIn.notifier).value = true;
        ref.read(isLoading.notifier).value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(isLoading)) {
      return Center(
        child: Container(
          alignment: Alignment(0.0, 0.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
          body: ref.watch(isLoggedIn) == false
              ? LoginPage()
              : DefaultTabController(
                  initialIndex: 0,
                  length: 3,
                  child: Navigator(
                    onGenerateRoute: (RouteSettings settings) {
                      // print('onGenerateRoute: ${settings}');
                      if (settings.name == '/' || settings.name == 'search') {
                        return PageRouteBuilder(
                            pageBuilder: (_, __, ___) => SearchPage());
                      } else if (settings.name == 'cases') {
                        return PageRouteBuilder(
                            pageBuilder: (_, __, ___) => CasesPage());
                      } else if (settings.name == 'lists') {
                        return PageRouteBuilder(
                            pageBuilder: (_, __, ___) => ListsPage());
                      } else {
                        throw 'no page to show';
                      }
                    },
                  )));
    }
  }
}
