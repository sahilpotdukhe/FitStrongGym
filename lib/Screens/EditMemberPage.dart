
import 'package:arjunagym/Models/GymPlan.dart';
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MembersProvider.dart';
import 'package:arjunagym/Provider/PlanProvider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditMemberPage extends StatefulWidget {
  final Member member;

  const EditMemberPage({required this.member});

  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  late TextEditingController _nameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _addressController;
  late TextEditingController _genderController;
  late TextEditingController _admissionDateController;
  bool _loading = false;
  GymPlan? _selectedPlan;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _mobileNumberController = TextEditingController(text: widget.member.mobileNumber);
    _heightController = TextEditingController(text: widget.member.height.toString());
    _weightController = TextEditingController(text: widget.member.weight.toString());
    _addressController = TextEditingController(text: widget.member.address);
    _genderController = TextEditingController(text: widget.member.gender);
    _admissionDateController = TextEditingController(text: DateFormat('dd-MM-yyyy').format(widget.member.dateOfAdmission));
  }

  @override
  Widget build(BuildContext context) {
    final plans = Provider.of<GymPlanProvider>(context).plans;

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
              controller: _admissionDateController,
              decoration: InputDecoration(labelText: 'Admission Date'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.member.dateOfAdmission,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _admissionDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                  });
                }
              },
            ),
            DropdownButtonFormField<GymPlan>(
              value: _selectedPlan,
              decoration: InputDecoration(labelText: 'Select New Plan'),
              items: plans.map((GymPlan plan) {
                return DropdownMenuItem<GymPlan>(
                  value: plan,
                  child: Text(plan.name),
                );
              }).toList(),
              onChanged: (GymPlan? newPlan) {
                setState(() {
                  _selectedPlan = newPlan;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateMemberDetails,
              child: Text('Save Details'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _renewMembership,
              child: Text('Renew Membership'),
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
        'gender': _genderController.text,
        'dateOfAdmission': DateFormat('dd-MM-yyyy').parse(_admissionDateController.text),
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

  Future<void> _renewMembership() async {
    if (_selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a plan')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final newDateOfAdmission = DateFormat('dd-MM-yyyy').parse(_admissionDateController.text);
      final renewedMember = widget.member.renewMembership(_selectedPlan!, newDateOfAdmission);
      await Provider.of<MemberProvider>(context, listen: false).updateMember(renewedMember);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membership renewed successfully')),
      );
      Navigator.pop(context);  // Go back to the previous screen
    } catch (error) {
      print('Error renewing membership: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to renew membership')),
      );
    }

    setState(() {
      _loading = false;
    });
  }
}
