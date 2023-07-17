import 'package:flutter/material.dart';

class SelectTime extends StatefulWidget {
  const SelectTime({super.key, required this.onSaveTime});

  final Function(String, String) onSaveTime;

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TimeOfDay? _startTime;

  TimeOfDay? _endTime;

  TimeOfDay shownTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: shownTime,
    );

    if (selectedTime != null) {
      setState(() {
        shownTime = selectedTime;
        if (isStartTime) {
          _startTime = selectedTime;
        } else {
          _endTime = selectedTime;
        }
      });
    }
    if (_startTime != null && _endTime != null) {
      widget.onSaveTime(_formatTime(_startTime)!, _formatTime(_endTime)!);
    }
  }

  String? _validateTime(TimeOfDay? value, bool isStartTime) {
    if (value == null) {
      return 'Please select a time';
    }
    if (isStartTime && _endTime != null && value.hour > _endTime!.hour) {
      return 'Can\'t be after end time';
    }
    if (!isStartTime && _startTime != null && value.hour < _startTime!.hour) {
      return 'Can\'t be before start time';
    }
    return null;
  }

  String? _formatTime(TimeOfDay? time) {
    if (time == null) {
      return null;
    }
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }

  TextStyle _getTimeTextStyle(bool isSelected) {
    return TextStyle(
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() == true) {}
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextFormField(
            onTap: () {
              _selectTime(context, true);
            },
            readOnly: true,
            decoration: const InputDecoration(
                labelText: 'Start Time',
                labelStyle: TextStyle(color: Colors.blue, fontSize: 16),
                suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
            validator: (value) => _validateTime(_startTime, true),
            controller: TextEditingController(
              text: _formatTime(_startTime),
            ),
            style: _getTimeTextStyle(_startTime != null),
          ),
        ),
        const SizedBox(width: 50),
        Flexible(
          child: TextFormField(
            onChanged: (value) => _submitForm,
            onTap: () {
              _selectTime(context, false);
            },
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'End Time',
              labelStyle: TextStyle(color: Colors.blue, fontSize: 16),
              suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
            ),
            validator: (value) => _validateTime(_endTime, false),
            controller: TextEditingController(
              text: _formatTime(_endTime),
            ),
            style: _getTimeTextStyle(_endTime != null),
          ),
        ),
      ],
    );
  }
}
