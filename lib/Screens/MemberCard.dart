import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MembersProvider.dart';
import 'package:arjunagym/Provider/PlanProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MemberCard extends StatelessWidget {
  final Member member;

  const MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(member.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mobile Number: ${member.mobileNumber}'),
            Text('Date of Birth: ${DateFormat('dd-MM-yyyy').format(member.dateOfBirth)}'),
            Text('Height: ${member.height} cm'),
            Text('Weight: ${member.weight} kg'),
            Text('Admission Date: ${DateFormat('dd-MM-yyyy').format(member.dateOfAdmission)}'),
            Text('Plan Status: ${member.isExpired(Provider.of<GymPlanProvider>(context, listen: false).plans) ? 'Expired' : 'Active'}'),
            Text('Expiry Date: ${DateFormat('dd-MM-yyyy').format(member.expiryDate)}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            // Show a confirmation dialog before deleting
            bool confirmDelete = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Deletion'),
                  content: Text('Are you sure you want to delete this member?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Delete'),
                    ),
                  ],
                );
              },
            );

            // If user confirms deletion, proceed to delete the member
            if (confirmDelete == true) {
              try {
                // Delete the member from the members collection
                await FirebaseFirestore.instance.collection('members').doc(member.id).delete();

                // Move the member to the recyclebin collection
                await FirebaseFirestore.instance.collection('recyclebin').doc(member.id).set(member.toMap());

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Member deleted successfully')),
                );

                // Refresh the member list
                Provider.of<MemberProvider>(context, listen: false).getAllMembers();
              } catch (error) {
                print('Error deleting member: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete member')),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

