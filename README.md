# flutter_selectext

## Deprecated!
recommend use official widget [SelectableText](https://api.flutter.dev/flutter/material/SelectableText-class.html)

this widget name same as official widget
if you want to use, can try import package with `alias`
```
 import 'package:flutter_selectext/flutter_selectext.dart' as alias;
```
---

Selectable text widget and able to set custom selection control.

![image](./image/demo.gif)

## Getting Started

### Add dependencies

on `pubspec.yaml`

```
dependencies:
  flutter_selectext: ^0.1.1
```

### Import library

```
import 'package:flutter_selectext/flutter_selectext.dart';
```

### Usage

#### SelectableText

- use `string`

  ```
   SelectableText('your string');
  ```

- use `textspan`

  ```
   SelectableText.rich(textspan);
  ```

  `SelectableText` default only can copy.

  you can custom controls and could refer to `MarkText` widget.

#### MarkText

- use `string`

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

- use `textspan`

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
