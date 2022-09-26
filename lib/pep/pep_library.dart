import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final activePep = StateNotifierProvider<GenericStateNotifier<String?>, String?>(
    (ref) => GenericStateNotifier<String?>(null));

class PepLibraryPage extends ConsumerStatefulWidget {
  const PepLibraryPage({Key? key}) : super(key: key);

  @override
  _PepLibraryPageState createState() => _PepLibraryPageState();
}

class _PepLibraryPageState extends ConsumerState<PepLibraryPage> {
  bool valuecheck = false;
  bool valuecheck1 = false;
  bool valuecheckV = false;
// Initial Selected Value
  String dropdownvalue = 'Australia';

  // List of items in our dropdown menu
  var items = [
    'Australia',
    'New Zealand',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(activePep);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        body: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(20),
            child: Column(children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 10), //SizedBox
                      /** Checkbox Widget **/
                      Checkbox(
                        value: valuecheck,
                        onChanged: (bool? value) {
                          setState(() {
                            valuecheck = value!;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ), //SizedBox
                      Text(
                        'Show Wrong',
                        style: TextStyle(fontSize: 17.0),
                      ),
                      SizedBox(width: 10), //SizedBox
                      /** Checkbox Widget **/
                      Checkbox(
                        value: valuecheck1,
                        onChanged: (bool? value2) {
                          setState(() {
                            valuecheck1 = value2!;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Show Right',
                        style: TextStyle(fontSize: 17.0),
                      ),
                      SizedBox(width: 10), //SizedBox
                      /** Checkbox Widget **/
                      Checkbox(
                        value: valuecheckV,
                        onChanged: (bool? value3) {
                          setState(() {
                            valuecheckV = value3!;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Needs Verification',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: SizedBox(
                            width: 300,
                            height: 100,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    10), //apply padding to all four sides
                                            child: Text("https://"))),
                                    Expanded(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              icon: Icon(Icons.help_outline),
                                              hoverColor:
                                                  Colors.white.withOpacity(0.3),
                                              onPressed: () {},
                                            )))
                                  ]),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Right'),
                                                Text('4 people')
                                              ]),
                                        ),
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Last updated:'),
                                                Text('Created:')
                                              ]),
                                        )
                                      ])
                                ],
                              ),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Card(
                          child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              10), //apply padding to all four sides
                                      child: Text("https://"))
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              10), //apply padding to all four sides
                                      child: Text('Last updated:'))
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              10), //apply padding to all four sides
                                      child: Text('Last source change:'))
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              10), //apply padding to all four sides
                                      child: Text('Last fetch change:'))
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              10), //apply padding to all four sides
                                      child: Text('When data broke:'))
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 500,
                                      height: 300,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 236, 238, 240))),
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.all(5),
                                      child: Text(
                                        "text",
                                      ))
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('Re-fetch'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ))),
                ],
              )
            ])));
  }
}
