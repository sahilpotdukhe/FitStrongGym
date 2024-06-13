import 'package:arjunagym/Models/UserModel.dart';
import 'package:arjunagym/Provider/UserProvider.dart';
import 'package:arjunagym/Screens/EditScreens/AddGymPlanPage.dart';
import 'package:arjunagym/Screens/EditScreens/AddMemberPage.dart';
import 'package:arjunagym/Screens/ProfilePage.dart';
import 'package:arjunagym/Screens/DisplayScreens/RecycleBinPage.dart';
import 'package:arjunagym/Widgets/ScaleUtils.dart';
import 'package:arjunagym/Widgets/UniversalVariables.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUser();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScaleUtils.init(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel? userModel = userProvider.getUser;
    return Scaffold(
      backgroundColor: UniversalVariables.bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Account',
          style: TextStyle(
              color: UniversalVariables.appThemeColor,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: UniversalVariables.bgColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: UniversalVariables.appThemeColor,
          ),
          onPressed: () {},
        ),
      ),
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage()));
                  },
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.grey,
                    child: Container(
                      width: ScaleUtils.width,
                      height: 130,
                      // color: Colors.red,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 40 * ScaleUtils.scaleFactor,
                              child: CircleAvatar(
                                radius: 35 * ScaleUtils.scaleFactor,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage('assets/user.jpg'),
                                foregroundImage:
                                    NetworkImage(userModel!.profilePhoto),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userModel.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20 * ScaleUtils.scaleFactor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  userModel.email,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14 * ScaleUtils.scaleFactor),
                                ),
                                Text(
                                  userModel.phoneNumber,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14 * ScaleUtils.scaleFactor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_forward_ios_sharp),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Card(
                  elevation: 10,
                  shadowColor: Colors.grey,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddGymPlanPage()));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                            child: Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: UniversalVariables.bgColor,
                                    ),
                                    height: 40,
                                    width: 40,
                                    child: Center(child: Icon(Icons.add))),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add Gym Plan',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_sharp)
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMemberPage()));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                            child: Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: UniversalVariables.bgColor,
                                    ),
                                    height: 40,
                                    width: 40,
                                    child: Center(child: Icon(Icons.add))),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add new Member',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_sharp)
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecycleBinPage()));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                            child: Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: UniversalVariables.bgColor,
                                    ),
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                        child: Icon(Icons.delete_forever))),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Recycle Bin',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_sharp)
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final Uri url = Uri.parse(
                                'https://sahilpotdukhe.github.io/Portfolio-website/');
                            try {
                              await launchUrl(url);
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                            child: Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: UniversalVariables.bgColor,
                                    ),
                                    height: 40,
                                    width: 40,
                                    child: Center(child: Icon(Icons.code))),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'About Developer',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_sharp)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
    );
  }
}
