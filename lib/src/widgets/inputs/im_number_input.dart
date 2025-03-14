import 'package:flutter/material.dart';

class ImNumberInput extends StatefulWidget {
  const ImNumberInput({
    super.key,
    required this.finalHeight,
    required this.inputHeight,
    required this.contentPadding,
    this.labelText,
    this.formFieldKey,
    this.onChanged,
    this.focusNode,
    this.controller,
    this.required = false,
    this.maxLines,
    this.minLines,
    this.validator,
    this.enabled = true,
    this.initialValue,
    this.obscureText = false,
    this.onSubmit,
    this.suffixText,
    this.showDeleteIcon = true,
    this.suffixTextStyle,
    this.suffixBoxDecoration,
    this.disabledBorder,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.fillColor,
    this.hintStyle,
    this.labelStyle,
    this.floatingLabelStyle,
    this.deleteIcon,
    this.errorStyle,
    this.textStyle,
    this.focusColor,
    this.focusedErrorBorder,
    this.errorBorder,
    this.textAlignVertical,
    this.hoverColor,
    this.requiredTextError,
  });

  final String? labelText;
  final GlobalKey<FormFieldState<String>>? formFieldKey;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool required;
  final int? maxLines;
  final int? minLines;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final String? initialValue;
  final bool obscureText;
  final void Function()? onSubmit;
  final String? suffixText;
  final bool showDeleteIcon;
  final Widget? deleteIcon;
  final Color? focusColor;
  final Color? hoverColor;
  final TextStyle? suffixTextStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final TextStyle? errorStyle;
  final TextStyle? textStyle;
  final InputBorder? disabledBorder;
  final BoxDecoration? suffixBoxDecoration;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final Color? fillColor;
  final double inputHeight;
  final double finalHeight;
  final EdgeInsets contentPadding;
  final String? requiredTextError;
  final TextAlignVertical? textAlignVertical;

  @override
  State<ImNumberInput> createState() => _ImNumberInputState();
}

class _ImNumberInputState extends State<ImNumberInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? _errorText;
  final GlobalKey<FormFieldState<String>> _formKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.required && (_controller.text.isEmpty)) {
        _validateAndUpdateError(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _validateAndUpdateError(String? value) {
    setState(() {
      _errorText = _getErrorText(value);
    });
  }

  String? _getErrorText(String? value) {
    Locale currentLocale = Localizations.localeOf(context);

    if (widget.required && (value == null || value.isEmpty)) {
      if (widget.requiredTextError == null && currentLocale.languageCode == 'pl') {
        return 'Pole jest wymagane';
      } else if (widget.requiredTextError == null && currentLocale.languageCode == 'en') {
        return 'Field is required';
      } else {
        return widget.requiredTextError;
      }
    }

    if (widget.validator != null) {
      return widget.validator!(value);
    }

    return null;
  }

  void _clearInput() {
    _controller.clear();
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
    _validateAndUpdateError('');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.finalHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: widget.inputHeight,
                  child: TextFormField(
                    style: widget.textStyle,
                    keyboardType: TextInputType.number,
                    minLines: widget.minLines ?? 1,
                    maxLines: widget.maxLines ?? 1,
                    autovalidateMode: AutovalidateMode.disabled, // We'll handle validation ourselves
                    controller: _controller,
                    enabled: widget.enabled,
                    onFieldSubmitted: (String value) => widget.onSubmit?.call(),
                    textAlignVertical: widget.textAlignVertical,
                    validator: (String? value) {
                      final error = _getErrorText(value);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _errorText = error;
                        });
                      });
                      return error;
                    },
                    focusNode: _focusNode,
                    onChanged: (String value) {
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      }
                      _validateAndUpdateError(value);
                    },
                    key: widget.formFieldKey ?? _formKey,
                    obscureText: widget.obscureText,
                    decoration: InputDecoration(
                      hoverColor: widget.hoverColor,
                      contentPadding: widget.contentPadding,
                      errorStyle: const TextStyle(height: 0, color: Colors.transparent), // Hide the default error
                      errorMaxLines: 1,
                      focusColor: widget.focusColor,
                      errorBorder: widget.errorBorder,
                      focusedErrorBorder: widget.focusedErrorBorder,
                      suffixIcon: widget.showDeleteIcon && _controller.text.isNotEmpty
                          ? IconButton(
                        onPressed: _clearInput,
                        icon: Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                            bottom: 8.0,
                          ),
                          child: SizedBox(
                            height: 16.0,
                            width: 16.0,
                            child: widget.deleteIcon ?? const Icon(Icons.clear, size: 16),
                          ),
                        ),
                      )
                          : null,
                      filled: true,
                      fillColor: widget.fillColor,
                      alignLabelWithHint: false,
                      labelText: widget.labelText,
                      hintStyle: widget.hintStyle,
                      labelStyle: widget.labelStyle,
                      floatingLabelStyle: widget.floatingLabelStyle,
                      enabledBorder: widget.enabledBorder,
                      focusedBorder: widget.focusedBorder,
                      disabledBorder: widget.disabledBorder,
                      border: widget.border,
                    ),
                  ),
                ),
              ),
              if (widget.suffixText != null)
                Container(
                  height: widget.inputHeight,
                  decoration: widget.suffixBoxDecoration,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.suffixText!,
                        style: widget.suffixTextStyle,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: widget.finalHeight - widget.inputHeight,
            child: Align(
              alignment: Alignment.topLeft,
              child: _errorText != null
                  ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _errorText!,
                  style: widget.errorStyle ?? TextStyle(color: Colors.red[700], fontSize: 12),
                ),
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}