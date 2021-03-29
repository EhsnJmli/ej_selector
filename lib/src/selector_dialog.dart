part of 'selector_button.dart';

class _Dialog<T> extends StatefulWidget {
  const _Dialog({
    Key key,
    @required this.selected,
    @required this.items,
    @required this.selectedWidgetBuilder,
    @required this.alwaysShownScrollbar,
    this.divider,
    this.dialogHeight,
    this.dialogWidth,
  }) : super(key: key);

  final T selected;
  final List<EJSelectorItem<T>> items;
  final Widget Function(Widget child, T value) selectedWidgetBuilder;
  final Widget divider;
  final double dialogHeight;
  final double dialogWidth;
  final bool alwaysShownScrollbar;

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
    final hasDivider = widget.divider != null;
    _children = List.generate(
        hasDivider ? widget.items.length * 2 - 1 : widget.items.length,
        (index) {
      if (hasDivider && index % 2 != 0) {
        return widget.divider;
      }

      final itemIndex = hasDivider ? (index / 2).floor() : index;
      final item = widget.items[itemIndex];
      final isSelected =
          widget.selected != null && item.value == widget.selected;
      if (isSelected) {
        _selectedItemIndex = itemIndex;
      }

      final child = isSelected
          ? widget.selectedWidgetBuilder(item.widget, item.value)
          : item.widget;

      return Material(
        key: _keys[itemIndex],
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context, item);
          },
          child: child,
        ),
      );
    });
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
        builder: (_, constraints) => SimpleDialog(
          children: [
            Container(
              width: widget.dialogWidth != null &&
                      (widget.dialogWidth < (constraints.maxWidth - 200))
                  ? widget.dialogWidth
                  : (constraints.maxWidth - 200),
              height: widget.dialogHeight != null
                  ? (widget.dialogHeight < (constraints.maxHeight - 200)
                      ? widget.dialogHeight
                      : (constraints.maxHeight - 200))
                  : null,
              child: Scrollbar(
                controller: _controller,
                isAlwaysShown: widget.alwaysShownScrollbar ?? false,
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

Future<EJSelectorItem<T>> showEJDialog<T>({
  @required BuildContext context,
  @required List<EJSelectorItem<T>> items,
  T selected,
  bool alwaysShownScrollbar = true,
  Widget Function(T valueOfSelected) selectedWidgetBuilder,
  Widget divider,
  double dialogHeight,
  double dialogWidth = 80,
  bool barrierDismissible = true,
  Color barrierColor = Colors.black54,
  String barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings routeSettings,
}) async {
  assert(alwaysShownScrollbar != null);
  assert(items != null);
  assert(useSafeArea != null);
  assert(useRootNavigator != null);

  return showDialog<EJSelectorItem<T>>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    useSafeArea: useSafeArea,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    builder: (context) => _Dialog<T>(
      selected: selected,
      alwaysShownScrollbar: alwaysShownScrollbar,
      selectedWidgetBuilder: (child, value) {
        if (selectedWidgetBuilder != null) {
          return selectedWidgetBuilder(value);
        } else {
          return child;
        }
      },
      divider: divider,
      dialogHeight: dialogHeight,
      dialogWidth: dialogWidth,
      items: items,
    ),
  );
}
