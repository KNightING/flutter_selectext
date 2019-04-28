# flutter_selectext

Selectable text widget and able to set custom selection control.

## Getting Started

#### Add dependencies

on `pubspec.yaml`

<pre>
dependencies:
  flutter_selectext: 0.0.1
</pre>

#### Import library

<pre>
import 'package:flutter_selectext/selectable_text.dart';
</pre>

#### Usage

`SelectableText`

- `SelectableText` use `string`

  ```
   SelectableText('your string');
  ```

- `SelectableText` use `textspan`

  ```
   SelectableText.rich(textspan);
  ```

  `SelectableText` default only can copy.

  you can custom controls and could refer to `MarkText` widget.

`MarkText`

- `MarkText` use `string`

  ```
    List<TextSelection> markList = List();

    void handlerMark(TextSelection selection) {
      setState(() {
        markList.add(selection);
      });
    }

    MarkText('your string',
      handlerMark: handlerMark,
      markColor: Colors.deepOrange,
      markList: markList);
  ```

- `MarkText` use `textspan`

  ```
    List<TextSelection> markList = List();

    void handlerMark(TextSelection selection) {
      setState(() {
        markList.add(selection);
      });
    }

    MarkText(textspan,
      handlerMark: handlerMark,
      markColor: Colors.deepOrange,
      markList: markList);
  ```
