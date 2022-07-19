import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This is an overlay frame for debugging individual widgets
/// Unfortunately it updates on every click on the textedit field
/// or key entry. Hence, let's not use it as overlay.
class SandboxLauncher extends StatefulWidget {
  final Widget app;
  final Widget sandbox;

  const SandboxLauncher({Key? key, required this.app, required this.sandbox})
      : super(key: key);

  @override
  State<SandboxLauncher> createState() => _SandboxLauncherState();
}

class _SandboxLauncherState extends State<SandboxLauncher> {
  bool _isSandbox = false;

  @override
  Widget build(BuildContext context) => RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        // print(
        //     'Ctrl Right: ${RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.metaRight)}, Ctrl Left: ${RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.metaLeft)}');
        if (RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.metaRight) &&
            RawKeyboard.instance.keysPressed
                .contains(LogicalKeyboardKey.metaLeft)) {
          // sandbox will be shown/hidden on Left and Right Ctrl pressed at the
          // same time
          setState(() {
            _isSandbox = !_isSandbox;
          });
        }
      },
      child: _isSandbox ? widget.sandbox : widget.app);
}
