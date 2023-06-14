
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_driver/src/driver/driver.dart';
import 'package:screensite/main.dart' as app;


late FlutterDriver driver;
void main() {
  setUpAll(() async {
    print('***************');
    app.main();
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });


  test('AML App URL', () async {
    final appUrl = Uri.base.toString();
     print('Application URL----------->: $appUrl');
  });
}
