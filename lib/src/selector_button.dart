import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './util/extensions.dart';

part 'selector_dialog.dart';

class EJSelectorButton<T> extends StatefulWidget {
  EJSelectorButton({
    Key key,
    @required this.items,
    this.value,
    this.useValue = true,
    this.hint,
    this.dialogWidth = 80,
    this.dialogHeight,
    this.buttonBuilder,
    this.selectedWidgetBuilder,
    this.onChange,
    this.divider,
    this.onTap,
    this.alwaysShowScrollBar,
  })  : assert(items != null),
        assert(
          items.isEmpty ||
              value == null ||
              items.where((item) => item.value == value).length == 1,
          "There should be exactly one item with [item]'s value: "
          '$value.\n'
          'Either zero or 2 or more [item]s were detected '
          'with the same value',
        ),
        assert(T.runtimeType != Widget,
            '{EJSelectorButton}\'s type can\'t be {Widget}'),
        assert(useValue != null),
        super(key: key);

  /// The list of items the user can select and it's can't be null.
  final List<EJSelectorItem<T>> items;

  /// The value of the currently selected [EJSelectorItem].
  ///
  /// [EJSelectorButton] will use [value] if [useValue] is true;
  /// If [value] is null and [useValue] is true and [hint] is non-null,
  /// the [hint] widget is displayed as a placeholder for
  /// the [EJSelectorButton]'s value.
  final T value;

  /// Specifies whether to use the value.
  ///
  /// defaults to true.
  final bool useValue;

  /// A placeholder widget that is displayed by the dropdown button.
  ///
  /// If [value] is null, this widget is displayed as a placeholder for
  /// the [EJSelectorButton]'s value.
  final Widget hint;

  /// The Height of the dialog which shows for select items.
  ///
  /// [dialogHeight] must be lower than screen height - 200.
  /// If [dialogHeight] is more than screen height - 200, height of the dialog
  /// will be equal to screen height - 200.
  /// If [dialogHeight] is null, height of the dialog will be fit to
  /// height of its children.
  final double dialogHeight;

  /// The Width of the dialog which shows for select items.
  ///
  /// [dialogWidth] must be lower than screen width - 200.
  /// If [dialogWidth] is more than screen width - 200, width of the dialog
  /// will be equal to screen width - 200.
  ///
  /// defaults to 80.
  final double dialogWidth;

  /// Custom builder for the main widget of [EJSelectorButton].
  ///
  /// [buttonBuilder]'s child will be widget of selected item
  /// and it's value will be value of selected item, if no item is selected,
  /// child will be hint and if hint is null, child will be [Container].
  ///
  /// If [buttonBuilder] is null or return null,
  /// main widget of [EJSelectorButton] will be widget of selected item and
  /// if no item is selected, it will be hint.
  final Widget Function(Widget child, T value) buttonBuilder;

  /// Custom builder for selected item in dialog.
  final Widget Function(T valueOfSelected) selectedWidgetBuilder;

  /// Called when the user selects an item.
  final void Function(T value) onChange;

  /// Called when the dropdown button is tapped.
  ///
  /// This is distinct from [onChanged], which is called when the user
  /// selects an item from the dialog.
  final VoidCallback onTap;

  /// Custom builder for divider between items in the dialog.
  final Widget divider;

  /// Indicates whether the scrollbar for the dialog should always be visible.
  final bool alwaysShowScrollBar;

  static EJSelectorButton<String> string({
    Key key,
    @required List<String> items,
    String value,
    bool useValue = true,
    String hint,
    double dialogWidth = 80,
    double buttonWidth,
    double buttonHeight,
    double itemExtent = 50,
    void Function(String) onChange,
    VoidCallback onTap,
    Widget divider,
    bool underline = true,
    TextStyle textStyle,
    TextStyle dialogTextStyle,
    TextStyle hintStyle,
    Widget suffix,
    Widget prefix,
    TextOverflow buttonTextOverFlow,
    Color underlineColor = Colors.grey,
    BoxDecoration decoration,
    Alignment alignment = Alignment.center,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    EdgeInsets margin = EdgeInsets.zero,
    bool alwaysShownScrollbar = false,
  }) {
    return EJSelectorButton<String>(
      hint: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefix != null) prefix,
          Container(
            alignment: alignment,
            child: Text(hint ?? '', style: hintStyle ?? textStyle),
          ).addExpanded(buttonWidth != null),
          if (suffix != null) suffix,
        ],
      ),
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
                  style: dialogTextStyle ??
                      textStyle ??
                      Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ));
      }),
      alwaysShowScrollBar: alwaysShownScrollbar,
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
      divider: divider,
      buttonBuilder: (child, value) => Builder(
        builder: (context) => Container(
          height: buttonHeight,
          width: buttonWidth,
          padding: padding,
          margin: margin,
          alignment: alignment,
          decoration: decoration ??
              BoxDecoration(
                border: underline
                    ? Border(
                        bottom: BorderSide(color: underlineColor, width: 2))
                    : Border(),
              ),
          child: value != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefix != null) prefix,
                    Container(
                      alignment: alignment,
                      child: Text(
                        value,
                        overflow: buttonTextOverFlow,
                        style:
                            textStyle ?? Theme.of(context).textTheme.bodyText2,
                      ),
                    ).addExpanded(buttonWidth != null),
                    if (suffix != null) suffix,
                  ],
                )
              : child,
        ),
      ),
      onChange: onChange,
      onTap: onTap,
      dialogWidth: dialogWidth,
      dialogHeight: items.length * itemExtent,
      key: key,
    );
  }

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
    final child = _selected?.widget ?? widget.hint ?? Container();
    final button = widget.buttonBuilder != null
        ? (widget.buttonBuilder(child, _selected?.value) ?? child)
        : child;

    return button.mouseRegion(
        cursor: widget.items.isNotEmpty || widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onTap: () async {
          EJSelectorItem<T> s;
          if (widget.items.isNotEmpty) {
            s = await showEJDialog<T>(
              context: context,
              barrierDismissible: true,
              selected: _selected?.value,
              alwaysShownScrollbar: widget.alwaysShowScrollBar ?? true,
              selectedWidgetBuilder: widget.selectedWidgetBuilder,
              divider: widget.divider,
              dialogHeight: widget.dialogHeight,
              dialogWidth: widget.dialogWidth,
              items: widget.items,
            );
          }
          if (s != null) {
            setState(() {
              _selected = s;
            });
            if (widget.onChange != null) {
              widget.onChange(s.value);
            }
          }
          if (widget.onTap != null) {
            widget.onTap();
          }
        });
  }
}

class EJSelectorItem<T> {
  EJSelectorItem({
    @required this.value,
    @required this.widget,
  }) : assert(value != null && widget != null);

  /// The value of item.
  final T value;

  /// The widget of item.
  final Widget widget;
}
