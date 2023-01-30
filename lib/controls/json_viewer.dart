import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class JsonViewer extends StatefulWidget {
  final dynamic jsonObj;
  JsonViewer(this.jsonObj);
  @override
  _JsonViewerState createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
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
                  ? Icon(
                      Icons.arrow_drop_down,
                      size: 14,
                      color: Colors.grey, // Colors.grey[700]
                    )
                  : Icon(
                      Icons.arrow_right,
                      size: 14,
                      color: Colors.grey, // Colors.grey
                    ))
              : const Icon(
                  Icons.arrow_right,
                  color: Colors.grey, // Color.fromARGB(0, 0, 0, 0)
                  size: 14,
                ),
          (ex && ink)
              ? InkWell(
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 85, 157, 207), // Colors.purple[900]
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      openFlag[entry.key] = !(openFlag[entry.key] ?? false);
                    });
                  },
                )
              : Text(
                  entry.key,
                  style: TextStyle(
                    color: Color.fromARGB(255, 85, 157,
                        207), // entry.value == null ? Colors.grey : Colors.purple[900]
                  ),
                ),
          Text(
            ':',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
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
          'undefined',
          style: TextStyle(
            color: Color.fromARGB(255, 197, 101, 95), // Colors.grey
          ),
        ),
      );
    } else if (entry.value is int) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            copyToClipboard(entry.value.toString());
          },
          child: Text(
            entry.value.toString(),
            style: TextStyle(
              color: Color.fromARGB(255, 170, 101, 181), // Colors.teal
            ),
          ),
        ),
      );
    } else if (entry.value is String) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            copyToClipboard(entry.value.toString());
          },
          child: Text(
            '\"' + entry.value + '\"',
            style: TextStyle(
                color: Color.fromARGB(255, 97, 168, 100)), // Colors.redAccent
          ),
        ),
      );
    } else if (entry.value is bool) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            copyToClipboard(entry.value.toString());
          },
          child: Text(
            entry.value.toString(),
            style: TextStyle(
                color: Color.fromARGB(255, 196, 93, 132)), // Colors.purple
          ),
        ),
      );
    } else if (entry.value is double) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            copyToClipboard(entry.value.toString());
          },
          child: Text(
            entry.value.toString(),
            style: TextStyle(
              color: Color.fromARGB(255, 154, 125, 192), // Colors.teal
            ),
          ),
        ),
      );
    } else if (entry.value is List) {
      if (entry.value.isEmpty) {
        return GestureDetector(
          onTap: () {
            copyToClipboard('Array[0]');
          },
          child: Text(
            'Array[0]',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        );
      } else {
        return InkWell(
          child: GestureDetector(
            onTap: () {
              copyToClipboard(
                  'Array<${getTypeName(entry.value[0])}>[${entry.value.length}]');
            },
            child: Text(
              'Array<${getTypeName(entry.value[0])}>[${entry.value.length}]',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          onTap: () {
            setState(() {
              openFlag[entry.key] = !(openFlag[entry.key] ?? false);
            });
          },
        );
      }
    }
    return InkWell(
      child: GestureDetector(
        onTap: () {
          copyToClipboard('Object');
        },
        child: Text(
          'Object',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          openFlag[entry.key] = !(openFlag[entry.key] ?? false);
        });
      },
    );
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
      bool ex = JsonObjectViewerState.isExtensible(content);
      bool ink = JsonObjectViewerState.isInkWell(content);
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ex
              ? ((openFlag[i])
                  ? Icon(
                      Icons.arrow_drop_down,
                      size: 14,
                      color: Colors.grey, // Colors.grey[700]
                    )
                  : Icon(
                      Icons.arrow_right,
                      size: 14,
                      color: Colors.grey, // Colors.grey[700]
                    ))
              : const Icon(
                  Icons.arrow_right,
                  color: Colors.grey, // Color.fromARGB(0, 0, 0, 0)
                  size: 14,
                ),
          (ex && ink)
              ? getInkWell(i)
              : Text(
                  '[$i]',
                  style: TextStyle(
                    color: Color.fromARGB(255, 85, 157,
                        207), // content == null ? Colors.grey : Colors.purple[900]
                  ),
                ),
          Text(
            ':',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
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
      child: Text(
        '[$index]',
        style: TextStyle(
          color: Color.fromARGB(255, 85, 147, 207), // Colors.purple[900]
        ),
      ),
      onTap: () {
        setState(() {
          openFlag[index] = !(openFlag[index]);
        });
      },
    );
  }

  getValueWidget(dynamic content, int index) {
    if (content == null) {
      return Expanded(
        child: Text(
          'undefined',
          style: TextStyle(
            color: Color.fromARGB(255, 197, 101, 95), // Colors.grey
          ),
        ),
      );
    } else if (content is int) {
      return Expanded(
        child: Text(
          content.toString(),
          style: TextStyle(
            color: Color.fromARGB(255, 143, 76, 154), // Colors.teal
          ),
        ),
      );
    } else if (content is String) {
      return Expanded(
        child: Text(
          '\"' + content + '\"',
          style: TextStyle(
            color: Color.fromARGB(255, 97, 168, 100), // Colors.redAccent
          ),
        ),
      );
    } else if (content is bool) {
      return Expanded(
        child: Text(
          content.toString(),
          style: TextStyle(
            color: Color.fromARGB(255, 196, 93, 132), // Colors.purple
          ),
        ),
      );
    } else if (content is double) {
      return Expanded(
        child: Text(
          content.toString(),
          style: TextStyle(
            color: Color.fromARGB(255, 127, 100, 165), // Colors.teal
          ),
        ),
      );
    } else if (content is List) {
      if (content.isEmpty) {
        return Text(
          'Array[0]',
          style: TextStyle(
            color: Colors.grey,
          ),
        );
      } else {
        return InkWell(
          child: Text(
            'Array<${JsonObjectViewerState.getTypeName(content)}>[${content.length}]',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          onTap: () {
            setState(() {
              openFlag[index] = !(openFlag[index]);
            });
          },
        );
      }
    }
    return InkWell(
      child: Text(
        'Object',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      onTap: () {
        setState(() {
          openFlag[index] = !(openFlag[index]);
        });
      },
    );
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Text copied to clipboard'),
      ));
    });
  }
}
