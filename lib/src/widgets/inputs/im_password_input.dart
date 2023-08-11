import 'package:flutter/material.dart';

class ImPasswordInput extends StatefulWidget {
  const ImPasswordInput({
    super.key,
    required this.passwordNotVisibleIcon,
    required this.passwordVisibleIcon,
    this.labelText,
    this.hintText,
    this.formFieldKey,
    this.onChanged,
    this.focusNode,
    this.controller,
    this.required = false,
    this.validator,
    this.enabled = true,
    this.onSubmit,
    this.autofillHints,
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
  final bool required;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final void Function()? onSubmit;
  final List<String>? autofillHints;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? border;
  final Color? focusColor;
  final Color? fillColor;
  final Widget passwordNotVisibleIcon;
  final Widget passwordVisibleIcon;

  @override
  State<ImPasswordInput> createState() => _ImPasswordInputState();
}

class _ImPasswordInputState extends State<ImPasswordInput> {
  bool _passwordNotVisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        height: 70.0,
        child: TextFormField(
          style: widget.textStyle,
          autofillHints: widget.autofillHints,
          maxLines: 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          enabled: widget.enabled,
          onFieldSubmitted: (String value) => widget.onSubmit?.call(),
          validator: (String? value) {
            if (widget.required && (value == null || value.isEmpty)) {
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
          obscureText: _passwordNotVisible,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            errorStyle: widget.errorStyle,
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
            suffixIcon: IconButton(
              icon: _passwordNotVisible ? widget.passwordNotVisibleIcon : widget.passwordVisibleIcon,
              onPressed: () {
                setState(() {
                  _passwordNotVisible = !_passwordNotVisible;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}