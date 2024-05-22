import 'package:arjunagym/Provider/MembersProvider.dart';
import 'package:arjunagym/Provider/PlanProvider.dart';
import 'package:arjunagym/Screens/AddGymPlanPage.dart';
import 'package:arjunagym/Screens/AddMemberPage.dart';
import 'package:arjunagym/Screens/HomeScreen.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GymPlanProvider()..fetchPlans()),
        ChangeNotifierProvider(create: (context) => MemberProvider()),
      ],
      child: MaterialApp(
        title: 'Gym Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          '/add-plan': (context) => AddGymPlanPage(),
          '/add-member': (context) => AddMemberPage(),
        },
      ),
    );
  }
}

