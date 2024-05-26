import 'package:flutter/material.dart';
import 'package:arjunagym/Models/GymPlan.dart';
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MembersProvider.dart';
import 'package:arjunagym/Provider/PlanProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RenewMembershipPage extends StatefulWidget {
  final Member member;

  const RenewMembershipPage({required this.member});

  @override
  _RenewMembershipPageState createState() => _RenewMembershipPageState();
}

class _RenewMembershipPageState extends State<RenewMembershipPage> {
  late TextEditingController _renewalDateController;
  late TextEditingController _cashAmountController;
  bool _loading = false;
  GymPlan? _selectedPlan;
  String? _selectedPaymentMethod;
  final List<String> _paymentMethods = ['Cash', 'Online'];

  @override
  void initState() {
    super.initState();
    _renewalDateController = TextEditingController(text: DateFormat('dd-MM-yyyy').format(widget.member.renewalDate));
    _cashAmountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final plans = Provider.of<GymPlanProvider>(context).plans;

    return Scaffold(
      appBar: AppBar(
        title: Text('Renew Membership'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Name: ${widget.member.name}'),
            TextFormField(
              controller: _renewalDateController,
              decoration: InputDecoration(labelText: 'Renewal Date'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.member.renewalDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _renewalDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
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
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              decoration: InputDecoration(labelText: 'Select Payment Method'),
              items: _paymentMethods.map((String method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (String? newMethod) {
                setState(() {
                  _selectedPaymentMethod = newMethod;
                });
              },
            ),
            if (_selectedPaymentMethod == 'Cash')
              Padding(
                padding:  EdgeInsets.all(18.0),
                child: Center(child: Text('${_selectedPlan!.fee}')),
              ),
            if (_selectedPaymentMethod == 'Online')
              Column(
                children: [
                  SizedBox(height: 20),
                  Center(child: Text('\$ ${_selectedPlan!.fee}')),
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/QRcode.jpg', // Replace with your QR code image URL
                    height: 350,
                    width: 350,
                  ),
                  SizedBox(height: 10),
                  Text('Scan the QR code to pay online'),
                ],
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

  Future<void> _renewMembership() async {
    if (_selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a plan')),
      );
      return;
    }
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }
    if (_selectedPaymentMethod == 'Cash' && _cashAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the cash amount')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final newDateOfRenewal = DateFormat('dd-MM-yyyy').parse(_renewalDateController.text);
      final renewedMember = widget.member.renewMembership(_selectedPlan!, newDateOfRenewal);
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
