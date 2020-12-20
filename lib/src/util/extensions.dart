import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension MouseExtension on Widget {
  Widget mouseRegion({
    void Function(PointerHoverEvent) onHover,
    void Function(PointerEnterEvent) onEnter,
    void Function(PointerExitEvent) onExit,
    void Function() onTap,
    void Function() onDoubleTap,
    void Function() onLongPress,
    void Function() onTapCancel,
    void Function(TapDownDetails) onTapDown,
    InkWell inkWell,
    MouseCursor cursor = SystemMouseCursors.click,
  }) =>
      MouseRegion(
        cursor: cursor,
        onEnter: onEnter,
        onExit: onExit,
        onHover: onHover,
        child: onTap != null
            ? inkWell != null
                ? Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: onTap,
                      onDoubleTap: onDoubleTap,
                      onLongPress: onLongPress,
                      onTapCancel: onTapCancel,
                      onTapDown: onTapDown,
                      focusColor: inkWell.focusColor,
                      hoverColor: inkWell.hoverColor,
                      highlightColor: inkWell.highlightColor,
                      splashColor: inkWell.splashColor,
                      radius: inkWell.radius,
                      borderRadius: inkWell.borderRadius,
                      focusNode: inkWell.focusNode,
                      autofocus: inkWell.autofocus,
                      key: inkWell.key,
                      excludeFromSemantics: inkWell.excludeFromSemantics,
                      canRequestFocus: inkWell.canRequestFocus,
                      customBorder: inkWell.customBorder,
                      enableFeedback: inkWell.enableFeedback,
                      onFocusChange: inkWell.onFocusChange,
                      onHighlightChanged: inkWell.onHighlightChanged,
                      overlayColor: inkWell.overlayColor,
                      splashFactory: inkWell.splashFactory,
                      child: this,
                    ),
                  )
                : GestureDetector(
                    onTap: onTap,
                    onDoubleTap: onDoubleTap,
                    onLongPress: onLongPress,
                    onTapCancel: onTapCancel,
                    onTapDown: onTapDown,
                    child: this,
                  )
            : this,
      );

  Widget addExpanded(bool shouldExpand) =>
      shouldExpand ? Expanded(child: this) : this;
}
