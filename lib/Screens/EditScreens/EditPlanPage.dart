import 'package:arjunagym/Provider/GymPlanProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arjunagym/Models/GymPlanModel.dart';

class EditPlanPage extends StatefulWidget {
  final GymPlanModel plan;

  EditPlanPage({required this.plan});

  @override
  _EditPlanPageState createState() => _EditPlanPageState();
}

class _EditPlanPageState extends State<EditPlanPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _months;
  late double _fee;
  late bool _personalTraining;

  @override
  void initState() {
    super.initState();
    _name = widget.plan.name;
    _months = widget.plan.months;
    _fee = widget.plan.fee;
    _personalTraining = widget.plan.personalTraining;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Plan Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the plan name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _months.toString(),
                decoration: InputDecoration(labelText: 'Duration (Months)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  return null;
                },
                onSaved: (value) => _months = int.parse(value!),
              ),
              TextFormField(
                initialValue: _fee.toString(),
                decoration: InputDecoration(labelText: 'Fee'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the fee';
                  }
                  return null;
                },
                onSaved: (value) => _fee = double.parse(value!),
              ),
              SwitchListTile(
                title: Text('Personal Training'),
                value: _personalTraining,
                onChanged: (value) {
                  setState(() {
                    _personalTraining = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<GymPlanProvider>(context, listen: false)
                        .updatePlan(
                      widget.plan.id,
                      _name,
                      _months,
                      _fee,
                      _personalTraining,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
