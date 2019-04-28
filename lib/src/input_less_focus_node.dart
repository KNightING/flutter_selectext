import 'package:flutter/widgets.dart';

/// InputlessFocusNode is a FocusNode that does not consume the keyboard token,
/// thereby preventing the keyboard from coming up when the node is focused
class InputlessFocusNode extends FocusNode {
  // this is a special override needed, because the EditableText class creates
  // a TextInputConnection if the node has focus to force the keyboard to come up
  // this override will cause our FocusNode to pretend it doesn't have focus
  // when needed
  bool overrideFocus;

  @override
  bool get hasFocus => overrideFocus ?? super.hasFocus;

  @override
  bool consumeKeyboardToken() {
    return false;
  }
}