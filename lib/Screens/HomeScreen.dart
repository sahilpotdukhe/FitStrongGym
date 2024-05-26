import 'package:arjunagym/Provider/FirebaseResources.dart';
import 'package:arjunagym/Screens/Displayall.dart';
import 'package:arjunagym/Screens/MemberListPage.dart';
import 'package:arjunagym/Screens/RecyleScreen.dart';
import 'package:arjunagym/Screens/ScaleUtils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    AuthMethods authMethods = AuthMethods();
    ScaleUtils.init(context);
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
            SizedBox(height: 100,),
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
                  MaterialPageRoute(builder: (context) => RecycleBinPage()),
                );
              },
              child: Text('Recycle Members'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayallMembers()),
                );
              },
              child: Text("Display all Members"),
            ),
            InkWell(
              onTap: () {
                authMethods.logOut(context);
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return NewLoginScreen();}));
                showToast("Account Logging Out....", backgroundColor: Colors.red, context: context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20*ScaleUtils.scaleFactor),
                  color: Colors.red,
                ),
                child: Padding(
                  padding:  EdgeInsets.all(12.0*ScaleUtils.scaleFactor),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      Text(
                        "Logout",
                        style: TextStyle(fontSize:16*ScaleUtils.scaleFactor,color: Colors.white),
                      ),
                      SizedBox(width: 8*ScaleUtils.horizontalScale,),
                      Icon(Icons.logout,color: Colors.white,)
                    ],
                  ),
                ),
              ),
            ),
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
