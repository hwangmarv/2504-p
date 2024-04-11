import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateCapsuleScreen extends StatefulWidget {
  @override
  _CreateCapsuleScreenState createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<CreateCapsuleScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _message = '';
  DateTime _unlockDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _unlockDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _unlockDate) {
      setState(() {
        _unlockDate = picked;
      });
    }
  }

  void _saveCapsule() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here, you would usually send the data to your database.
      // For now, let's just print it to the console.
      print('Saving Capsule:');
      print('Title: $_title');
      print('Message: $_message');
      print('Unlock Date: ${_dateFormat.format(_unlockDate)}');
      // Navigate back to the previous screen after saving.
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Time Capsule'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Message'),
                onSaved: (value) {
                  _message = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              ListTile(
                title: Text('Unlock Date: ${_dateFormat.format(_unlockDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickDate(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _saveCapsule,
                  child: Text('Save Capsule'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
