import 'package:arjunagym/Resources/FirebaseResources.dart';
import 'package:arjunagym/Provider/MemberProvider.dart';
import 'package:arjunagym/Provider/GymPlanProvider.dart';
import 'package:arjunagym/Provider/UserProvider.dart';
import 'package:arjunagym/Screens/EditScreens/AddGymPlanPage.dart';
import 'package:arjunagym/Screens/EditScreens/AddMemberPage.dart';
import 'package:arjunagym/Screens/CustomBottomNavigationBar.dart';
import 'package:arjunagym/Screens/DisplayScreens/GymPlansPage.dart';
import 'package:arjunagym/Screens/DashBoard.dart';
import 'package:arjunagym/Screens/InvoicesScreens/ViewInvoicePage.dart';
import 'package:arjunagym/Screens/SplashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthMethods authMethods = AuthMethods();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GymPlanProvider()..fetchPlans()),
        ChangeNotifierProvider(create: (context) => MemberProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Gym Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasData) {
              return SplashScreen();
            } else {
              return  Authenticate();
            }
          },
        ),
        routes: {
          '/home': (context) => CustomBottomNavigationBar(),
          '/add-plan': (context) => AddGymPlanPage(),
          '/add-member': (context) => AddMemberPage(),
          '/gym-plans' : (context) => GymPlansPage()
        },
      ),
    );
  }
}

