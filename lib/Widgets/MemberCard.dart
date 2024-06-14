import 'package:arjunagym/Models/GymPlanModel.dart';
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MemberProvider.dart';
import 'package:arjunagym/Provider/GymPlanProvider.dart';
import 'package:arjunagym/Screens/EditScreens/EditMemberDetailsPage.dart';
import 'package:arjunagym/Widgets/UniversalVariables.dart';
import 'package:arjunagym/Screens/EditScreens/RenewMembershipPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MemberCard extends StatefulWidget {
  final MemberModel member;

  const MemberCard({super.key, required this.member});

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  @override
  Widget build(BuildContext context) {
    final plans = Provider.of<GymPlanProvider>(context, listen: false).plans;
    final plan = GymPlanModel.findById(plans, widget.member.planId);
    final planName = plan?.name ?? 'Unknown Plan';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 15,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                widget.member.photoUrl),
                            fit: BoxFit.cover),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Name: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(widget.member.name,style: TextStyle(color: Colors.white),),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Address: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(widget.member.address,style: TextStyle(color: Colors.white),),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Gender: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(widget.member.gender,style: TextStyle(color: Colors.white),),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Mobile: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(widget.member.mobileNumber,style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 30,
                    ),
                    color: Colors.red,
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text(
                                'Are you sure you want to delete this member?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        try {
                          User? currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null) {
                            // Delete the member from the user's members subcollection
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(currentUser.uid)
                                .collection('members')
                                .doc(widget.member.id)
                                .delete();

                            // Move the member to the user's recyclebin subcollection
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(currentUser.uid)
                                .collection('recyclebin')
                                .doc(widget.member.id)
                                .set(widget.member.toMap());

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Member deleted successfully')),
                            );

                            // Refresh the member list
                            Provider.of<MemberProvider>(context, listen: false)
                                .getAllMembers();
                          }
                        } catch (error) {
                          print('Error deleting member: $error');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to delete member')),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Date of Birth: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                              '${DateFormat('dd-MM-yyyy').format(widget.member.dateOfBirth)}',style: TextStyle(color: Colors.white),),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Admission Date: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                              '${DateFormat('dd-MM-yyyy').format(widget.member.dateOfAdmission)}',style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Plan: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(planName,style: TextStyle(color: Colors.white),),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Expiry Date: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                              '${DateFormat('dd-MM-yyyy').format(widget.member.expiryDate)}',style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditMemberDetailsPage(member: widget.member),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey, width:1)),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: HexColor('D4D6FF'),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Edit'),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.edit)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RenewMembershipPage(member: widget.member),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                          border: Border(top: BorderSide(color: Colors.white, width: 1)),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Renew',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.autorenew,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
