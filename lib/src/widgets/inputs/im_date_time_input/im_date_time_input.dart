import 'package:flutter/material.dart';
import 'package:itmesh_flutter_shared/flutter_shared.dart';

class ImDateTimeInput extends StatelessWidget {
  const ImDateTimeInput({
    super.key,
    required this.formFieldKey,
    required this.contentPadding,
    required this.finalHeight,
    this.labelText = 'Date',
    this.languageCode = 'pl',
    this.labelTimeText = 'Hour',
    this.endOfDay = false,
    this.required = true,
    this.initialValue,
    this.showTime = true,
    this.showDate = true,
    this.showTodaysInitialParameter = false,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.selectableDayPredicate,
    this.errorStyle,
    this.errorBorder,
    this.focusedErrorBorder,
    this.labelStyle,
    this.floatingLabelStyle,
    this.enabledBorder,
    this.focusedBorder,
    this.border,
    this.hintStyle,
    this.textStyle,
    this.focusColor,
    this.fillColor,
    this.borderColor,
    this.timeTextColor,
    this.dateTextColor,
    this.labelSmallStyle,
    this.fontSize = 16.0,
  });

  static GlobalKey<FormFieldState<DateTimeInputData>> get generatedKey =>
      GlobalKey<FormFieldState<DateTimeInputData>>();

  final GlobalKey<FormFieldState<DateTimeInputData>> formFieldKey;
  final String labelText;
  final String languageCode;
  final String labelTimeText;
  final DateTimeInputData? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showTime;
  final bool showDate;
  final bool showTodaysInitialParameter;
  final void Function(DateTimeInputData?)? onChanged;
  final bool required;
  final bool endOfDay;
  final String? Function(DateTimeInputData?)? validator;
  final bool Function(DateTime)? selectableDayPredicate;
  final double fontSize;
  final TextStyle? errorStyle;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? border;
  final Color? focusColor;
  final Color? fillColor;
  final Color? borderColor;
  final Color? timeTextColor;
  final Color? dateTextColor;
  final TextStyle? labelSmallStyle;
  final double finalHeight;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        height: finalHeight,
        child: FormField<DateTimeInputData>(
          initialValue: _getInitialValue(),
          key: formFieldKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (DateTimeInputData? value) {
            if (!required) {
              return null;
            }

            if (value?.date == null) {
              return 'Select date';
            }

            if (value?.time == null && showTime) {
              return 'Select time';
            }

            return validator?.call(value);
          },
          builder: (FormFieldState<DateTimeInputData> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (showDate)
                      _buildDateContent(
                        context: context,
                        field: field,
                      ),
                    if (showTime && showDate) const SizedBox(width: 50.0),
                    if (showTime)
                      _buildTimeContent(
                        context: context,
                        field: field,
                      ),
                  ],
                ),
                if (field.hasError) _buildErrorContent(field: field)
              ],
            );
          },
        ),
      ),
    );
  }

  DateTimeInputData? _getInitialValue() {
    if (initialValue?.date != null || initialValue?.time != null) {
      return initialValue;
    }

    if (!showTodaysInitialParameter) {
      return null;
    }

    return DateTimeInputData(
      date: DateTime.now(),
      time: TimeOfDay.now(),
    );
  }

  Widget _buildErrorContent({
    required FormFieldState<DateTimeInputData> field,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
        left: 12.0,
      ),
      child: Text(
        field.errorText!,
        style: errorStyle,
      ),
    );
  }

  Widget _buildTimeContent({
    required BuildContext context,
    required FormFieldState<DateTimeInputData> field,
  }) {
    final TimeOfDay? formFieldKeyTime = formFieldKey.currentState?.value?.time;
    return Expanded(
      child: Builder(
        builder: (BuildContext builderContext) => GestureDetector(
          onTap: () async {
            final TimeOfDay initialTimeOfDay = formFieldKeyTime ?? TimeOfDay.now();
            FocusNodeUtil.clearFocus(context);
            final TimeOfDay? result = await showTimePicker(
              routeSettings: const RouteSettings(name: '/time-picker'),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                  child: Theme(
                    data: ThemeData.light().copyWith(
                      textTheme: TextTheme(
                        labelSmall: labelSmallStyle,
                      ),
                      colorScheme: ColorScheme.light(
                        // change the border color
                        primary: borderColor ?? const Color(0xff6200ee),
                        // change the text color
                        onSurface: timeTextColor ?? Colors.black,
                      ),
                    ),
                    child: Localizations.override(
                      context: context,
                      locale: Locale(languageCode),
                      child: child ?? const SizedBox(),
                    ),
                  ),
                );
              },
              context: builderContext,
              initialTime: initialTimeOfDay,
            );
            if (result != null) {
              setTime(field: field, timeOfDay: result);
            }
          },
          child: AbsorbPointer(
            child: TextField(
              style: textStyle,
              controller: TextEditingController()..text = _getInitialTimeText(field, context),
              decoration: InputDecoration(
                contentPadding: contentPadding,
                errorStyle: errorStyle,
                focusColor: focusColor,
                errorBorder: errorBorder,
                focusedErrorBorder: focusedErrorBorder,
                filled: true,
                fillColor: fillColor,
                alignLabelWithHint: false,
                hintStyle: hintStyle,
                labelStyle: labelStyle,
                floatingLabelStyle: floatingLabelStyle,
                enabledBorder: enabledBorder,
                focusedBorder: focusedBorder,
                border: border,
                labelText: labelTimeText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateContent({
    required BuildContext context,
    required FormFieldState<DateTimeInputData> field,
  }) {
    final DateTime? formFieldKeyDate = formFieldKey.currentState?.value?.date;

    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () async {
          final DateTime initialDateTime = formFieldKeyDate ?? DateTime.now();
          FocusNodeUtil.clearFocus(context);
          final DateTime? result = await showDatePicker(
            locale: Locale.fromSubtags(languageCode: languageCode),
            routeSettings: const RouteSettings(name: '/date-picker'),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  textTheme: TextTheme(
                    labelSmall: labelSmallStyle,
                  ),
                  colorScheme: ColorScheme.light(
                    // change the border color
                    primary: borderColor ?? const Color(0xff6200ee),
                    // change the text color
                    onSurface: dateTextColor ?? Colors.black,
                  ),
                ),
                child: Localizations.override(
                  context: context,
                  locale: Locale(languageCode),
                  child: child ?? const SizedBox(),
                ),
              );
            },
            context: context,
            initialDate: _getInitialDate(initialDateTime),
            firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 30)),
            lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
            currentDate: initialDateTime,
            selectableDayPredicate: selectableDayPredicate,
          );
          if (result != null) {
            setDate(field: field, dateTime: result);
          }
        },
        child: AbsorbPointer(
          child: TextField(
            style: textStyle,
            controller: TextEditingController()..text = _getInitialDateText(field),
            decoration: InputDecoration(
              contentPadding: contentPadding,
              errorStyle: errorStyle,
              focusColor: focusColor,
              errorBorder: errorBorder,
              focusedErrorBorder: focusedErrorBorder,
              filled: true,
              fillColor: fillColor,
              alignLabelWithHint: false,
              hintStyle: hintStyle,
              labelStyle: labelStyle,
              floatingLabelStyle: floatingLabelStyle,
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              border: border,
              labelText: labelText,
            ),
          ),
        ),
      ),
    );
  }

  DateTime _getInitialDate(DateTime initialDateTime) {
    if (selectableDayPredicate == null) {
      return initialDateTime;
    }

    DateTime tempDateTime = initialDateTime.startOf(DateTimeType.day);

    while (!selectableDayPredicate!(tempDateTime)) {
      tempDateTime = tempDateTime.add(const Duration(days: 1));
    }

    return tempDateTime;
  }

  String _getInitialDateText(FormFieldState<DateTimeInputData> field) {
    final String? value = field.value?.date?.toDateString(languageCode);
    if (value != null) {
      return value;
    }

    return '';
  }

  String _getInitialTimeText(FormFieldState<DateTimeInputData> field, BuildContext context) {
    final TimeOfDay? value = field.value?.time;
    if (value != null) {
      final MaterialLocalizations localizations = MaterialLocalizations.of(context);
      final String formattedTimeOfDay = localizations.formatTimeOfDay(value, alwaysUse24HourFormat: true);

      return formattedTimeOfDay;
    }

    return '';
  }

  void setDate({
    required FormFieldState<DateTimeInputData> field,
    required DateTime dateTime,
  }) {
    if (field.value == null) {
      field.didChange(
        DateTimeInputData(
          date: endOfDay ? dateTime.endOf(DateTimeType.day) : dateTime.startOf(DateTimeType.day),
        ),
      );
    } else {
      field.didChange(
        field.value!.copyWithDate(
          endOfDay ? dateTime.endOf(DateTimeType.day) : dateTime.startOf(DateTimeType.day),
        ),
      );
    }

    if (onChanged != null) {
      onChanged!(field.value);
    }
  }

  void setTime({
    required FormFieldState<DateTimeInputData> field,
    required TimeOfDay timeOfDay,
  }) {
    if (field.value == null) {
      field.didChange(DateTimeInputData(time: timeOfDay));
    } else {
      field.didChange(field.value!.copyWithTime(timeOfDay));
    }

    if (onChanged != null) {
      onChanged!(field.value);
    }
  }
}
