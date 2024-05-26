import 'package:arjunagym/Provider/MembersProvider.dart';
import 'package:arjunagym/Provider/PlanProvider.dart';
import 'package:arjunagym/Screens/MemberDetails.dart';
import 'package:arjunagym/Screens/SearchScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DisplayallMembers extends StatefulWidget {
  @override
  _DisplayallMembersState createState() => _DisplayallMembersState();
}

class _DisplayallMembersState extends State<DisplayallMembers> {
  @override
  void initState() {
    super.initState();
    // Fetch members when the page is initialized
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    memberProvider.getAllMembers().then((_) {
      setState(() {}); // Rebuild the widget after fetching members
    });
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final members = memberProvider.members;

    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
            },
          )
        ],
      ),
      body: members.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MemberDetailsPage(member: member)));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(member.photoUrl),
                    ),
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
                            User? currentUser = FirebaseAuth.instance.currentUser;
                            if (currentUser != null) {
                              // Delete the member from the user's members subcollection
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(currentUser.uid)
                                  .collection('members')
                                  .doc(member.id)
                                  .delete();

                              // Move the member to the user's recyclebin subcollection
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(currentUser.uid)
                                  .collection('recyclebin')
                                  .doc(member.id)
                                  .set(member.toMap());

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Member deleted successfully')),
                              );

                              // Refresh the member list
                              Provider.of<MemberProvider>(context, listen: false).getAllMembers();
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
                  ),
                );
              },
            ),
    );
  }
}
