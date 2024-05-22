
import 'package:arjunagym/Screens/Allmembers.dart';
import 'package:arjunagym/Screens/MemberListPage.dart';
import 'package:arjunagym/Screens/RecyleScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arjuna Fitness Gym"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/add-plan');
              },
              child: Text('Add New Plan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/add-member');
              },
              child: Text('Add New Member'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemberListPage()),
                );
              },
              child: Text("Members List"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllMembersPage()),
                );
              },
              child: Text('View All Members'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecycleBinPage()),
                );
              },
              child: Text('Recycle Members'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => MemberListPage()),
            //     );
            //   },
            //   child: Text("Active Members"),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => MemberListPage()),
            //     );
            //   },
            //   child: Text("Expired Members"),
            // ),
          ],
        ),
      ),
    );
  }
}
