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

class RecycleMemberCard extends StatefulWidget {
  final MemberModel recycleBinMember;

  const RecycleMemberCard({super.key, required this.recycleBinMember});

  @override
  State<RecycleMemberCard> createState() => _RecycleMemberCardState();
}

class _RecycleMemberCardState extends State<RecycleMemberCard> {
  @override
  Widget build(BuildContext context) {
    final plans = Provider.of<GymPlanProvider>(context, listen: false).plans;
    final plan = GymPlanModel.findById(plans, widget.recycleBinMember.planId);
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                                  widget.recycleBinMember.photoUrl),
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
                            Text(widget.recycleBinMember.name,style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Address: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(widget.recycleBinMember.address,style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Gender: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(widget.recycleBinMember.gender,style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Mobile: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(widget.recycleBinMember.mobileNumber,style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.restore,
                        size: 30,
                      ),
                      color: Colors.red,
                      onPressed: () async {
                        _showConfirmationDialog(context, widget.recycleBinMember);
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
                              '${DateFormat('dd-MM-yyyy').format(widget.recycleBinMember.dateOfBirth)}',style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Admission Date: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '${DateFormat('dd-MM-yyyy').format(widget.recycleBinMember.dateOfAdmission)}',style: TextStyle(color: Colors.white),),
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
                              '${DateFormat('dd-MM-yyyy').format(widget.recycleBinMember.expiryDate)}',style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, MemberModel recycleBinMember) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Restore'),
          content: Text('Do you want to restore ${recycleBinMember.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Provider.of<MemberProvider>(context, listen: false)
                    .restoreMember(recycleBinMember);
                // Refresh the page by re-fetching the recycle bin members
                Provider.of<MemberProvider>(context, listen: false)
                    .fetchRecycleBinMembers();
              },
              child: Text('Restore'),
            ),
          ],
        );
      },
    );
  }
}
