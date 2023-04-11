import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/pep/peplibrary_list.dart';
import 'package:screensite/pep/pep_list_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final activePepLib =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
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
    ref.read(activePepLib);
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
                      child: SingleChildScrollView(
                          child: Column(
                    children: [
                      PepLibrarylists(),
                    ],
                  ))),
                  Expanded(
                      child: ref.watch(activePepLib) == null
                          ? Container()
                          : PepListDetail(ref.watch(activePepLib)!)),
                ],
              )
            ])));
  }
}
