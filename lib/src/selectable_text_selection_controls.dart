import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_selectext/src/selectable_text_selection_delegate.dart';

/// Copy from [TextSelectionControls]
/// An interface for building the selection UI, to be provided by the
/// implementor of the toolbar widget.
/// delete cut, paste
abstract class SelectableTextSelectionControls {
  /// Builds a selection handle of the given type.
  ///
  /// The top left corner of this widget is positioned at the bottom of the
  /// selection position.
  Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textLineHeight);

  /// Builds a toolbar near a text selection.
  ///
  /// Typically displays buttons for copying and pasting text.
  Widget buildToolbar(BuildContext context, Rect globalEditableRegion, Offset position, SelectableTextSelectionDelegate delegate);

  /// Returns the size of the selection handle.
  Size get handleSize;

  /// Whether the current selection of the text field managed by the given
  /// `delegate` can be removed from the text field and placed into the
  /// [Clipboard].
  ///
  /// By default, false is returned when nothing is selected in the text field.
  ///
  /// Subclasses can use this to decide if they should expose the cut
  /// functionality to the user.
//  bool canCut(TextSelectionDelegate delegate) {
//    return !delegate.textEditingValue.selection.isCollapsed;
//  }

  bool isTextSelection(SelectableTextSelectionDelegate delegate){
    return !delegate.textEditingValue.selection.isCollapsed;
  }

  /// Whether the current selection of the text field managed by the given
  /// `delegate` can be copied to the [Clipboard].
  ///
  /// By default, false is returned when nothing is selected in the text field.
  ///
  /// Subclasses can use this to decide if they should expose the copy
  /// functionality to the user.
  bool canCopy(SelectableTextSelectionDelegate delegate) {
    return isTextSelection(delegate);
  }

  /// Whether the current [Clipboard] content can be pasted into the text field
  /// managed by the given `delegate`.
  ///
  /// Subclasses can use this to decide if they should expose the paste
  /// functionality to the user.
//  bool canPaste(TextSelectionDelegate delegate) {
//    // TODO(goderbauer): return false when clipboard is empty, https://github.com/flutter/flutter/issues/11254
//    return true;
//  }

  /// Whether the current selection of the text field managed by the given
  /// `delegate` can be extended to include the entire content of the text
  /// field.
  ///
  /// Subclasses can use this to decide if they should expose the select all
  /// functionality to the user.
  bool canSelectAll(SelectableTextSelectionDelegate delegate) {
    return delegate.textEditingValue.text.isNotEmpty && delegate.textEditingValue.selection.isCollapsed;
  }

  /// Copy the current selection of the text field managed by the given
  /// `delegate` to the [Clipboard]. Then, remove the selected text from the
  /// text field and hide the toolbar.
  ///
  /// This is called by subclasses when their cut affordance is activated by
  /// the user.
//  void handleCut(TextSelectionDelegate delegate) {
//    final TextEditingValue value = delegate.textEditingValue;
//    Clipboard.setData(ClipboardData(
//      text: value.selection.textInside(value.text),
//    ));
//    delegate.textEditingValue = TextEditingValue(
//      text: value.selection.textBefore(value.text)
//          + value.selection.textAfter(value.text),
//      selection: TextSelection.collapsed(
//          offset: value.selection.start
//      ),
//    );
//    delegate.bringIntoView(delegate.textEditingValue.selection.extent);
//    delegate.hideToolbar();
//  }

  /// Copy the current selection of the text field managed by the given
  /// `delegate` to the [Clipboard]. Then, move the cursor to the end of the
  /// text (collapsing the selection in the process), and hide the toolbar.
  ///
  /// This is called by subclasses when their copy affordance is activated by
  /// the user.
  void handleCopy(SelectableTextSelectionDelegate delegate) {
    final TextEditingValue value = delegate.textEditingValue;
    Clipboard.setData(ClipboardData(
      text: value.selection.textInside(value.text),
    ));
    delegate.textEditingValue = TextEditingValue(
      text: value.text,
      selection: TextSelection.collapsed(offset: value.selection.end),
    );
    delegate.bringIntoView(delegate.textEditingValue.selection.extent);
    delegate.hideToolbar();
  }

  /// Paste the current clipboard selection (obtained from [Clipboard]) into
  /// the text field managed by the given `delegate`, replacing its current
  /// selection, if any. Then, hide the toolbar.
  ///
  /// This is called by subclasses when their paste affordance is activated by
  /// the user.
  ///
  /// This function is asynchronous since interacting with the clipboard is
  /// asynchronous. Race conditions may exist with this API as currently
  /// implemented.
  // TODO(ianh): https://github.com/flutter/flutter/issues/11427
  Future<void> handlePaste(SelectableTextSelectionDelegate delegate) async {
    final TextEditingValue value = delegate.textEditingValue; // Snapshot the input before using `await`.
    final ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      delegate.textEditingValue = TextEditingValue(
        text: value.selection.textBefore(value.text)
            + data.text
            + value.selection.textAfter(value.text),
        selection: TextSelection.collapsed(
            offset: value.selection.start + data.text.length
        ),
      );
    }
    delegate.bringIntoView(delegate.textEditingValue.selection.extent);
    delegate.hideToolbar();
  }

  /// Adjust the selection of the text field managed by the given `delegate` so
  /// that everything is selected.
  ///
  /// Does not hide the toolbar.
  ///
  /// This is called by subclasses when their select-all affordance is activated
  /// by the user.
  void handleSelectAll(TextSelectionDelegate delegate) {
    delegate.textEditingValue = TextEditingValue(
      text: delegate.textEditingValue.text,
      selection: TextSelection(
          baseOffset: 0,
          extentOffset: delegate.textEditingValue.text.length
      ),
    );
    delegate.bringIntoView(delegate.textEditingValue.selection.extent);
  }
}