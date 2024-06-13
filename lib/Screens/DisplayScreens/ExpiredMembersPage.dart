import 'package:arjunagym/Provider/MemberProvider.dart';
import 'package:arjunagym/Provider/GymPlanProvider.dart';
import 'package:arjunagym/Widgets/MemberCard.dart';
import 'package:arjunagym/Screens/DisplayScreens/MemberDetailsPage.dart';
import 'package:arjunagym/Screens/SearchScreen.dart';
import 'package:arjunagym/Widgets/UniversalVariables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpiredMembersPage extends StatefulWidget {
  @override
  _ExpiredMembersPageState createState() => _ExpiredMembersPageState();
}

class _ExpiredMembersPageState extends State<ExpiredMembersPage> {
  @override
  void initState() {
    super.initState();
    // Fetch members when the page is initialized
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    memberProvider.fetchExpiredMembers().then((_) {
      setState(() {}); // Rebuild the widget after fetching members
    });
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final expiredMembers = memberProvider.expiredMembers;

    return Scaffold(
      backgroundColor: UniversalVariables.bgColor,
      appBar: AppBar(
        backgroundColor: UniversalVariables.appThemeColor,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Expired Members',
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
      body: expiredMembers.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: expiredMembers.length,
              itemBuilder: (context, index) {
                final expiredMember = expiredMembers[index];
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MemberDetailsPage(member: expiredMember)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: MemberCard(
                        member: expiredMember,
                      ),
                    ));
              },
            ),
    );
  }
}
