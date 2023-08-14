import 'dart:math';

import 'package:flutter/material.dart';
import 'package:itmesh_flutter_shared/flutter_shared.dart';

class ImDropdownInput<T> extends StatefulWidget {
  const ImDropdownInput({
    Key? key,
    required this.values,
    required this.label,
    required this.labelStyle,
    required this.inputHeight,
    required this.finalHeight,
    required this.contentPadding,
    this.formFieldKey,
    this.initialValue,
    this.onChanged,
    this.customSorting,
    this.validator,
    this.isRequired = false,
    this.enabled = true,
    this.translateItemtoString,
    this.translateItemtoSubtitle,
    this.errorStyle,
    this.backgroundColor,
    this.dropdownDecoration,
    this.textStyle,
    this.expandDropdownIcon,
    this.dropdownColor,
    this.titleStyle,
    this.subtitleStyle,
  }) : super(key: key);

  final void Function(T? value)? onChanged;
  final String Function(T? element)? translateItemtoString;
  final void Function(List<T> elements)? customSorting;
  final Set<T> values;
  final String label;
  final T? initialValue;
  final bool isRequired;
  final bool enabled;
  final GlobalKey<FormFieldState<T>>? formFieldKey;
  final FormFieldValidator<T>? validator;
  final String Function(T? element)? translateItemtoSubtitle;
  final TextStyle? errorStyle;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle labelStyle;
  final Color? backgroundColor;
  final Color? dropdownColor;
  final Decoration? dropdownDecoration;
  final Widget? expandDropdownIcon;
  final double inputHeight;
  final double finalHeight;
  final EdgeInsets contentPadding;

  @override
  State<ImDropdownInput<T>> createState() => ImDropdownInputState<T>();
}

class ImDropdownInputState<T> extends State<ImDropdownInput<T>> with TickerProviderStateMixin {
  final GlobalKey<RawGestureDetectorState> _globalKey = GlobalKey<RawGestureDetectorState>();
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late T? _selectedItem = widget.initialValue;

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
    return SizedBox(
      height: widget.finalHeight,
      child: FormField<T>(
        enabled: widget.enabled,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: widget.formFieldKey,
        validator: (T? value) {
          if (widget.isRequired && (value == null || value == false)) {
            return 'Field is required';
          }

          if (widget.validator != null) {
            return widget.validator!(value);
          }

          return null;
        },
        initialValue: widget.initialValue,
        builder: (FormFieldState<T> field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _buildcontent(field),
            ),
            _buildErrorLine(field),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorLine(FormFieldState<T> field) {
    if (field.hasError) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
        ),
        child: Text(
          field.errorText!,
          style: widget.errorStyle,
        ),
      );
    }

    return const SizedBox(height: 16.0);
  }

  Widget _buildcontent(FormFieldState<T> field) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            key: _globalKey,
            onTap: () => widget.enabled ? _toggleDropdown(_globalKey.currentContext ?? context, field) : null,
            child: _buildDropDown(field),
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
          padding: const EdgeInsets.only(
            left: 12.0,
            top: 1.0,
          ),
          child: Text(
            widget.label,
            style: widget.labelStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildDropDown(FormFieldState<T> field) {
    return Container(
      height: widget.inputHeight,
      decoration: widget.dropdownDecoration,
      child: CompositedTransformTarget(
        link: this._layerLink,
        child: Padding(
          padding: widget.contentPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              field.value == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Text(
                        _getName(field.value),
                        style: widget.textStyle,
                      ),
                    ),
              if (widget.expandDropdownIcon != null) widget.expandDropdownIcon!,
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry(BuildContext widgetContext, FormFieldState<T> field) {
    final RenderBox? renderBox = widgetContext.findRenderObject() as RenderBox?;
    final Size size = renderBox?.size ?? const Size(0, 0);

    final Offset offset = renderBox?.localToGlobal(Offset.zero) ?? const Offset(0, 0);

    final double dropdownBottomHeight = offset.dy + size.height;
    final double availableSafeHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - dropdownBottomHeight - 16.0;

    final double maxHeight = min(availableSafeHeight, MediaQuery.of(context).size.height / 2);

    return OverlayEntry(
      builder: (BuildContext context) => GestureDetector(
        onTap: () => _toggleDropdown(widgetContext, field, close: true),
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
                        children: widget.values
                            .map(
                              (T item) => GestureDetector(
                                onTap: () {
                                  _itemChange(item, field);

                                  _overlayEntry.markNeedsBuild();
                                  _toggleDropdown(widgetContext, field, close: true);
                                  setState(() {});
                                },
                                child: Container(
                                  color: Colors.black.withOpacity(0.0),
                                  height: widget.translateItemtoSubtitle == null ? 40 : 85,
                                  width: double.minPositive,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: widget.translateItemtoSubtitle == null
                                        ? Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _getName(item),
                                              style: widget.titleStyle,
                                            ),
                                          )
                                        : ListTile(
                                            title: Text(
                                              _getName(item),
                                              style: widget.titleStyle,
                                            ),
                                            subtitle: Text(
                                              _getSubtitle(item),
                                              style: widget.subtitleStyle,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            )
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

  String _getName(T? e) {
    if (widget.translateItemtoString == null) {
      return e.toString();
    }
    return widget.translateItemtoString!(e);
  }

  String _getSubtitle(T? e) {
    if (widget.translateItemtoSubtitle == null) {
      return e.toString();
    }
    return widget.translateItemtoSubtitle!(e);
  }

  void _itemChange(T itemValue, FormFieldState<T> field) {
    field.didChange(itemValue);
    widget.onChanged?.call(itemValue);

    setState(() {});
  }

  void _toggleDropdown(BuildContext widgetContext, FormFieldState<T> field, {bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();

      _isOpen = false;
      setState(() {});
    } else {
      _overlayEntry = _createOverlayEntry(widgetContext, field);
      Overlay.of(context).insert(_overlayEntry);

      _isOpen = true;
      setState(() {});

      _animationController.forward();
    }
  }

  void setValue(T value) {
    _selectedItem = value;
  }

  T? get value {
    return _selectedItem;
  }
}
