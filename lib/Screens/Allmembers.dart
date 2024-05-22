
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MembersProvider.dart';
import 'package:arjunagym/Provider/PlanProvider.dart';
import 'package:arjunagym/Screens/MemberListPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllMembersPage extends StatefulWidget {
  @override
  _AllMembersPageState createState() => _AllMembersPageState();
}

class _AllMembersPageState extends State<AllMembersPage> {
  Future<void> _refreshMembers() async {
    // Call the fetchMembers method to refresh the members
    await Provider.of<MemberProvider>(context, listen: false).fetchAllMembers();
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final plans = Provider.of<GymPlanProvider>(context).plans;

    return Scaffold(
      appBar: AppBar(
        title: Text('All Members'),
      ),
      body: FutureBuilder<List<Member>>(
        future: memberProvider.fetchAllMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No members found.'));
          } else {
            final allMembers = snapshot.data!;
            return ListView.builder(
              itemCount: allMembers.length,
              itemBuilder: (context, index) {
                final member = allMembers[index];
                return MemberCard(member: member);
              },
            );
          }
        },
      ),
    );
  }
}
