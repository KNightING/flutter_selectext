import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_selectext/src/input_less_focus_node.dart';
import 'package:flutter_selectext/src/selectext_editable_text.dart';
import 'package:flutter_selectext/src/selectable_text_render_editable.dart';
import 'package:flutter_selectext/src/text_selection_controls/cupertino_mark_text_selection_controls.dart';
import 'package:flutter_selectext/src/text_selection_controls/material_mark_text_selection_controls.dart';
import 'package:flutter_selectext/src/selectable_text_selection_controls.dart';

/// Disappear

/// SelectableText widget
/// It allows to display text given the style, text alignment, and text direction
/// It will also allow the user to select text, and stop that selection by tapping anywhere
/// on the text widget
/// It will also allow to copy the text, and unfortunately, the Paste action will also appear
/// but will be a no-op
class Selectext extends StatefulWidget {
  const Selectext(this.text,
      {Key key,
      this.focusNode,
      this.style,
      this.textAlign = TextAlign.start,
      this.textDirection,
      this.cursorRadius,
      this.cursorColor,
      this.dragStartBehavior = DragStartBehavior.down,
      this.enableInteractiveSelection = true,
      this.onTap})
      : assert(text != null),
        textSpan = null,
        super(key: key);

  const Selectext.rich(this.textSpan,
      {Key key,
      this.focusNode,
      this.style,
      this.textAlign = TextAlign.start,
      this.textDirection,
      this.cursorRadius,
      this.cursorColor,
      this.dragStartBehavior = DragStartBehavior.down,
      this.enableInteractiveSelection = true,
      this.onTap})
      : assert(textSpan != null),
        text = null,
        super(key: key);

  final String text;
  final TextSpan textSpan;
  final InputlessFocusNode focusNode;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Radius cursorRadius;
  final Color cursorColor;
  final bool enableInteractiveSelection;
  final DragStartBehavior dragStartBehavior;
  final GestureTapCallback onTap;

  SelectextState createState() => SelectextState();
}

class SelectextState extends State<Selectext> {
  final GlobalKey<SelectableTextEditableTextState> _editableTextKey =
      GlobalKey<SelectableTextEditableTextState>();

  SelectableTextEditingController _controller;

  InputlessFocusNode _focusNode;

  InputlessFocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= InputlessFocusNode());

  List<TextSelection> _textSelections = List();

  @override
  void initState() {
    super.initState();
    if (widget.text != null) {
      _controller = SelectableTextEditingController(text: widget.text);
    } else if (widget.textSpan != null) {
      _controller = SelectableTextEditingController.rich(widget.textSpan);
    }
  }

  @override
  void didUpdateWidget(Selectext oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  SelectableTextRender get _renderEditable =>
      _editableTextKey.currentState.renderEditable;

  TextSelection get selection => _renderEditable.selection;

  set selection(TextSelection value) {
    _editableTextKey.currentState.hideToolbar();
    _renderEditable.selection = value;
  }

  void _handleTapDown(TapDownDetails details) {
    _renderEditable.handleTapDown(details);
  }

  void _handleSingleTapUp(TapUpDetails details) {
    _effectiveFocusNode.unfocus();
    if (widget.onTap != null) {
      widget.onTap();
    }
  }

  void _handleSingleLongTapStart(GestureLongPressDragStartDetails details) {
    // the EditableText widget will force the keyboard to come up if our focus node
    // is already focused. It does this by using a TextInputConnection
    // In order to tool it not to do that, we override our focus while selecting text
    _effectiveFocusNode.overrideFocus = false;

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        _renderEditable.selectPositionAt(
          from: details.globalPosition,
          cause: SelectionChangedCause.longPress,
        );
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        _renderEditable.selectWord(cause: SelectionChangedCause.longPress);
        Feedback.forLongPress(context);
        break;
    }

    // Stop overriding our focus
    _effectiveFocusNode.overrideFocus = null;
  }

  void _handleSingleLongTapMoveUpdate(
      GestureLongPressDragUpdateDetails details) {
    // the EditableText widget will force the keyboard to come up if our focus node
    // is already focused. It does this by using a TextInputConnection
    // In order to tool it not to do that, we override our focus while selecting text
    _effectiveFocusNode.overrideFocus = false;

    _renderEditable.selectWordsInRange(
      from: details.globalPosition - details.offsetFromOrigin,
      to: details.globalPosition,
      cause: SelectionChangedCause.longPress,
    );

    //Stop overriding our focus
    _effectiveFocusNode.overrideFocus = null;
  }

  void _handleSingleLongTapEnd(GestureLongPressDragUpDetails details) {
    _editableTextKey.currentState.showToolbar();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _renderEditable.selectWord(cause: SelectionChangedCause.doubleTap);
    _editableTextKey.currentState.showToolbar();
  }

  void _handleSelectionChanged(
      TextSelection selection, SelectionChangedCause cause) {
    // iOS cursor doesn't move via a selection handle. The scroll happens
    // directly from new text selection changes.
    if (Theme.of(context).platform == TargetPlatform.iOS &&
        cause == SelectionChangedCause.longPress) {
      _editableTextKey.currentState?.bringIntoView(selection.base);
    }
  }

  void handleMark(TextSelection selection) {
    this.selection = null;
    setState(() {
      _textSelections.add(selection);
    });
  }

  void onPaintContent(TextPainter textPainter, Canvas canvas) {
    _textSelections.forEach((textSelection) {
      var boxs = textPainter.getBoxesForSelection(textSelection);
      boxs.forEach((textBox) {
        canvas.drawRect(textBox.toRect(),
            Paint()..color = Color.fromARGB(125, 200, 200, 100));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    // TODO(jonahwilliams): uncomment out this check once we have migrated tests.
    // assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    assert(
        !(widget.style != null &&
            widget.style.inherit == false &&
            (widget.style.fontSize == null ||
                widget.style.textBaseline == null)),
        'inherit false style must supply fontSize and textBaseline',);

    final ThemeData themeData = Theme.of(context);
    final TextStyle style = themeData.textTheme.subhead.merge(widget.style);
    final FocusNode focusNode = _effectiveFocusNode;

    SelectableTextSelectionControls textSelectionControls;
    bool paintCursorAboveText;
    bool cursorOpacityAnimates;
    Offset cursorOffset;
    Color cursorColor = widget.cursorColor;
    Radius cursorRadius = widget.cursorRadius;

    switch (themeData.platform) {
      case TargetPlatform.iOS:
        textSelectionControls =
            CupertinoMarkTextSelectionControls(handleMark: handleMark);

//        textSelectionControls =
//            _TextSelectionControls(cupertinoTextSelectionControls);
        paintCursorAboveText = true;
        cursorOpacityAnimates = true;
        cursorColor ??= CupertinoTheme.of(context).primaryColor;
        cursorRadius ??= const Radius.circular(2.0);
        // An eyeballed value that moves the cursor slightly left of where it is
        // rendered for text on Android so its positioning more accurately matches the
        // native iOS text cursor positioning.
        //
        // This value is in device pixels, not logical pixels as is typically used
        // throughout the codebase.
        const int _iOSHorizontalOffset = -2;
        cursorOffset = Offset(
            _iOSHorizontalOffset / MediaQuery.of(context).devicePixelRatio, 0);
        break;

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        textSelectionControls =
            MaterialMarkTextSelectionControls(handleMark: handleMark);

//        textSelectionControls =
//            _TextSelectionControls(materialTextSelectionControls);
        paintCursorAboveText = false;
        cursorOpacityAnimates = false;
        cursorColor ??= themeData.cursorColor;
        break;
    }

    Widget child = RepaintBoundary(
      child: SelectableTextEditableText(
        key: _editableTextKey,
        controller: _controller,
        focusNode: focusNode,
        style: style,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        maxLines: null,
        selectionColor: themeData.textSelectionColor,
        selectionControls:
            widget.enableInteractiveSelection ? textSelectionControls : null,
        onSelectionChanged: _handleSelectionChanged,
        rendererIgnoresPointer: true,
        cursorWidth: 0,
        cursorRadius: cursorRadius,
        cursorColor: cursorColor,
        cursorOpacityAnimates: cursorOpacityAnimates,
        cursorOffset: cursorOffset,
        paintCursorAboveText: paintCursorAboveText,
        backgroundCursorColor: CupertinoColors.inactiveGray,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        dragStartBehavior: widget.dragStartBehavior,
        onPaintContent: onPaintContent,
      ),
    );

    return Semantics(
      child: TextSelectionGestureDetector(
        onTapDown: _handleTapDown,
        onSingleTapUp: _handleSingleTapUp,
        onSingleLongTapStart: _handleSingleLongTapStart,
        onSingleLongTapDragUpdate: _handleSingleLongTapMoveUpdate,
        onSingleLongTapUp: _handleSingleLongTapEnd,
        onDoubleTapDown: _handleDoubleTapDown,
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}

