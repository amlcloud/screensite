import 'package:common/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';
import 'package:sandbox/sandbox_launcher2.dart';
import 'package:screensite/sandbox_app.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:theme/config.dart';
import 'firebase_options.dart';
import 'main_app_widget.dart';

void main() async {
  Chain.capture(() async {
    WidgetsFlutterBinding.ensureInitialized();

    ThemeModeConfig.enableSave = true;
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
