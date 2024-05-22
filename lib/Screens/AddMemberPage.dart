import 'dart:io';

import 'package:arjunagym/Models/GymPlan.dart';
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MembersProvider.dart';
import 'package:arjunagym/Provider/PlanProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddMemberPage extends StatefulWidget {
  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _photo;
  String? _gender;
  String? _planId;
  double _selectedPlanFee = 0.0;
  DateTime? _dateOfBirth;
  DateTime? _dateOfAdmission;
  bool _isLoading = false;

  void _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _photo = pickedFile;
    });
  }

  void _pickDateOfBirth() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateOfBirth = pickedDate;
      });
    }
  }

  void _pickDateOfAdmission() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateOfAdmission ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateOfAdmission = pickedDate;
      });
    }
  }

  void _saveForm() async {
    final plans = Provider.of<GymPlanProvider>(context, listen: false).plans;

    if (_formKey.currentState!.validate() && _photo != null) {
      setState(() {
        _isLoading = true;
      });

      // Find the selected plan to get the duration in months
      final selectedPlan = GymPlan.findById(plans, _planId!);
      if (selectedPlan == null) {
        // Handle error
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected plan not found')),
        );
        return;
      }

      final expiryDate = DateTime(
        _dateOfAdmission!.year,
        _dateOfAdmission!.month + selectedPlan.months,
        _dateOfAdmission!.day,
      );

      final newMember = Member(
        id: '',
        name: _nameController.text,
        mobileNumber: _mobileNumberController.text,
        dateOfBirth: _dateOfBirth!,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        photoUrl: '', // This will be updated in provider
        planId: _planId!,
        dateOfAdmission: _dateOfAdmission!,
        expiryDate: expiryDate, // Set expiry date
        address: _addressController.text,
        gender: _gender!,
      );

      await Provider.of<MemberProvider>(context, listen: false).addMember(newMember, _photo!);

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final plans = Provider.of<GymPlanProvider>(context).plans;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _mobileNumberController,
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a mobile number';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: _pickDateOfBirth,
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: _dateOfBirth != null
                            ? DateFormat('dd/MM/yyyy').format(_dateOfBirth!)
                            : null,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'Select Date of Birth',
                      ),
                      validator: (value) {
                        if (_dateOfBirth == null) {
                          return 'Please select a date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),


                TextFormField(
                  controller: _heightController,
                  decoration: InputDecoration(labelText: 'Height (cm)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a height';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a weight';
                    }
                    return null;
                  },
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
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Plan'),
                  value: _planId,
                  onChanged: (value) {
                    setState(() {
                      _planId = value;
                      // Find the selected plan and set the fee
                      final selectedPlan = GymPlan.findById(plans, value!);
                      if (selectedPlan != null) {
                        _selectedPlanFee = selectedPlan.fee;
                      }
                    });
                  },
                  items: plans
                      .map((plan) => DropdownMenuItem(
                    child: Text(plan.name),
                    value: plan.id, // Using plan.id as the unique identifier
                  ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a plan';
                    }
                    return null;
                  },
                ),
                Text('Fee to be paid: \$$_selectedPlanFee'),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: _pickDateOfAdmission,
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: _dateOfAdmission != null
                            ? DateFormat('dd/MM/yyyy').format(_dateOfAdmission!)
                            : null,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Date of Admission',
                        hintText: 'Select Date of Admission',
                      ),
                      validator: (value) {
                        if (_dateOfAdmission == null) {
                          return 'Please select a date of admission';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        child: Text('Pick Image from Gallery'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.camera),
                        child: Text('Pick Image from Camera'),
                      ),
                    ),
                  ],
                ),
                _photo != null
                    ? Image.file(
                  File(_photo!.path),
                  height: 100,
                  width: 100,
                )
                    : Container(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text('Save Member'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
