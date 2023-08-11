import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImTextInput extends StatefulWidget {
  const ImTextInput({
    super.key,
    this.labelText,
    this.hintText,
    this.formFieldKey,
    this.onChanged,
    this.focusNode,
    this.controller,
    this.isRequired = false,
    this.maxLines = 1,
    this.minLines,
    this.validator,
    this.enabled = true,
    this.initialValue,
    this.obscureText = false,
    this.onSubmit,
    this.autofillHints,
    this.withoutSpaces = false,
    this.suffixText,
    this.borderColor,
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

  });

  final String? labelText;
  final String? hintText;
  final GlobalKey<FormFieldState<String>>? formFieldKey;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool isRequired;
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
  final Color? borderColor;
  final Color? focusColor;
  final Color? fillColor;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? border;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;

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
      height: 70.0,
      child: TextFormField(
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
            return 'Required field';
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
          contentPadding: const EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
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
          border: widget.border,
        ),
      ),
    );
  }
}
