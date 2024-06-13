import 'package:arjunagym/Screens/EditScreens/AddMemberPage.dart';
import 'package:arjunagym/Screens/DisplayScreens/DisplayAllMembers.dart';
import 'package:arjunagym/Screens/DisplayScreens/GymPlansPage.dart';
import 'package:arjunagym/Screens/DashBoard.dart';
import 'package:arjunagym/Screens/MenuPage.dart';
import 'package:arjunagym/Screens/ProfilePage.dart';
import 'package:arjunagym/Screens/DisplayScreens/RecycleBinPage.dart';
import 'package:arjunagym/Screens/SearchScreen.dart';
import 'package:arjunagym/Widgets/UniversalVariables.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int page = 2;
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey(); // The GlobalKey class is commonly used in Flutter to provide access to the state of a widget from outside of the widget itself.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      bottomNavigationBar: CurvedNavigationBar(
        key: bottomNavigationKey,
        index: 2,
        items: const [
          Icon(Icons.menu),
          Icon(Icons.person_add),
          Icon(Icons.dashboard),
          FaIcon(FontAwesomeIcons.addressCard),
          Icon(Icons.person)
        ],
        height: 60,
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: UniversalVariables.appThemeColor,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: getPage(page),
    );
  }
}

getPage(int page) {
  switch (page) {
    case 0:
      return GymPlansPage();
    case 1:
      return AddMemberPage();
    case 2:
      return DashBoard();
    case 3:
      return DisplayAllMembers();
    case 4:
      return MenuPage();
  }
}
