import 'package:arjunagym/Screens/EditScreens/EditMemberDetailsPage.dart';
import 'package:arjunagym/Widgets/MemberCard.dart';
import 'package:arjunagym/Screens/DisplayScreens/MemberDetailsPage.dart';
import 'package:arjunagym/Screens/SearchScreen.dart';
import 'package:arjunagym/Widgets/UniversalVariables.dart';
import 'package:arjunagym/Screens/EditScreens/RenewMembershipPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arjunagym/Models/GymPlanModel.dart';
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MemberProvider.dart';
import 'package:arjunagym/Provider/GymPlanProvider.dart';
import 'package:intl/intl.dart';

class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  @override
  void initState() {
    super.initState();
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    final gymPlanProvider =
        Provider.of<GymPlanProvider>(context, listen: false);
    memberProvider.getAllMembers();
    gymPlanProvider.fetchPlans(); // Fetch plans
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: UniversalVariables.bgColor,
        appBar: AppBar(
          backgroundColor: UniversalVariables.appThemeColor,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            'Member List',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All Members'),
              Tab(text: 'Active Members'),
              Tab(text: 'Expired Members'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
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
        body: TabBarView(
          children: [
            MemberListSection(
              filter: (member, plans) => true,
              emptyMessage: 'No members found.',
            ),
            MemberListSection(
              filter: (member, plans) => !member.isExpired(plans),
              emptyMessage: 'No active members found.',
            ),
            MemberListSection(
              filter: (member, plans) => member.isExpired(plans),
              emptyMessage: 'No expired members found.',
            ),
          ],
        ),
      ),
    );
  }
}

class MemberListSection extends StatelessWidget {
  final bool Function(MemberModel, List<GymPlanModel>) filter;
  final String emptyMessage;

  const MemberListSection({
    required this.filter,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final gymPlanProvider = Provider.of<GymPlanProvider>(context);
    final members = memberProvider.members;
    final plans = gymPlanProvider.plans;

    if (members.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final filteredMembers =
        members.where((member) => filter(member, plans)).toList();

    if (filteredMembers.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) {
        final member = filteredMembers[index];
        final plan = GymPlanModel.findById(plans, member.planId);
        final planName = plan?.name ?? 'Unknown Plan';
        return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MemberDetailsPage(member: member)));
            },
            child: MemberCard(member: member));
      },
    );
  }
}
