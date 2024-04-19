import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'data/time_capsule.dart'; 

class CreateCapsuleScreen extends StatefulWidget {
  @override
  _CreateCapsuleScreenState createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<CreateCapsuleScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _message = '';
  String _description = ''; 
  DateTime _unlockDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  Box<TimeCapsule>? _capsuleBox;

  @override
  void initState() {
    super.initState();
    // Open the Hive box
    _openBox();
  }

  Future<void> _openBox() async {
    _capsuleBox = await Hive.openBox<TimeCapsule>('capsuleBox');
  }

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

  void _saveCapsule() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Create a new TimeCapsule object
      final newCapsule = TimeCapsule(
        title: _title,
        message: _message,
        description: _description, 
        unlockDate: _unlockDate,
      );
      // Save to the Hive box
      await _capsuleBox?.add(newCapsule);
      Navigator.pop(context);
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = '';
      _message = '';
      _description = '';
      _unlockDate = DateTime.now(); // Reset to current date
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Time Capsule'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity!.abs() > 700) { // Add a threshold to avoid accidental clears
            _clearForm();
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) => _title = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Message'),
                  onSaved: (value) => _message = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter a message' : null,
                  maxLines: 3,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description (optional)'),
                  onSaved: (value) => _description = value!,
                  maxLines: 3,
                ),
                ListTile(
                  title: Text('Unlock Date: ${_dateFormat.format(_unlockDate)}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _pickDate(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: GestureDetector(
                    onDoubleTap: _saveCapsule, // Double tap to save
                    child: ElevatedButton(
                      onPressed: _saveCapsule,
                      child: Text('Save Capsule'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
