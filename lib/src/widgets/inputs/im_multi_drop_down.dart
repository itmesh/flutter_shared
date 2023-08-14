import 'dart:math';

import 'package:flutter/material.dart';
import 'package:itmesh_flutter_shared/flutter_shared.dart';

class ImMultiDropdown<T> extends StatefulWidget {
  const ImMultiDropdown({
    Key? key,
    required this.items,
    required this.label,
    required this.labelStyle,
    required this.initialItems,
    required this.inputHeight,
    required this.contentPadding,
    this.onChanged,
    this.customSorting,
    this.translateItemtoString,
    this.textStyle,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
    this.dropdownColor,
    this.chipsColor,
    this.checkOnListColor,
    this.dropdownDecoration,
    this.expandDropdownIcon,
  }) : super(key: key);

  final void Function(Set<T>? value)? onChanged;
  final String Function(T element)? translateItemtoString;
  final void Function(List<T> elements)? customSorting;
  final Set<T> items;
  final String label;
  final Set<T> initialItems;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle labelStyle;
  final Color? backgroundColor;
  final Color? chipsColor;
  final Color? dropdownColor;
  final Color? checkOnListColor;
  final Decoration? dropdownDecoration;
  final Widget? expandDropdownIcon;
  final double inputHeight;
  final EdgeInsets contentPadding;

  @override
  State<ImMultiDropdown<T>> createState() => ImMultiDropdownState<T>();
}

class ImMultiDropdownState<T> extends State<ImMultiDropdown<T>> with TickerProviderStateMixin {
  final GlobalKey<RawGestureDetectorState> _globalKey = GlobalKey<RawGestureDetectorState>();
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Set<T> _selectedItems = widget.initialItems;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            key: _globalKey,
            onTap: () => _toggleDropdown(_globalKey.currentContext ?? context),
            child: _buildDropDown(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 7.5, left: 8.0),
          child: Container(
            color: widget.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                width: widget.label.textSize(widget.labelStyle).width,
                height: 2,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              widget.label,
              style: widget.labelStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropDown() {
    return Container(
      height: widget.inputHeight,
      decoration: widget.dropdownDecoration,
      child: CompositedTransformTarget(
        link: this._layerLink,
        child: Padding(
          padding: widget.contentPadding,
          child: Row(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    children: _selectedItems
                        .map((T e) => Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Chip(
                                label: Text(_getName(e)),
                                backgroundColor: widget.chipsColor,
                                deleteIcon: const Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                                onDeleted: () {
                                  _selectedItems.remove(e);

                                  if (widget.onChanged != null) {
                                    widget.onChanged!(value);
                                  }

                                  setState(() {});
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              if (widget.expandDropdownIcon != null) widget.expandDropdownIcon!,
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry(BuildContext widgetContext) {
    final RenderBox? renderBox = widgetContext.findRenderObject() as RenderBox?;
    final Size size = renderBox?.size ?? const Size(0, 0);

    final Offset offset = renderBox?.localToGlobal(Offset.zero) ?? const Offset(0, 0);

    final double dropdownBottomHeight = offset.dy + size.height;
    final double availableSafeHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - dropdownBottomHeight - 16.0;

    final double maxHeight = min(availableSafeHeight, MediaQuery.of(context).size.height / 2);

    return OverlayEntry(
      builder: (BuildContext context) => GestureDetector(
        onTap: () => _toggleDropdown(widgetContext, close: true),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              width: size.width,
              child: CompositedTransformFollower(
                offset: Offset(0, size.height),
                link: _layerLink,
                showWhenUnlinked: false,
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.zero,
                  color: widget.dropdownColor,
                  child: SizeTransition(
                    axisAlignment: 1,
                    sizeFactor: _expandAnimation,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: maxHeight,
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: widget.items
                            .map((T item) => CheckboxListTile(
                                  key: ValueKey<T>(item),
                                  value: _selectedItems.contains(item),
                                  title: Text(_getName(item)),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (bool? isChecked) {
                                    _itemChange(item, isChecked!);

                                    _overlayEntry.markNeedsBuild();
                                    setState(() {});
                                  },
                                  activeColor: widget.checkOnListColor,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getName(T e) {
    if (widget.translateItemtoString == null) {
      return e.toString();
    }
    return widget.translateItemtoString!(e);
  }

  void _itemChange(T itemValue, bool isSelected) {
    if (isSelected) {
      _selectedItems.add(itemValue);
    } else {
      _selectedItems.remove(itemValue);
    }

    _selectedItems = _sortAlphabetically();

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }

    setState(() {});
  }

  void _toggleDropdown(BuildContext widgetContext, {bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();

      _isOpen = false;
      setState(() {});
    } else {
      _overlayEntry = _createOverlayEntry(widgetContext);
      Overlay.of(context).insert(_overlayEntry);

      _isOpen = true;
      setState(() {});

      _animationController.forward();
    }
  }

  Set<T> _sortAlphabetically() {
    final List<T> elements = _selectedItems.toList();

    if (widget.customSorting != null) {
      widget.customSorting!(elements);

      return elements.toSet();
    }

    if (widget.translateItemtoString == null) {
      elements.sort((T a, T b) {
        return a.toString().compareTo(b.toString());
      });

      return elements.toSet();
    }

    elements.sort((T a, T b) {
      return widget.translateItemtoString!(a)
          .toLowerCase()
          .compareToPolishString(widget.translateItemtoString!(b).toLowerCase());
    });

    return elements.toSet();
  }

  void setValue(Set<T> set) {
    _selectedItems = set;
  }

  Set<T> get value {
    return _selectedItems;
  }
}
