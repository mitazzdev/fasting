import 'package:flutter/material.dart';

class ctAlertDialog extends StatelessWidget {
  const ctAlertDialog({
    Key? key,
    required this.nameCtrl,
    required this.misseDayCtrl,
    required this.makeupDayCtrl,
  }) : super(key: key);

  final TextEditingController nameCtrl;
  final TextEditingController misseDayCtrl;
  final TextEditingController makeupDayCtrl;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // Create a GlobalKey

    return AlertDialog(
      title: Text('Add new user'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey, // Assign the GlobalKey to the Form
          child: Column(
            children: [
              ctTextFormField(
                label: 'ชื่อ',
                nameCtrl: nameCtrl,
                isNumber: false,
              ),
              ctTextFormField(label: 'จำนวนวันที่ขาด', nameCtrl: misseDayCtrl),
              ctTextFormField(
                  label: 'จำนวนวันที่ชดใช้', nameCtrl: makeupDayCtrl),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // All validation checks passed, save the data
              // Add your save logic here

              // Close the dialog
              Navigator.of(context).pop();
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

class ctTextFormField extends StatelessWidget {
  const ctTextFormField({
    Key? key,
    required this.nameCtrl,
    required this.label,
    this.isNumber = true,
  }) : super(key: key);

  final TextEditingController nameCtrl;
  final String label;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: label,
        ),
        controller: nameCtrl,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
      ),
    );
  }
}
