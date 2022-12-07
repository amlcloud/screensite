import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';

final activePep = StateNotifierProvider<GenericStateNotifier<String?>, String?>(
    (ref) => GenericStateNotifier<String?>(null));

class PepAdminPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(minimumSize: const Size(250, 40));

    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // leftColumn,
                SizedBox(width: 20),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Expanded(
                        flex: 1,
                        child: Text('Country:'),
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 40)),
                          onPressed: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: false,
                              onSelect: (Country country) {
                                print('Select country: ${country.displayName}');
                              },
                              countryListTheme: CountryListThemeData(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0),
                                ),
                                inputDecoration: InputDecoration(
                                  labelText: 'Search',
                                  hintText: 'Start typing to search',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8)
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text('Select country:'),
                          // child: null,
                        ),
                      ),
                      SizedBox(height: 30),
                      Expanded(
                        flex: 1,
                        child: Text('PEP Page URL:'),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter URL',
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Expanded(
                        flex: 1,
                        child: Text('Expected:'),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(50.0),
                              color: Color.fromARGB(255, 225, 219, 219),
                              child: Text('expected output...')),
                        ),
                      ),
                      SizedBox(height: 30),
                      Expanded(
                        flex: 1,
                        child: Text('Actual:'),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(50.0),
                              color: Color.fromARGB(255, 225, 219, 219),
                              child: Text('actual output...')),
                        ),
                      ),
                      SizedBox(height: 30),
                      Expanded(
                        flex: 1,
                        child: Text('Comment:'),
                      ),
                      // SizedBox(height: 1),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(50.0),
                              color: Color.fromARGB(255, 225, 219, 219),
                              child: Text('comment output...')),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(width: 50),
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // SizedBox(height: 130),
                        Expanded(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  child: Text('Fetch!'),
                                  onPressed: () {},
                                  style: style,
                                  // ElevatedButton.styleFrom(
                                  //     minimumSize: const Size(250,40)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    child: Text('Looks Right!'),
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(125, 40)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    child: Text('Wrong!'),
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(125, 40)),
                                  ),
                                ),
                              ]),
                        ),
                        Expanded(
                          flex: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(5),
                                child: ElevatedButton(
                                  child: Text('Save to Library!'),
                                  onPressed: () {},
                                  style: style,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            )));
  }
}

final countryList = Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text('Country:'),
    // Align(
    //   child: ElevatedButton(onPressed: () {
    //     showCountryPicker(
    //       context: context,
    //       showPhoneCode: false,
    //       onSelect: (Country country) {
    //         print('Select country: ${country.displayName}');
    //       },
    //     );
    //   }),
    // )
  ],
);

final pepPageURL = Row(
  children: [
    Text('Pep Page URL:'),
    // Form
  ],
);

final expected = Row(
  children: [
    Text('Expected:'),
    // Form
  ],
);

final actual = Row(
  children: [
    Text('Actual:'),
    // Form
  ],
);

final comment = Row(
  children: [
    Text('Comment:'),
    // Form
  ],
);

final leftColumn = Container(
  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
  child: Column(
    children: [
      countryList,
      pepPageURL,
      expected,
      actual,
      comment,
    ],
  ),
);
