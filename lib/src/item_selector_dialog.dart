import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './util/extensions.dart';

class EJSelectorButton<T> extends StatefulWidget {
  EJSelectorButton({
    Key key,
    @required this.items,
    @required this.onChange,
    @required this.mainWidgetBuilder,
    this.dialogWidth = 80,
    this.dialogHeight,
    this.value,
    this.width,
    this.height,
    this.onTap,
    this.hint,
    this.selectedWidgetBuilder,
    this.useValue = true,
  })  : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((item) => item.value == value).length == 1,
          "There should be exactly one item with [item]'s value: "
          '$value.'
          'Either zero or 2 or more [item]s were detected '
          'with the same value',
        ),
        assert(T.runtimeType != Widget,
            '{DialogSelectButton}\'s type can\'t be {Widget}'),
        assert(useValue != null),
        super(key: key);

  final Widget hint;
  final T value;
  final List<EJSelectorItem<T>> items;
  final double dialogHeight, dialogWidth, width, height;
  final void Function(T value) onChange;
  final Widget Function(T valueOfSelected) selectedWidgetBuilder;
  final Widget Function(Widget child, T value) mainWidgetBuilder;
  final VoidCallback onTap;
  final bool useValue;

  static EJSelectorButton<String> string(
          {Key key,
          @required List<String> items,
          @required void Function(String) onChange,
          double dialogWidth = 80,
          double width,
          double height,
          VoidCallback onTap,
          double itemExtent = 50,
          String hint,
          String value,
          bool underline = true,
          TextStyle textStyle,
          TextStyle hintStyle,
          Widget suffix,
          Widget prefix,
          Color underlineColor = Colors.grey,
          BoxDecoration decoration,
          Alignment alignment = Alignment.centerRight,
          EdgeInsets padding =
              const EdgeInsets.only(bottom: 4, right: 8, left: 8),
          EdgeInsets margin = EdgeInsets.zero,
          bool useValue = true}) =>
      EJSelectorButton<String>(
        hint: Text(hint ?? '', style: hintStyle ?? textStyle),
        items: List.generate(items.length, (index) {
          final item = items[index];
          return EJSelectorItem<String>(
              value: item,
              widget: Builder(
                builder: (context) => Container(
                  height: itemExtent,
                  alignment: Alignment.center,
                  child: Text(
                    item,
                    style: textStyle ?? Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ));
        }),
        useValue: useValue,
        value: value,
        selectedWidgetBuilder: (value) => Builder(
          builder: (context) => Container(
            height: itemExtent,
            alignment: Alignment.center,
            child: Text(
              value,
              style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        mainWidgetBuilder: (child, value) => Builder(
          builder: (context) => Container(
            height: height,
            width: width,
            padding: padding,
            margin: margin,
            alignment: alignment,
            decoration: decoration ??
                BoxDecoration(
                    border: underline
                        ? Border(
                            bottom: BorderSide(color: underlineColor, width: 2))
                        : Border()),
            child: value != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (prefix != null) prefix,
                      Expanded(
                        child: Container(
                          alignment: alignment,
                          child: Text(
                            value,
                            style: textStyle ??
                                Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ),
                      if (suffix != null) suffix,
                    ],
                  )
                : child,
          ),
        ),
        onChange: (value) => onChange(value),
        onTap: onTap,
        dialogWidth: dialogWidth,
        dialogHeight: items.length * itemExtent,
        height: height,
        width: width,
        key: key,
      );

  @override
  _EJSelectorButtonState<T> createState() => _EJSelectorButtonState<T>();
}

class _EJSelectorButtonState<T> extends State<EJSelectorButton<T>> {
  EJSelectorItem<T> _selected;

  @override
  void initState() {
    if (widget.value != null) {
      _selected = widget.items.firstWhere((item) => item.value == widget.value);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EJSelectorButton<T> oldWidget) {
    if (widget.useValue) {
      if (widget.value != null) {
        _selected =
            widget.items.firstWhere((item) => item.value == widget.value);
      } else {
        _selected = null;
      }
    } else if (widget.value != null) {
      _selected = widget.items.firstWhere((item) => item.value == widget.value);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final main = widget.mainWidgetBuilder != null
        ? widget.mainWidgetBuilder(
            _selected?.widget ?? widget.hint ?? Container(), _selected?.value)
        : _selected?.widget ?? widget.hint ?? Container();
    return main.mouseRegion(
        cursor: widget.items.isNotEmpty || widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onTap: () async {
          EJSelectorItem<T> s;
          if (widget.items.isNotEmpty) {
            s = await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => _Dialog<T>(
                height: widget.height,
                selected: _selected,
                selectedWidget: (child, value) {
                  if (widget.selectedWidgetBuilder != null) {
                    return widget.selectedWidgetBuilder(value);
                  } else {
                    return child;
                  }
                },
                dialogHeight: widget.dialogHeight,
                width: widget.width,
                dialogWidth: widget.dialogWidth,
                onChange: (item) => widget.onChange(item.value),
                items: widget.items,
              ),
            );
          }
          if (s != null) {
            _selected = s;
          }
          if (widget.onTap != null) {
            widget.onTap();
          }
        });
  }
}

class _Dialog<T> extends StatefulWidget {
  const _Dialog({
    Key key,
    @required this.selected,
    @required this.items,
    @required this.onChange,
    @required this.selectedWidget,
    this.dialogHeight,
    this.dialogWidth,
    this.width,
    this.height,
  }) : super(key: key);

  final EJSelectorItem<T> selected;
  final List<EJSelectorItem<T>> items;
  final void Function(EJSelectorItem<T> item) onChange;
  final Widget Function(Widget child, T value) selectedWidget;
  final double dialogHeight, dialogWidth, width, height;

  @override
  _DialogState<T> createState() => _DialogState<T>();
}

class _DialogState<T> extends State<_Dialog<T>> {
  ScrollController _controller;
  List<GlobalKey> _keys;
  List<Widget> _children;
  int _selectedItemIndex;

  @override
  void initState() {
    _controller = ScrollController();
    _keys = List<GlobalKey>.generate(widget.items.length, (i) => GlobalKey());
    _children = widget.items.map((item) {
      final index = widget.items.indexOf(item);
      final isSelected =
          widget.selected != null && item.value == widget.selected.value;
      if (isSelected) {
        _selectedItemIndex = index;
      }

      final child = isSelected
          ? widget.selectedWidget(item.widget, item.value)
          : item.widget;

      return Material(
        key: _keys[index],
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.pop(context, item);
            widget.onChange(item);
          },
          child: child,
        ),
      );
    }).toList();
    if (_selectedItemIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Scrollable.ensureVisible(
          _keys[_selectedItemIndex].currentContext,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 200),
        );
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          children: [
            Container(
              width: widget.dialogWidth,
              height: widget.dialogHeight != null
                  ? (widget.dialogHeight < (constraints.maxHeight - 200)
                      ? widget.dialogHeight
                      : (constraints.maxHeight - 200))
                  : null,
              child: CupertinoScrollbar(
                controller: _controller,
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    children: _children,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class EJSelectorItem<T> {
  EJSelectorItem({
    @required this.value,
    @required this.widget,
  }) : assert(value != null && widget != null);

  final T value;
  final Widget widget;
}
