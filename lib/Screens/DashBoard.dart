import 'package:arjunagym/Resources/FirebaseResources.dart';
import 'package:arjunagym/Provider/MemberProvider.dart';
import 'package:arjunagym/Provider/GymPlanProvider.dart';
import 'package:arjunagym/Provider/UserProvider.dart';
import 'package:arjunagym/Screens/DisplayScreens/ActiveMembersPage.dart';
import 'package:arjunagym/Screens/EditScreens/AddGymPlanPage.dart';
import 'package:arjunagym/Screens/EditScreens/AddMemberPage.dart';
import 'package:arjunagym/Screens/DisplayScreens/DisplayAllMembers.dart';
import 'package:arjunagym/Screens/DisplayScreens/ExpiredMembersPage.dart';
import 'package:arjunagym/Screens/DisplayScreens/GymPlansPage.dart';
import 'package:arjunagym/Models/InvoiceModel.dart';
import 'package:arjunagym/Widgets/MemberCard.dart';
import 'package:arjunagym/Screens/DisplayScreens/MemberListPage.dart';
import 'package:arjunagym/Screens/MenuPage.dart';
import 'package:arjunagym/Resources/PdfApi.dart';
import 'package:arjunagym/Screens/InvoicesScreens/PdfInvoicePage.dart';
import 'package:arjunagym/Screens/DisplayScreens/RecycleBinPage.dart';
import 'package:arjunagym/Widgets/ScaleUtils.dart';
import 'package:arjunagym/Widgets/UniversalVariables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
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
        title: Text(
          "Arjuna Fitness Gym",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 10,
        leading: IconButton(
          icon: Icon(Icons.nat,color: Colors.white,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuPage()));
          },
        ),
      ),
      body: Stack(children: [
        Image.asset(
          'assets/home3.jpg',
          height: ScaleUtils.height,
          width: ScaleUtils.width,
          fit: BoxFit.cover,
        ),
        ListView(
          children: [
            SizedBox(
              height: 220 * ScaleUtils.verticalScale,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MemberListPage()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: HexColor('FD8024'),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150 * ScaleUtils.verticalScale,
                          width: 150 * ScaleUtils.horizontalScale,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total Members',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                '${members.length}',
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>GymPlansPage()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: HexColor('007FFF'),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150 * ScaleUtils.verticalScale,
                          width: 150 * ScaleUtils.horizontalScale,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Gym Plans',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                '${plans.length}',
                                style:
                                    TextStyle(fontSize: 40, color: Colors.white),
                              ),
                            ],
                          )),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ActiveMembersPage()));
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: HexColor('2BC155'),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150 * ScaleUtils.verticalScale,
                          width: 150 * ScaleUtils.horizontalScale,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Active Members',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                '${activemembers.length}',
                                style:
                                    TextStyle(fontSize: 40, color: Colors.white),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpiredMembersPage()));
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: HexColor('FF0000'),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150 * ScaleUtils.verticalScale,
                          width: 150 * ScaleUtils.horizontalScale,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Expired Members',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                '${expiredmembers.length}',
                                style:
                                    TextStyle(fontSize: 40, color: Colors.white),
                              ),
                            ],
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
