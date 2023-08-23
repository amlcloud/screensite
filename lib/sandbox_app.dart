import 'package:common/common.dart';
import '_exports.dart';

class SandboxApp extends StatelessWidget {
  SandboxApp({Key? key}) : super(key: key);

  final SNP<Map<String, dynamic>?> _nsp = snp<Map<String, dynamic>?>(null);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [],
      child: DefaultTabController(
        length: 3, //MyAppBar.tabs.length,
        child: MaterialApp(
            theme: ThemeData.light(), // darkTheme,
            darkTheme: ThemeData.dark(), // darkTheme,
            themeMode: ThemeMode.dark,
            title: "SANDBOX!",
            home: Scaffold(
                body: SizedBox(
                    width: 800,
                    height: 600,
                    child:
                        // MatchesWidget(kDB.doc(
                        //     '/user/AA4JoO0fvSWtTxeROjRhTUYMIY52/case/hBjBqqeDDH0d27uNDfpb'))
                        InvestigationWidget(
                      kDB.doc(
                          '/user/AA4JoO0fvSWtTxeROjRhTUYMIY52/case/7KwD1DNdCYARJmjYaA5w'),
                      kDB.doc(
                          "/user/AA4JoO0fvSWtTxeROjRhTUYMIY52/case/7KwD1DNdCYARJmjYaA5w/search/Abd al-Rahman bin 'Amir al-Nu'aymi"),
                    )
                    // Text('hello')
                    //CasesPage()
                    //ListDetails('api.trade.gov', null)
                    //ListDetails('api.trade.gov', _nsp.notifier)
                    ))),
      ),
    );
  }
}
