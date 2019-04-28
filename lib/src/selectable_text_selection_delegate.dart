import 'package:flutter/widgets.dart';

/// _TextSelectionDelegateHelper is used to ensure the Cut option in the toolbar
/// doesn't show, and a Paste operation does nothing
abstract class SelectableTextSelectionDelegate extends TextSelectionDelegate {

  int _overrideCollapsed = 0;

  TextEditingValue get textEditingValue {
    // as soon as this helper class is instantiated, canCut(), canCopy(), and canPaste()
    // will get called. Both canCut() and canCopy() will call this delegate getter
    // so we can return a collapsed value on the first call
    // Unfortunately, the canPaste() call returns true and there's no way to do anything
    // to prevent that, short of copying all the code from cupertino/text_selection.dart
    if (_overrideCollapsed < 1) {
      _overrideCollapsed++;
      return textEditingValue
          .copyWith(selection: TextSelection.collapsed(offset: 0));
    }
    return textEditingValue;
  }

  set textEditingValue(TextEditingValue value) {
    // because we can't disable the Paste toolbar option, let's make sure we don't
    // allow to actually paste data by always keeping the same text we had before
   textEditingValue =
        value.copyWith(text: textEditingValue.text);
  }

  /// 隱藏toolbar
//  void hideToolbar();

/// 顯示toolbar
///
//  void bringIntoView(TextPosition position);
}