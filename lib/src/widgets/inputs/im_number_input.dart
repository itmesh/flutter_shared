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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Row(
      children: <Widget>[
        _buildFormField(),
        if (widget.suffixText != null)
          Column(
            children: <Widget>[
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
              const SizedBox(height: 24.0),
            ],
          ),
      ],
    );
  }

  Widget _buildFormField() {
    return Expanded(
      child: SizedBox(
        height: widget.finalHeight,
        child: TextFormField(
          style: widget.textStyle,
          keyboardType: TextInputType.number,
          initialValue: widget.initialValue,
          minLines: widget.minLines ?? 1,
          maxLines: widget.maxLines ?? 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          enabled: widget.enabled,
          onFieldSubmitted: (String value) => widget.onSubmit?.call(),
          textAlignVertical: widget.textAlignVertical,
          validator: (String? value) {
            if (widget.required && (value == null || value.isEmpty)) {
              if (widget.requiredTextError == null) {
                return 'Field is required';
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
          onChanged: (String value) {
            widget.onChanged?.call(value);

            setState(() {});
          },
          key: widget.formFieldKey,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            hoverColor: widget.hoverColor,
            contentPadding: widget.contentPadding,
            errorStyle: widget.errorStyle,
            focusColor: widget.focusColor,
            errorBorder: widget.errorBorder,
            focusedErrorBorder: widget.focusedErrorBorder,
            suffixIcon: widget.showDeleteIcon
                ? IconButton(
                    onPressed: () {
                      if (widget.controller != null) {
                        widget.controller!.value = TextEditingValue(
                          text: '',
                          selection: TextSelection.fromPosition(
                            const TextPosition(offset: ''.length),
                          ),
                        );
                      }

                      if (widget.formFieldKey != null) {
                        widget.formFieldKey!.currentState?.didChange(null);
                      }

                      if (widget.onChanged != null) {
                        widget.onChanged!('');
                      }

                      setState(() {});
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      child: SizedBox(
                        height: 16.0,
                        width: 16.0,
                        child: widget.deleteIcon,
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
    );
  }
}
