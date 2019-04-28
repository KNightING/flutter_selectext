import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_selectext/src/selectext_editable_text.dart';

//來源 SelectableText, 不知道作用為何

class _EditableTextState extends SelectableTextEditableTextState {
  @override
  Widget build(BuildContext context) {
    Widget widget = super.build(context);
    assert(widget is Scrollable);
    Scrollable scrollable = widget;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Scrollable(
            excludeFromSemantics: true,
            axisDirection: AxisDirection.right,
            controller: scrollable.controller,
            physics: const NeverScrollableScrollPhysics(),
            dragStartBehavior: scrollable.dragStartBehavior,
            viewportBuilder: (context, offset) {
              // create a _FakeRenderObject so that it can safely set
              // a viewport of 0.0 on the Scrollable so that everything is
              // happy
              return _FakeRenderObject(offset: offset);
            }),
        scrollable.viewportBuilder(context, ViewportOffset.zero())
      ],
    );
  }
}

/// FakeRenderObject
class _FakeRenderObject extends LeafRenderObjectWidget {
  _FakeRenderObject({@required this.offset});

  final ViewportOffset offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _FakeRenderBox(offset: offset);
  }

  @override
  void updateRenderObject(BuildContext context, _FakeRenderBox renderObject) {
    renderObject..offset = offset;
  }
}

/// FakeRenderBox
class _FakeRenderBox extends RenderBox {
  _FakeRenderBox({@required ViewportOffset offset})
      : assert(offset != null),
        _offset = offset;

  ViewportOffset get offset => _offset;
  ViewportOffset _offset;

  set offset(ViewportOffset value) {
    assert(value != null);
    if (_offset == value) return;
    if (attached) _offset.removeListener(markNeedsPaint);
    _offset = value;
    if (attached) _offset.addListener(markNeedsPaint);
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _offset.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _offset.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    assert(_offset != null);
    size = Size(constraints.minWidth, constraints.minHeight);
    _offset.applyViewportDimension(0.0);
    _offset.applyContentDimensions(0.0, 0.0);
  }
}