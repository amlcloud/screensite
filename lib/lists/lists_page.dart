import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screensite/app_bar.dart';
import 'package:screensite/lists/lists_list.dart';
import 'package:screensite/lists/list_details.dart';
import 'package:screensite/state/generic_state_notifier.dart';
import 'package:screensite/drawer.dart';
import 'package:screensite/common.dart';
import '../controls/custom_json_viewer.dart';
// import 'package:flutter_json_viewer/flutter_json_viewer.dart';

final activeList =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

final selectedItem = StateNotifierProvider<
        GenericStateNotifier<Map<String, dynamic>?>, Map<String, dynamic>?>(
    (ref) => GenericStateNotifier<Map<String, dynamic>?>(null));

class ListsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    children: [
                      Lists(),
                    ],
                  ))),
                  Expanded(
                    child: ref.watch(activeList) == null
                        ? Container()
                        : ListDetails(
                            ref.watch(activeList)!, selectedItem.notifier),
                  ),
                  Expanded(
                      child: Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ref.watch(selectedItem) == null
                                      ? Container()
                                      // Calling SwitchJSON widget and passing selectedItem to display
                                      : SwitchJSON(
                                          passed_ref: ref.watch(selectedItem)))
                            ],
                          ),
                        ))
                      ])))
                ])));
  }
}

// Statefull widget for JSON Viewer, shows data in JSON format of Userfriendly format depending on users choice
class SwitchJSON extends StatefulWidget {
  const SwitchJSON({Key? key, required this.passed_ref}) : super(key: key);
  // Declaring variable with passed data
  final dynamic passed_ref;

  @override
  State<SwitchJSON> createState() => _SwitchJSON();
}

// Switch's state
class _SwitchJSON extends State<SwitchJSON> {
  bool isSwitched = false;

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
  }

// JSON viewer
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'JSON data',
              style: TextStyle(color: Colors.black),
            ),
            Switch(
              onChanged: toggleSwitch,
              value: isSwitched,
            )
          ],
        ),
        Container(
            child: (isSwitched == true)
                ? JsonViewer(widget.passed_ref)
                // Widget with prittier data should go here
                : Text('Hello')),
      ],
    );
  }
}
