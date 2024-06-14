import 'package:arjunagym/Widgets/RecycleMemberCard.dart';
import 'package:arjunagym/Widgets/UniversalVariables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MemberProvider.dart';
import 'package:arjunagym/Provider/GymPlanProvider.dart';

class RecycleBinPage extends StatefulWidget {
  @override
  _RecycleBinPageState createState() => _RecycleBinPageState();
}

class _RecycleBinPageState extends State<RecycleBinPage> {
  @override
  void initState() {
    super.initState();
    // Fetch recycle bin members when the page is initialized
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    memberProvider.fetchRecycleBinMembers();
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final recycleBinMembers = memberProvider.recycleBinMembers;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: UniversalVariables.appThemeColor,
        title: Text('Recycle Bin Members',style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, '/home');
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: recycleBinMembers.isEmpty
          ? Center(child: Center(child: Text('No members are deleted'),))
          : ListView.builder(
              itemCount: recycleBinMembers.length,
              itemBuilder: (context, index) {
                final recycleBinMember = recycleBinMembers[index];
                return RecycleMemberCard(recycleBinMember: recycleBinMember);
              },
            ),
    );
  }
}
