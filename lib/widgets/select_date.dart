import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDate extends StatefulWidget {
  final Function(String) onSaveDate;

  const SelectDate({super.key, required this.onSaveDate});

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  final TextEditingController _dateController = TextEditingController();

  String? _validateDateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    return null;
  }

  Future<void> _onDateSelect() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 6)),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            DateFormat('EEEE, d MMMM', 'en_US').format(pickedDate);
        widget.onSaveDate(_dateController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: TextFormField(
            controller: _dateController,
            validator: _validateDateName,
            readOnly: true,
            onTap: _onDateSelect,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              labelText: 'Date',
              labelStyle: TextStyle(color: Colors.blue, fontSize: 16),
              contentPadding: EdgeInsets.symmetric(vertical: 8.0),
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: _onDateSelect,
          color: Colors.white,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          icon: const Icon(Icons.calendar_today_outlined),
        ),
      ],
    );
  }
}
