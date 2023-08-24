import 'package:common/common.dart';
import 'package:flutter/foundation.dart';
import '_exports.dart';

void main() async {
  Chain.capture(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ThemeModeConfig.enableSave = true;
    ThemeModeConfig.defaultToLightTheme = true;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kReleaseMode) {
      await dotenv.load(fileName: "assets/env.production");
    } else {
      await dotenv.load(fileName: "assets/env.development");
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
  }, onError: (error, Chain chain) {
    // print('Caught error $error\nStack trace: ${Trace.format(new Chain.forTrace(chain))}');
    print('ERROR: $error\n${condenseError(error, chain)}');
  });
}

final isLoggedIn = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

final isLoading = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));
