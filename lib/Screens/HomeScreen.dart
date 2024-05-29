
import 'package:arjunagym/Provider/FirebaseResources.dart';
import 'package:arjunagym/Provider/MembersProvider.dart';
import 'package:arjunagym/Provider/PlanProvider.dart';
import 'package:arjunagym/Screens/Displayall.dart';
import 'package:arjunagym/Screens/MemberCard.dart';
import 'package:arjunagym/Screens/MemberListPage.dart';
import 'package:arjunagym/Screens/RecyleScreen.dart';
import 'package:arjunagym/Screens/ScaleUtils.dart';
import 'package:arjunagym/Screens/UniversalVariables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void initState() {
    super.initState();
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    final gymPlanProvider = Provider.of<GymPlanProvider>(context, listen: false);
    memberProvider.getAllMembers();
    gymPlanProvider.fetchPlans(); // Fetch plans
    memberProvider.fetchActiveMembers();
    memberProvider.fetchExpiredMembers();
  }
  @override
  Widget build(BuildContext context) {
    ScaleUtils.init(context);
    final memberProvider = Provider.of<MemberProvider>(context);
    final gymPlanProvider = Provider.of<GymPlanProvider>(context);
    final members = memberProvider.members;
    final plans = gymPlanProvider.plans;
    // final active = memberProvider.fetchActiveMembers();
    final activemembers = memberProvider.activeMembers;
    final expiredmembers = memberProvider.expiredMembers;
    AuthMethods authMethods = AuthMethods();
    ScaleUtils.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Arjuna Fitness Gym",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 10,
        actions: [
          // IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> III()));}, icon: Icon(Icons.add))
        ],
      ),
      body: Stack(
        children: [
          Image.asset('assets/home3.jpg',height: ScaleUtils.height,width: ScaleUtils.width,fit: BoxFit.cover,),
        ListView(
          children: [
            SizedBox(height: 220*ScaleUtils.verticalScale,),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20,10,10,10),
                      child: InkWell(
                        onTap: (){
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => MemberListPage()),
                               );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: HexColor('FD8024'),
                            borderRadius: BorderRadius.circular(20),
                            // boxShadow:  [
                            //   BoxShadow(
                            //     color:Colors.white,
                            //     offset: const Offset(0.0, 0.0),
                            //     blurRadius: 4.0,
                            //     spreadRadius: 3.0,
                            //   ),
                            // ],
                          ),
                          height: 150*ScaleUtils.verticalScale,
                          width: 150*ScaleUtils.horizontalScale,
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Total Members',style: TextStyle(color: Colors.white,fontSize: 16),),
                              Text('${members.length}',style: TextStyle(fontSize: 40,color: Colors.white),),
                            ],
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20,10,10,10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: HexColor('007FFF'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 150*ScaleUtils.verticalScale,
                        width: 150*ScaleUtils.horizontalScale,
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Gym Plans',style: TextStyle(color: Colors.white,fontSize: 16),),
                            Text('${plans.length}',style: TextStyle(fontSize: 40,color: Colors.white),),
                          ],
                        )),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20,10,10,10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: HexColor('2BC155'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 150*ScaleUtils.verticalScale,
                        width: 150*ScaleUtils.horizontalScale,
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Active Members',style: TextStyle(color: Colors.white,fontSize: 16),),
                            Text('${activemembers.length}',style: TextStyle(fontSize: 40,color: Colors.white),),
                          ],
                        )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20,10,10,10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: HexColor('FF0000'),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 150*ScaleUtils.verticalScale,
                        width: 150*ScaleUtils.horizontalScale,
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Expired Members',style: TextStyle(color: Colors.white,fontSize: 16),),
                            Text('${expiredmembers.length}',style: TextStyle(fontSize: 40,color: Colors.white),),
                          ],
                        )),
                      ),
                    )
                  ],
                ),
              ],
            ),

           //  ElevatedButton(
           //    onPressed: () {
           //      Navigator.of(context).pushNamed('/add-plan');
           //    },
           //    child: Text('Add New Plan'),
           //  ),
           //  ElevatedButton(
           //    onPressed: () {
           //      Navigator.of(context).pushNamed('/add-member');
           //    },
           //    child: Text('Add New Member'),
           //  ),
           // //SizedBox(height: 100,),
           //  ElevatedButton(
           //    onPressed: () {
           //      Navigator.push(
           //        context,
           //        MaterialPageRoute(builder: (context) => MemberListPage()),
           //      );
           //    },
           //    child: Text("Members List"),
           //  ),
           //  ElevatedButton(
           //    onPressed: () {
           //      Navigator.push(
           //        context,
           //        MaterialPageRoute(builder: (context) => RecycleBinPage()),
           //      );
           //    },
           //    child: Text('Recycle Members'),
           //  ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayallMembers()),
                );
              },
              child: Text("Display all Members"),
            ),
           //  InkWell(
           //    onTap: () {
           //      authMethods.logOut(context);
           //      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return NewLoginScreen();}));
           //      showToast("Account Logging Out....", backgroundColor: Colors.red, context: context);
           //    },
           //    child: Container(
           //      decoration: BoxDecoration(
           //        borderRadius: BorderRadius.circular(20*ScaleUtils.scaleFactor),
           //        color: Colors.red,
           //      ),
           //      child: Padding(
           //        padding:  EdgeInsets.all(12.0*ScaleUtils.scaleFactor),
           //        child:  Row(
           //          mainAxisAlignment: MainAxisAlignment.center,
           //          mainAxisSize: MainAxisSize.min,
           //          children:  [
           //            Text(
           //              "Logout",
           //              style: TextStyle(fontSize:16*ScaleUtils.scaleFactor,color: Colors.white),
           //            ),
           //            SizedBox(width: 8*ScaleUtils.horizontalScale,),
           //            Icon(Icons.logout,color: Colors.white,)
           //          ],
           //        ),
           //      ),
           //    ),
           //  ),
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
      ]
      ),
    );
  }
}
