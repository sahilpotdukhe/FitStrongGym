import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MembersProvider.dart';
import 'package:arjunagym/Provider/PlanProvider.dart';

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
        title: Text('Recycle Bin Members'),
      ),
      body: recycleBinMembers.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: recycleBinMembers.length,
              itemBuilder: (context, index) {
                final recycleBinMember = recycleBinMembers[index];
                return ListTile(
                  title: Text(recycleBinMember.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mobile Number: ${recycleBinMember.mobileNumber}'),
                      Text(
                          'Date of Birth: ${DateFormat('dd-MM-yyyy').format(recycleBinMember.dateOfBirth)}'),
                      Text('Height: ${recycleBinMember.height} cm'),
                      Text('Weight: ${recycleBinMember.weight} kg'),
                      Text(
                          'Admission Date: ${DateFormat('dd-MM-yyyy').format(recycleBinMember.dateOfAdmission)}'),
                      Text(
                          'Plan Status: ${recycleBinMember.isExpired(Provider.of<GymPlanProvider>(context, listen: false).plans) ? 'Expired' : 'Active'}'),
                      Text(
                          'Expiry Date: ${DateFormat('dd-MM-yyyy').format(recycleBinMember.expiryDate)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.restore),
                    onPressed: () {
                      _showConfirmationDialog(context, recycleBinMember);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showConfirmationDialog(BuildContext context, Member recycleBinMember) {
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
