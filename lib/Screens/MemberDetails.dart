import 'package:flutter/material.dart';
import 'package:arjunagym/Models/MemberModel.dart';
import 'package:intl/intl.dart';

class MemberDetailsPage extends StatelessWidget {
  final Member member;

  const MemberDetailsPage({required this.member, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    member.photoUrl.isNotEmpty
                        ? member.photoUrl
                        : 'https://icons.veryicon.com/png/o/miscellaneous/administration/person-16.png',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Name: ${member.name}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Mobile Number: ${member.mobileNumber}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Height: ${member.height} cm', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Weight: ${member.weight} kg', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Address: ${member.address}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Gender: ${member.gender}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Renewal Date: ${DateFormat('dd-MM-yyyy').format(member.renewalDate)}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
