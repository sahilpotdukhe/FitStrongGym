import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Widgets/ScaleUtils.dart';
import 'package:arjunagym/Widgets/UniversalVariables.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class EditMemberDetailsPage extends StatefulWidget {
  final MemberModel member;

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
  String? displayName;
  String? phoneNumber;


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _mobileNumberController =
        TextEditingController(text: widget.member.mobileNumber);
    _heightController =
        TextEditingController(text: widget.member.height.toString());
    _weightController =
        TextEditingController(text: widget.member.weight.toString());
    _addressController = TextEditingController(text: widget.member.address);
    _genderController = TextEditingController(text: widget.member.gender);
  }

  @override
  Widget build(BuildContext context) {
    ScaleUtils.init(context);
    return Stack(
      children: [
       Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: UniversalVariables.appThemeColor,
          title: Text('Edit Member Details',style: TextStyle(color: Colors.white),),
        ),
        body: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  widget.member.photoUrl),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Update Your Name',
                        labelText: 'Name',
                        labelStyle: TextStyle(
                            fontSize: 16.0 * ScaleUtils.scaleFactor),
                        floatingLabelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18 * ScaleUtils.scaleFactor,
                            color: HexColor('3957ED')),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor('3957ED'), width: 2)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: HexColor('3957ED'), width: 2),
                        ),
                        suffixIcon:
                        Icon(Icons.person, color: HexColor('3957ED')),
                      ),
                      onSaved: (value) {
                        displayName = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _mobileNumberController,
                      decoration: InputDecoration(
                        hintText: 'Update Phone number',
                        labelText: 'Phone number',
                        counterText: "",
                        labelStyle: TextStyle(
                            fontSize: 16.0 * ScaleUtils.scaleFactor),
                        floatingLabelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18 * ScaleUtils.scaleFactor,
                            color: HexColor('3957ED')),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.phone_android_outlined,
                            color: HexColor('3957ED')),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor('3957ED'), width: 2)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: HexColor('3957ED'), width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                      onSaved: (value) {
                        phoneNumber = value;
                      },
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Phone No';
                        } else if (value.length < 10) {
                          return 'Enter 10 digit Phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _heightController,
                      decoration: InputDecoration(
                        hintText: 'Update Height',
                        labelText: 'Height (cm)',
                        labelStyle: TextStyle(
                            fontSize: 16.0 * ScaleUtils.scaleFactor),
                        floatingLabelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18 * ScaleUtils.scaleFactor,
                            color: HexColor('3957ED')),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor('3957ED'), width: 2)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: HexColor('3957ED'), width: 2),
                        ),
                        suffixIcon:
                        Icon(Icons.height, color: HexColor('3957ED')),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a height';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        hintText: 'Update Your Weight',
                        labelText: 'Weight (kg)',
                        labelStyle: TextStyle(
                            fontSize: 16.0 * ScaleUtils.scaleFactor),
                        floatingLabelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18 * ScaleUtils.scaleFactor,
                            color: HexColor('3957ED')),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor('3957ED'), width: 2)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: HexColor('3957ED'), width: 2),
                        ),
                        suffixIcon:
                        Icon(Icons.monitor_weight, color: HexColor('3957ED')),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a weight';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Update Address',
                        labelText: 'Address',
                        labelStyle: TextStyle(
                            fontSize: 16.0 * ScaleUtils.scaleFactor),
                        floatingLabelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18 * ScaleUtils.scaleFactor,
                            color: HexColor('3957ED')),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.place,
                            color: HexColor('3957ED')),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor('3957ED'), width: 2)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: HexColor('3957ED'), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: _updateMemberDetails,
                      child: Text('Update Details',style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ),
      ),
        if (_loading)
          Positioned.fill(
            child:
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
    ]
    );
  }

  Future<void> _updateMemberDetails() async {
    setState(() {
      _loading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .collection('members')
            .doc(widget.member.id)
            .update({
          'name': _nameController.text,
          'mobileNumber': _mobileNumberController.text,
          'height': double.parse(_heightController.text),
          'weight': double.parse(_weightController.text),
          'address': _addressController.text,
        });
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: true,
          dialogType: DialogType.success,
          showCloseIcon: true,
          //autoHide: Duration(seconds: 6),
          title: 'Updated!',
          desc:
          'You have successfully updated the details.\n Please wait you will be redirected to the HomePage.',
          btnOkOnPress: () {
            debugPrint('OnClcik');
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          },
        ).show();
        await Future.delayed(Duration(seconds: 4));
        Navigator.popAndPushNamed(context, '/home');
      }
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
