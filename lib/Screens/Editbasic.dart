import 'package:arjunagym/Models/MemberModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditMemberDetailsPage extends StatefulWidget {
  final Member member;

  const EditMemberDetailsPage({required this.member});

  @override
  _EditMemberDetailsPageState createState() => _EditMemberDetailsPageState();
}

class _EditMemberDetailsPageState extends State<EditMemberDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _addressController;
  late TextEditingController _genderController;
  bool _loading = false;
  String? _gender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _mobileNumberController = TextEditingController(text: widget.member.mobileNumber);
    _heightController = TextEditingController(text: widget.member.height.toString());
    _weightController = TextEditingController(text: widget.member.weight.toString());
    _addressController = TextEditingController(text: widget.member.address);
    _genderController = TextEditingController(text: widget.member.gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Member Details'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _mobileNumberController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Gender'),
              value: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value;
                });
              },
              items: ['Male', 'Female', 'Other']
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select a gender';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateMemberDetails,
              child: Text('Save Details'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateMemberDetails() async {
    setState(() {
      _loading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('members')
          .doc(widget.member.id)
          .update({
        'name': _nameController.text,
        'mobileNumber': _mobileNumberController.text,
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
        'address': _addressController.text,
        'gender': _gender,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Member details updated successfully')),
      );
    } catch (error) {
      print('Error updating member details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update member details')),
      );
    }

    setState(() {
      _loading = false;
    });
  }
}
