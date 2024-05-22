import 'package:arjunagym/Models/MemberModel.dart';
import 'package:arjunagym/Provider/MembersProvider.dart';
import 'package:arjunagym/Provider/PlanProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecycleBinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle Bin Members'),
      ),
      body: FutureBuilder<List<Member>>(
        future: Provider.of<MemberProvider>(context, listen: false).fetchRecycleBinMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recycle bin members found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final recycleBinMember = snapshot.data![index];
                return ListTile(
                  title: Text(recycleBinMember.name),
                  // Display other member details as needed
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mobile Number: ${recycleBinMember.mobileNumber}'),
                      Text('Date of Birth: ${DateFormat('dd-MM-yyyy').format(recycleBinMember.dateOfBirth)}'),
                      Text('Height: ${recycleBinMember.height} cm'),
                      Text('Weight: ${recycleBinMember.weight} kg'),
                      Text('Admission Date: ${DateFormat('dd-MM-yyyy').format(recycleBinMember.dateOfAdmission)}'),
                      Text('Plan Status: ${recycleBinMember.isExpired(Provider.of<GymPlanProvider>(context, listen: false).plans) ? 'Expired' : 'Active'}'),
                      Text('Expiry Date: ${DateFormat('dd-MM-yyyy').format(recycleBinMember.expiryDate)}'),
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
            );
          }
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
                Provider.of<MemberProvider>(context, listen: false).restoreMember(recycleBinMember);
                // Refresh the page by loading
                Provider.of<MemberProvider>(context, listen: false).fetchRecycleBinMembers();
              },
              child: Text('Restore'),
            ),
          ],
        );
      },
    );
  }
}
