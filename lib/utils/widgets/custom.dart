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
    return AlertDialog(
      title: Text('Add new user'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ctTextFormField(
              label: 'ชื่อ',
              nameCtrl: nameCtrl,
              isNumber: false,
            ),
            ctTextFormField(label: 'จำนวนวันที่ขาด', nameCtrl: misseDayCtrl),
            ctTextFormField(label: 'จำนวนวันที่ชดใช้', nameCtrl: makeupDayCtrl),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Save'),
        ),
      ],
    );
  }
}

class ctTextFormField extends StatelessWidget {
  ctTextFormField({
    super.key,
    required this.nameCtrl,
    required this.label,
    this.isNumber = true,
  });

  final TextEditingController nameCtrl;
  final String label;
  bool isNumber = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.name,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: label,
        ),
        controller: nameCtrl,
      ),
    );
  }
}
