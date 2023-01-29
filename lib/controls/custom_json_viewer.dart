import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../extensions/string_validations.dart';
import 'package:screensite/theme.dart';
import 'dart:convert';

// Make an enum to check for type
enum SplittingType { UNDERSCORE, CAPITAL, NONE }

class CustomJsonViewer extends StatefulWidget {
  final dynamic jsonObj;
  CustomJsonViewer(this.jsonObj);
  @override
  _CustomJsonViewerState createState() => _CustomJsonViewerState();
}

class _CustomJsonViewerState extends State<CustomJsonViewer> {
  @override
  Widget build(BuildContext context) {
    return getContentWidget(widget.jsonObj);
  }

  static getContentWidget(dynamic content) {
    if (content == null)
      return Text('{}');
    else if (content is List) {
      return JsonArrayViewer(content, notRoot: false);
    } else {
      return JsonObjectViewer(content, notRoot: false);
    }
  }
}

class JsonObjectViewer extends StatefulWidget {
  final Map<String, dynamic> jsonObj;
  final bool notRoot;

  JsonObjectViewer(this.jsonObj, {this.notRoot: false});

  @override
  JsonObjectViewerState createState() => new JsonObjectViewerState();
}

class JsonObjectViewerState extends State<JsonObjectViewer> {
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

  _getList() {
    List<Widget> list = [];
    for (MapEntry entry in widget.jsonObj.entries) {
      bool ex = isExtensible(entry.value);
      bool ink = isInkWell(entry.value);

      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ex
              ? ((openFlag[entry.key] ?? false)
                  ? Icon(Icons.arrow_drop_down,
                      size: 14) //, color: Color.fromARGB(255, 13, 13, 13))
                  : Icon(Icons.arrow_right,
                      size: 14)) //, color: Color.fromARGB(255, 10, 10, 10)))
              : const Icon(
                  Icons.arrow_right,
                  // color: Color.fromARGB(0, 0, 0, 0),
                  size: 14,
                ),
          (ex && ink)
              ? InkWell(
                  child: Text(
                      entry.key.runtimeType == String
                          ? ConvertEntryData(entry.key)
                          : entry.key,
                      style: Theme.of(context).textTheme.titleSmall),
                  // style: TextStyle(color: Colors.purple[900])),
                  onTap: () {
                    setState(() {
                      openFlag[entry.key] = !(openFlag[entry.key] ?? false);
                    });
                  })
              : Text(
                  entry.key.runtimeType == String
                      ? ConvertEntryData(entry.key)
                      : entry.key,
                  style: Theme.of(context).textTheme.titleSmall),
          Text(
            ':',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(width: 3),
          getValueWidget(entry)
        ],
      ));
      list.add(const SizedBox(height: 4));
      if (openFlag[entry.key] ?? false) {
        list.add(getContentWidget(entry.value));
      }
    }
    return list;
  }

  static getContentWidget(dynamic content) {
    if (content is List) {
      return JsonArrayViewer(content, notRoot: true);
    } else {
      return JsonObjectViewer(content, notRoot: true);
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

  getValueWidget(MapEntry entry) {
    if (entry.value == null) {
      return Expanded(
          child: Text(
        '',
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
                style: Theme.of(context).textTheme.subtitle2,
              )));
    } else if (entry.value is String) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(entry.value.toString());
              },
              child: Text(
                '\"' + entry.value + '\"',
                style: Theme.of(context).textTheme.subtitle2,
              )));
    } else if (entry.value is bool) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(entry.value.toString());
              },
              child: Text(
                entry.value.toString(),
                style: Theme.of(context).textTheme.subtitle2,
              )));
    } else if (entry.value is double) {
      return Expanded(
          child: GestureDetector(
              onTap: () {
                copyToClipboard(entry.value.toString());
              },
              child: Text(
                entry.value.toString(),
                style: Theme.of(context).textTheme.subtitle2,
              )));
    } else if (entry.value is List) {
      if (entry.value.isEmpty) {
        return GestureDetector(
            onTap: () {
              copyToClipboard("");
            },
            child: Text(
              'Empty',
              style: Theme.of(context).textTheme.subtitle2,
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
                  style: Theme.of(context).textTheme.subtitle2,
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
              // style: TextStyle(color: Colors.grey),
            )),
        onTap: () {
          setState(() {
            openFlag[entry.key] = !(openFlag[entry.key] ?? false);
          });
        });
  }

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

class JsonArrayViewer extends StatefulWidget {
  final List<dynamic> jsonArray;

  final bool notRoot;

  JsonArrayViewer(this.jsonArray, {this.notRoot: false});

  @override
  _JsonArrayViewerState createState() => new _JsonArrayViewerState();
}

class _JsonArrayViewerState extends State<JsonArrayViewer> {
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
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
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
      bool ex = JsonObjectViewerState.isExtensible(content);
      bool ink = JsonObjectViewerState.isInkWell(content);
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ex
              ? ((openFlag[i])
                  ? Icon(Icons.arrow_drop_down, size: 14)
                  // color: Colors.grey[700])
                  : Icon(Icons.arrow_right, size: 14))
              //  color: Colors.grey[700]))
              : const Icon(
                  Icons.arrow_right, //color: Color.fromARGB(0, 0, 0, 0)
                  // size: 14,
                ),
          (ex && ink)
              ? getInkWell(i)
              : Text('[$i]', style: Theme.of(context).textTheme.subtitle2),
          Text(
            ':',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(width: 3),
          getValueWidget(content, i)
        ],
      ));
      list.add(const SizedBox(height: 4));
      if (openFlag[i]) {
        list.add(JsonObjectViewerState.getContentWidget(content));
      }
      i++;
    }
    return list;
  }

  getInkWell(int index) {
    return InkWell(
        child: Text('[$index]', style: Theme.of(context).textTheme.subtitle2),
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
        style: Theme.of(context).textTheme.subtitle2,
      ));
    } else if (content is int) {
      return Expanded(
          child: Text(
        content.toString(),
        style: Theme.of(context).textTheme.subtitle2,
      ));
    } else if (content is String) {
      return Expanded(
          child: Text(
        '\"' + content + '\"',
        style: Theme.of(context).textTheme.subtitle2,
      ));
    } else if (content is bool) {
      return Expanded(
          child: Text(
        content.toString(),
        style: Theme.of(context).textTheme.subtitle2,
      ));
    } else if (content is double) {
      return Expanded(
          child: Text(
        content.toString(),
        style: Theme.of(context).textTheme.subtitle2,
      ));
    } else if (content is List) {
      if (content.isEmpty) {
        return Text(
          '',
          style: Theme.of(context).textTheme.subtitle2,
        );
      } else {
        return InkWell(
            child: Text(
              'Array<${JsonObjectViewerState.getTypeName(content)}>[${content.length}]',
              style: Theme.of(context).textTheme.subtitle2,
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
          style: Theme.of(context).textTheme.subtitle2,
        ),
        onTap: () {
          setState(() {
            openFlag[index] = !(openFlag[index]);
          });
        });
  }
}
