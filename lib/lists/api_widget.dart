import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common.dart';

class APIWidget extends StatelessWidget {
  const APIWidget({
    super.key,
    required this.entityId,
  });

  final String entityId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: TextButton(
          child: Text("API"),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  final _formKey = GlobalKey<FormState>();
                  return AlertDialog(
                    scrollable: true,
                    title: Text('API Details'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text("curl: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Expanded(
                                              child: Container(
                                                  child: Text(generateCurlUrl(
                                                      "GET", entityId))),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            ElevatedButton(
                                              child: Text("copy"),
                                              onPressed: () async => {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: generateCurlUrl(
                                                            "GET", entityId)))
                                              },
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text("url: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Expanded(
                                              child: Container(
                                                child: Text(generateBrowserUrl(
                                                    entityId)),
                                              ),
                                            ),
                                            ElevatedButton(
                                              child: Text("copy"),
                                              onPressed: () async => {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text:
                                                            generateBrowserUrl(
                                                                entityId)))
                                              },
                                            ),
                                          ],
                                        )),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Done'),
                      )
                    ],
                  );
                });
          },
        ))
      ],
    );
  }
}
