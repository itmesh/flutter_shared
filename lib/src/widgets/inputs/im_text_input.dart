import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImTextInput extends StatefulWidget {
  const ImTextInput({
    super.key,
    required this.contentPadding,
    required this.finalHeight,
    this.labelText,
    this.hintText,
    this.formFieldKey,
    this.onChanged,
    this.focusNode,
    this.controller,
    this.isRequired = false,
    this.suffix,
    this.maxLines = 1,
    this.minLines,
    this.validator,
    this.enabled = true,
    this.initialValue,
    this.obscureText = false,
    this.onSubmit,
    this.autofillHints,
    this.withoutSpaces = false,
    this.disabledBorder,
    this.suffixText,
    this.textStyle,
    this.errorStyle,
    this.focusColor,
    this.errorBorder,
    this.focusedErrorBorder,
    this.fillColor,
    this.hintStyle,
    this.labelStyle,
    this.floatingLabelStyle,
    this.enabledBorder,
    this.focusedBorder,
    this.border,
    this.textAlignVertial,
    this.hoverColor,
    this.requiredTextError,
  });

  final String? labelText;
  final String? hintText;
  final GlobalKey<FormFieldState<String>>? formFieldKey;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool isRequired;
  final Widget? suffix;
  final int? maxLines;
  final int? minLines;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final String? initialValue;
  final bool obscureText;
  final void Function()? onSubmit;
  final List<String>? autofillHints;
  final bool withoutSpaces;
  final String? suffixText;
  final Color? focusColor;
  final Color? fillColor;
  final Color? hoverColor;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? border;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final double finalHeight;
  final EdgeInsets contentPadding;
  final TextAlignVertical? textAlignVertial;
  final String? requiredTextError;

  @override
  State<ImTextInput> createState() => _ImTextInputState();
}

class _ImTextInputState extends State<ImTextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SizedBox(
      height: widget.finalHeight,
      child: TextFormField(
        textAlignVertical: widget.textAlignVertial,
        style: widget.textStyle,
        autofillHints: widget.autofillHints,
        keyboardType: TextInputType.multiline,
        initialValue: widget.initialValue,
        minLines: widget.minLines ?? 1,
        maxLines: widget.maxLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        enabled: widget.enabled,
        onFieldSubmitted: (String value) => widget.onSubmit?.call(),
        validator: (String? value) {
          if (widget.isRequired && (value == null || value.isEmpty)) {
            if (widget.requiredTextError == null) {
              return 'Required field';
            } else {
              return widget.requiredTextError;
            }
          }

          if (widget.validator != null) {
            return widget.validator!(value);
          }

          return null;
        },
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        key: widget.formFieldKey,
        obscureText: widget.obscureText,
        inputFormatters: widget.withoutSpaces
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ]
            : null,
        decoration: InputDecoration(
          hoverColor: widget.hoverColor,
          contentPadding: widget.contentPadding,
          errorStyle: widget.errorStyle,
          suffixText: widget.suffixText,
          hintText: widget.hintText,
          focusColor: widget.focusColor,
          errorBorder: widget.errorBorder,
          focusedErrorBorder: widget.focusedErrorBorder,
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
          suffix: widget.suffix,
        ),
      ),
    );
  }
}
