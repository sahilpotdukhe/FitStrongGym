import 'package:arjunagym/Provider/MemberProvider.dart';
import 'package:arjunagym/Provider/GymPlanProvider.dart';
import 'package:arjunagym/Widgets/MemberCard.dart';
import 'package:arjunagym/Screens/DisplayScreens/MemberDetailsPage.dart';
import 'package:arjunagym/Screens/SearchScreen.dart';
import 'package:arjunagym/Widgets/MembersQuietBox.dart';
import 'package:arjunagym/Widgets/UniversalVariables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActiveMembersPage extends StatefulWidget {
  const ActiveMembersPage({super.key});

  @override
  _ActiveMembersPageState createState() => _ActiveMembersPageState();
}

class _ActiveMembersPageState extends State<ActiveMembersPage> {
  @override
  void initState() {
    super.initState();
    // Fetch members when the page is initialized
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    memberProvider.fetchActiveMembers().then((_) {
      setState(() {}); // Rebuild the widget after fetching members
    });
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final activeMembers = memberProvider.activeMembers;

    return Scaffold(
      backgroundColor: UniversalVariables.bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: UniversalVariables.appThemeColor,
        title: Text(
          'Active Members',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
          )
        ],
      ),
      body: activeMembers.isEmpty
          ? MembersQuietBox(screen: 'nomembers',)
          : ListView.builder(
              itemCount: activeMembers.length,
              itemBuilder: (context, index) {
                final activeMember = activeMembers[index];
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MemberDetailsPage(member: activeMember)));
                    },
                    child: MemberCard(
                      member: activeMember,
                    ));
              },
            ),
    );
  }
}
