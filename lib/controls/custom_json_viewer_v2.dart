import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../extensions/string_validations.dart';
import 'package:screensite/theme.dart';
import 'dart:convert';

// Make an enum to check for type
enum SplittingType { UNDERSCORE, WHITESPACE, CAPITAL, NONE }

class CustomJsonViewerV2 extends StatefulWidget {
  final dynamic jsonObj;
  CustomJsonViewerV2(this.jsonObj);
  @override
  _CustomJsonViewerStateV2 createState() => _CustomJsonViewerStateV2();
}

class _CustomJsonViewerStateV2 extends State<CustomJsonViewerV2> {
  @override
  Widget build(BuildContext context) {
    return getContentWidget(widget.jsonObj);
  }

  static getContentWidget(dynamic content) {
    if (content == null)
      return Text('{}');
    else if (content is List) {
      return JsonArrayViewerV2(content, notRoot: false);
    } else {
      return JsonObjectViewerV2(content, notRoot: false);
    }
  }
}

class JsonObjectViewerV2 extends StatefulWidget {
  final Map<String, dynamic> jsonObj;
  final bool notRoot;

  JsonObjectViewerV2(this.jsonObj, {this.notRoot: false});

  @override
  JsonObjectViewerStateV2 createState() => new JsonObjectViewerStateV2();
}

class JsonObjectViewerStateV2 extends State<JsonObjectViewerV2> {
  Map<String, bool> openFlag = Map();

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot) {
      return Container(
        padding: EdgeInsets.only(left: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        ),
      );
    }
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            foregroundColor: Theme.of(context).colorScheme.surface,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            copyToClipboard(jsonEncode(widget.jsonObj));
          },
          child: Text("Copy Details"),
        ),
      ],
    );
  }

  // Check if there is any kind of data
  SplittingType CheckType(String inputString) {
    var breakString = inputString.characters;
    bool checkUpperCase = false;
    bool checkLowerCase = false;
    // If we have that type, return true
    // c for capital

    if (inputString.contains('_')) {
      return SplittingType.UNDERSCORE;
    } else if (inputString.contains(' ')) {
      return SplittingType.WHITESPACE;
    } else {
      // Check if there is an uppercase and lowercase but no _, which mean Uppercase might be the connector
      // However, What happen if we have PARENT which have upper case, but no _
      for (var char in breakString) {
        if (char.toUpperCase() == char) {
          checkUpperCase = true;
        } else {
          checkLowerCase = true;
        }
      }
      // if we have both upper and lower
      if (checkUpperCase && checkLowerCase) {
        return SplittingType.CAPITAL;
      } else {
        // In this one, we have no upper case or no lower case, and no _
        return SplittingType.NONE;
      }
    }
  }

  // Replace a character and Uppercase First Letter
  String ReplaceCharacter(String inputString, SplittingType type) {
    // split by char
    String result = "";
    List<String> listChar = [];
    // c is capital, if there is no capital letter in the initial string, we split by the special keywords
    if (type == SplittingType.UNDERSCORE) {
      // _ is the connector so we split it with _
      listChar = inputString.split('_');
    } else if (type == SplittingType.WHITESPACE) {
      listChar = inputString.split(' ');
    } else {
      // We will split by capital letter with the RegExp for capital
      final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
      listChar = inputString.split(beforeCapitalLetter);
    }

    listChar.forEach((element) {
      if (result.length > 1) {
        result = result + " " + element.capitalize();
      } else {
        result = result + element.capitalize();
      }
    });

    return result;
  }

  // Convert Entry data to better UI
  String ConvertEntryData(String inputString) {
    // First, find whether we have "_"
    if (CheckType(inputString) != SplittingType.NONE) {
      return ReplaceCharacter(inputString, CheckType(inputString));
    } else {
      return inputString.capitalize();
    }
  }

// Old Code
  // _getList() {
  //   List<Widget> list = [];
  //   for (MapEntry entry in widget.jsonObj.entries) {
  //     bool ex = isExtensible(entry.value);
  //     bool ink = isInkWell(entry.value);

  //     list.add(Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         ex
  //             ? ((openFlag[entry.key] ?? false)
  //                 ? Icon(
  //                     Icons.arrow_drop_down,
  //                     size: 14,
  //                   ) //, color: Color.fromARGB(255, 13, 13, 13))
  //                 : Icon(
  //                     Icons.arrow_right,
  //                     size: 14,
  //                   )) //, color: Color.fromARGB(255, 10, 10, 10)))
  //             : const Icon(
  //                 Icons.arrow_right,
  //                 // color: Color.fromARGB(0, 0, 0, 0),
  //                 size: 14,
  //               ),
  //         (ex && ink)
  //             ? InkWell(
  //                 child: Text(
  //                   entry.key.runtimeType == String
  //                       ? ConvertEntryData(entry.key)
  //                       : entry.key,
  //                   style: Theme.of(context).textTheme.titleSmall,
  //                 ),
  //                 // style: TextStyle(color: Colors.purple[900])),
  //                 onTap: () {
  //                   setState(() {
  //                     openFlag[entry.key] = !(openFlag[entry.key] ?? false);
  //                   });
  //                 })
  //             : Text(
  //                 entry.key.runtimeType == String
  //                     ? ConvertEntryData(entry.key)
  //                     : entry.key,
  //                 style: Theme.of(context).textTheme.titleSmall),
  //         Text(
  //           ':',
  //           style: Theme.of(context).textTheme.titleSmall,
  //         ),
  //         const SizedBox(width: 3),
  //         getValueWidget(entry)
  //       ],
  //     ));
  //     list.add(const SizedBox(height: 4));
  //     if (openFlag[entry.key] ?? false) {
  //       list.add(getContentWidget(entry.value));
  //     }
  //   }
  //   return list;
  // }

// V2 Code : Error persists even after commenting and puting old version of cuntion
  _getList() {
    List<Widget> list = [];
    List dataList = widget.jsonObj.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key));
    for (MapEntry entry in dataList) {
      bool ex = isExtensible(entry.value);
      bool ink = isInkWell(entry.value);

      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          (ex && ink)
              ? Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Row(
                    children: [
                      ((openFlag[entry.key] ?? false)
                          ? Icon(
                              Icons.arrow_drop_down,
                              size: 20,
                            )
                          : Icon(
                              Icons.arrow_right,
                              size: 20,
                            )),
                      InkWell(
                          child: Text(
                            entry.key.runtimeType == String
                                ? ConvertEntryData(entry.key)
                                : entry.key,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
  
                          onTap: () {
                            setState(() {
                              openFlag[entry.key] =
                                  !(openFlag[entry.key] ?? false);
                            });
                          }),
                      Container(
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                        margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            borderRadius: BorderRadius.circular(40)),
                        child: Text(
                          entry.value.length.toString(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.fontSize),
                        ),
                      )
                    ],
                  ),
                )
              : Expanded(
                  child: Text(
                    entry.key.runtimeType == String
                        ? ConvertEntryData(entry.key)
                        : entry.key,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize:
                            Theme.of(context).textTheme.titleSmall?.fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ),
          getValueWidget(entry),
        ],
      ));
      list.add(const SizedBox(height: 8));
      if (openFlag[entry.key] ?? false) {
        list.add(entry.value is List
            ? JsonArrayViewerV2(
                entry.value,
                notRoot: true,
              )
            : JsonObjectViewerV2(
                entry.value,
                notRoot: true,
              ));
      }
    }
    return list;
  }

  static getContentWidget(dynamic content) {
    if (content is List) {
      return JsonArrayViewerV2(content, notRoot: true);
    } else {
      return JsonObjectViewerV2(content, notRoot: true);
    }
  }

  static isInkWell(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    } else if (content is List) {
      if (content.isEmpty) {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  // Old code from V1
  getValueWidget(MapEntry entry) {
    if (entry.value == null) {
      return Expanded(
          child: Text(
        '', style: Theme.of(context).textTheme.titleSmall,
        // style: TextStyle(color: Color.fromARGB(255, 13, 13, 13)),
      ));
    } else if (entry.value is int) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(entry.value.toString());
              },
              child: Text(
                entry.value.toString(),
                style: Theme.of(context).textTheme.titleSmall,
              )));
    } else if (entry.value is String) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(entry.value.toString());
              },
              child: Text(
                entry.value,
                style: Theme.of(context).textTheme.titleSmall,
              )));
    } else if (entry.value is bool) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(entry.value.toString());
              },
              child: Text(
                entry.value.toString(),
                style: Theme.of(context).textTheme.titleSmall,
              )));
    } else if (entry.value is double) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(entry.value.toString());
              },
              child: Text(
                entry.value.toString(),
                style: Theme.of(context).textTheme.titleSmall,
              )));
    } else if (entry.value is List) {
      if (entry.value.isEmpty) {
        return GestureDetector(
            onTap: () {
              copyToClipboard("");
            },
            child: Text(
              'Empty',
              style: Theme.of(context).textTheme.titleSmall,
            ));
      } else {
        return InkWell(
            child: GestureDetector(
                onTap: () {
                  // Clipboard.setData(ClipboardData(
                  //     text:
                  //         'Array<${getTypeName(entry.value[0])}>[${entry.value.length}]'));
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   content: Text('Text copied to clipboard'),
                  // ));
                },
                child: Text(
                  // 'Array<${getTypeName(entry.value[0])}>[${entry.value.length}]',
                  " ",
                  style: Theme.of(context).textTheme.titleSmall,
                )),
            onTap: () {
              setState(() {
                openFlag[entry.key] = !(openFlag[entry.key] ?? false);
              });
            });
      }
    }
    return InkWell(
        child: GestureDetector(
            onTap: () {
              // Clipboard.setData(ClipboardData(text: 'Object'));
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text('Text copied to clipboard'),
              // ));
            },
            child: Text(
              '',
              style: Theme.of(context).textTheme.titleSmall,
              // style: TextStyle(color: Colors.grey),
            )),
        onTap: () {
          setState(() {
            openFlag[entry.key] = !(openFlag[entry.key] ?? false);
          });
        });
  }


  // V2 Code Potentially causing minified:kh error

  // getValueWidget(MapEntry entry) {
  //   if (entry.value == null) {
  //     return Expanded(
  //         child: Text(
  //       '',
  //       style: Theme.of(context).textTheme.titleSmall,
  //     ));
  //   } else if (entry.value is int) {
  //     return Expanded(
  //         child: GestureDetector(
  //             onTap: () {
  //               copyToClipboard(entry.value.toString());
  //             },
  //             child: Text(
  //               entry.value.toString(),
  //               style: Theme.of(context).textTheme.titleSmall,
  //             )));
  //   } else if (entry.value is String) {
  //     return Expanded(
  //       child: GestureDetector(
  //         onTap: () {
  //           copyToClipboard(entry.value.toString());
  //         },
  //         child: Text(
  //           entry.value,
  //           style: Theme.of(context).textTheme.titleSmall,
  //         ),
  //       ),
  //     );
  //   } else if (entry.value is bool) {
  //     return Expanded(
  //         child: GestureDetector(
  //             onTap: () {
  //               copyToClipboard(entry.value.toString());
  //             },
  //             child: Text(
  //               entry.value.toString(),
  //               style: Theme.of(context).textTheme.titleSmall,
  //             )));
  //   } else if (entry.value is double) {
  //     return Expanded(
  //         child: GestureDetector(
  //             onTap: () {
  //               copyToClipboard(entry.value.toString());
  //             },
  //             child: Text(
  //               entry.value.toString(),
  //               style: Theme.of(context).textTheme.titleSmall,
  //             )));
  //   } else if (entry.value is List) {
  //     if (entry.value.isEmpty) {
  //       return GestureDetector(
  //           onTap: () {
  //             copyToClipboard("");
  //           },
  //           child: Text(
  //             '',
  //             style: Theme.of(context).textTheme.titleSmall,
  //           ));
  //     } else {
  //       return InkWell(
  //           child: Expanded(

  //             child: GestureDetector(
  //                 onTap: () {
  //                   copyToClipboard(entry.value.toString());
  //                 },
  //                 child: Text('')),
  //           ),
  //           onTap: () {
  //             setState(() {
  //               openFlag[entry.key] = !(openFlag[entry.key] ?? false);
  //             });
  //           });
  //     }
  //   }
  //   return InkWell(
  //       child: GestureDetector(
  //           child: Text(
  //         '',
  //         style: Theme.of(context).textTheme.titleSmall,
  //       )),
  //       onTap: () {
  //         setState(() {
  //           openFlag[entry.key] = !(openFlag[entry.key] ?? false);
  //         });
  //       });
  // }

  static isExtensible(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    }
    return true;
  }

  static getTypeName(dynamic content) {
    if (content is int) {
      return 'int';
    } else if (content is String) {
      return 'String';
    } else if (content is bool) {
      return 'bool';
    } else if (content is double) {
      return 'double';
    } else if (content is List) {
      return 'List';
    }
    return 'Object';
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Text copied to clipboard'),
      ));
    });
  }
}

class JsonArrayViewerV2 extends StatefulWidget {
  final List<dynamic> jsonArray;

  final bool notRoot;

  JsonArrayViewerV2(this.jsonArray, {this.notRoot: false});

  @override
  _JsonArrayViewerStateV2 createState() => new _JsonArrayViewerStateV2();
}

class _JsonArrayViewerStateV2 extends State<JsonArrayViewerV2> {
  late List<bool> openFlag;

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot) {
      return Container(
          padding: EdgeInsets.only(left: 14.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getList()));
    }
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        ),
        ElevatedButton(
          onPressed: () {
            copyToClipboard(jsonEncode(widget.jsonArray));
          },
          child: Text("Copy Details"),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    openFlag = List.filled(widget.jsonArray.length, false);
  }

  _getList() {
    List<Widget> list = [];
    int i = 0;
    for (dynamic content in widget.jsonArray) {
      bool ex = JsonObjectViewerStateV2.isExtensible(content);
      bool ink = JsonObjectViewerStateV2.isInkWell(content);
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          (ex && ink)
              ? ((openFlag[i])
                  ? Icon(
                      Icons.arrow_drop_down,
                      size: 14,
                    )
                  // color: Colors.grey[700])
                  : Icon(
                      Icons.arrow_right,
                      size: 14,
                    ))
              //  color: Colors.grey[700]))
              : Text(''),
          (ex && ink)
              ? getInkWell(i)
              : Text(
                  '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
          const SizedBox(width: 3),
          getValueWidget(content, i)
        ],
      ));
      list.add(const SizedBox(height: 4));
      if (openFlag[i]) {
        list.add(JsonObjectViewerStateV2.getContentWidget(content));
      }
      i++;
    }
    return list;
  }

  getInkWell(int index) {
    return InkWell(
        child: Text(
          '${index + 1} ',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        onTap: () {
          setState(() {
            openFlag[index] = !(openFlag[index]);
          });
        });
  }

  getValueWidget(dynamic content, int index) {
    if (content == null) {
      return Expanded(
          child: Text(
        'Empty',
        style: Theme.of(context).textTheme.titleSmall,
      ));
    } else if (content is int) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(content.toString());
              },
              child: Text(
                content.toString(),
                style: Theme.of(context).textTheme.titleSmall,
              )));
    } else if (content is String) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(content);
              },
              child: Text(
                content,
                style: Theme.of(context).textTheme.titleSmall,
              )));
    } else if (content is bool) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(content.toString());
              },
              child: Text(
                content.toString(),
                style: Theme.of(context).textTheme.titleSmall,
              )));
    } else if (content is double) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(content.toString());
              },
              child: Text(
                content.toString(),
                style: Theme.of(context).textTheme.titleSmall,
              )));
    } else if (content is List) {
      if (content.isEmpty) {
        return Text(
          '',
          style: Theme.of(context).textTheme.titleSmall,
        );
      } else {
        return InkWell(
            child: Text(
              'Array<${JsonObjectViewerStateV2.getTypeName(content)}>[${content.length}]',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onTap: () {
              setState(() {
                openFlag[index] = !(openFlag[index]);
              });
            });
      }
    }
    return InkWell(
        child: Text(
          '',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        onTap: () {
          setState(() {
            openFlag[index] = !(openFlag[index]);
          });
        });
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Text copied to clipboard'),
      ));
    });
  }
}
