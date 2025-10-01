import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'extend_render_wrap.dart';

/// Created by elileo on 2021/12/3.

/// Builder function type for overflow widget
typedef OverflowWidgetBuilder = Widget? Function(int visibleChildrenCount, int totalChildrenCount);

class ExtendedWrap extends StatefulWidget {
  /// Creates a wrap layout.
  ///
  /// By default, the wrap layout is horizontal and both the children and the
  /// runs are aligned to the start.
  ///
  /// The [textDirection] argument defaults to the ambient [Directionality], if
  /// any. If there is no ambient directionality, and a text direction is going
  /// to be necessary to decide which direction to lay the children in or to
  /// disambiguate `start` or `end` values for the main or cross axis
  /// directions, the [textDirection] must not be null.
  
  final int maxLines;
  final int minLines;
  final Widget? overflowWidget;
  final OverflowWidgetBuilder? overflowWidgetBuilder;
  final List<Widget> children;

  /// The direction to use as the main axis.
  final Axis direction;
  /// How the children within a run should be placed in the main axis.
  final WrapAlignment alignment;
  /// How much space to place between children in a run in the main axis.
  final double spacing;
  /// How the runs themselves should be placed in the cross axis.
  final WrapAlignment runAlignment;
  /// How much space to place between the runs themselves in the cross axis.
  final double runSpacing;
  /// How the children within a run should be aligned relative to each other in the cross axis.
  final WrapCrossAlignment crossAxisAlignment;
  /// Determines the order to lay children out horizontally and how to interpret `start` and `end` in the horizontal direction.
  final TextDirection? textDirection;
  /// Determines the order to lay children out vertically and how to interpret `start` and `end` in the vertical direction.
  final VerticalDirection verticalDirection;
  /// {@macro flutter.material.Material.clipBehavior}
  final Clip clipBehavior;

  const ExtendedWrap({
    Key? key,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.maxLines = 1,
    this.minLines = 1,
    this.overflowWidget,
    this.overflowWidgetBuilder,
    this.children = const <Widget>[],
  })  : assert(maxLines >= 1),
        assert(minLines >= 1 && minLines <= maxLines),
        assert(overflowWidget == null || overflowWidgetBuilder == null, 
               'Cannot provide both overflowWidget and overflowWidgetBuilder'),
        super(key: key);

  @override
  State<ExtendedWrap> createState() => _ExtendedWrapState();
}

class _ExtendedWrapState extends State<ExtendedWrap> {
  int _visibleChildrenCount = 0;

  void _onVisibleChildrenCountChanged(int count) {
    if (_visibleChildrenCount != count) {
      setState(() {
        _visibleChildrenCount = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? overflowWidget;
    
    if (widget.overflowWidget != null) {
      overflowWidget = widget.overflowWidget;
    } else if (widget.overflowWidgetBuilder != null) {
      overflowWidget = widget.overflowWidgetBuilder!(
        _visibleChildrenCount,
        widget.children.length,
      );
    }

    final children = [
      ...widget.children,
      if (overflowWidget != null) overflowWidget,
    ];

    return _ExtendedWrapRenderObjectWidget(
      direction: widget.direction,
      alignment: widget.alignment,
      spacing: widget.spacing,
      runAlignment: widget.runAlignment,
      runSpacing: widget.runSpacing,
      crossAxisAlignment: widget.crossAxisAlignment,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
      clipBehavior: widget.clipBehavior,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      hasOverflow: overflowWidget != null,
      onVisibleChildrenCountChanged: _onVisibleChildrenCountChanged,
      children: children,
    );
  }
}

class _ExtendedWrapRenderObjectWidget extends MultiChildRenderObjectWidget {
  final int maxLines;
  final int minLines;
  final bool hasOverflow;
  final ValueChanged<int>? onVisibleChildrenCountChanged;

  /// The direction to use as the main axis.
  final Axis direction;
  /// How the children within a run should be placed in the main axis.
  final WrapAlignment alignment;
  /// How much space to place between children in a run in the main axis.
  final double spacing;
  /// How the runs themselves should be placed in the cross axis.
  final WrapAlignment runAlignment;
  /// How much space to place between the runs themselves in the cross axis.
  final double runSpacing;
  /// How the children within a run should be aligned relative to each other in the cross axis.
  final WrapCrossAlignment crossAxisAlignment;
  /// Determines the order to lay children out horizontally and how to interpret `start` and `end` in the horizontal direction.
  final TextDirection? textDirection;
  /// Determines the order to lay children out vertically and how to interpret `start` and `end` in the vertical direction.
  final VerticalDirection verticalDirection;
  /// {@macro flutter.material.Material.clipBehavior}
  final Clip clipBehavior;

  const _ExtendedWrapRenderObjectWidget({
    Key? key,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    required this.maxLines,
    required this.minLines,
    required this.hasOverflow,
    this.onVisibleChildrenCountChanged,
    required List<Widget> children,
  })  : assert(maxLines >= 1),
        assert(minLines >= 1 && minLines <= maxLines),
        super(key: key, children: children);



  @override
  ExtendedRenderWrap createRenderObject(BuildContext context) {
    return ExtendedRenderWrap(
        direction: direction,
        alignment: alignment,
        spacing: spacing,
        runAlignment: runAlignment,
        runSpacing: runSpacing,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection ?? Directionality.maybeOf(context),
        verticalDirection: verticalDirection,
        clipBehavior: clipBehavior,
        maxLines: maxLines,
        minLines: minLines,
        hasOverflow: hasOverflow,
        onVisibleChildrenCountChanged: onVisibleChildrenCountChanged);
  }

  @override
  void updateRenderObject(
      BuildContext context, ExtendedRenderWrap renderObject) {
    renderObject
      ..direction = direction
      ..alignment = alignment
      ..spacing = spacing
      ..runAlignment = runAlignment
      ..runSpacing = runSpacing
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = textDirection ?? Directionality.maybeOf(context)
      ..verticalDirection = verticalDirection
      ..maxLines = maxLines
      ..minLines = minLines
      ..hasOverflow = hasOverflow
      ..onVisibleChildrenCountChanged = onVisibleChildrenCountChanged
      ..clipBehavior = clipBehavior;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(EnumProperty<WrapAlignment>('alignment', alignment));
    properties.add(DoubleProperty('spacing', spacing));
    properties.add(EnumProperty<WrapAlignment>('runAlignment', runAlignment));
    properties.add(DoubleProperty('runSpacing', runSpacing));
    properties.add(DoubleProperty('crossAxisAlignment', runSpacing));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties.add(EnumProperty<VerticalDirection>(
        'verticalDirection', verticalDirection,
        defaultValue: VerticalDirection.down));
    properties.add(IntProperty('maxLines', maxLines));
    properties.add(IntProperty('minLines', minLines));
  }
}
