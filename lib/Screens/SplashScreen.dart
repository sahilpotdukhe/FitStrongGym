import 'package:arjunagym/Models/UserModel.dart';
import 'package:arjunagym/Provider/UserProvider.dart';
import 'package:arjunagym/Screens/CustomBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUser();
    Future.delayed(Duration(seconds: 5),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>CustomBottomNavigationBar()));
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserModel? userModel = userProvider.getUser;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            (userModel != null)
                ? Image.network(
                    userModel.profilePhoto,
                    height: 250,
                    width: 250,
                  )
                : Image.asset(
                    'assets/splashlogo.jpg',
                    height: 250,
                    width: 250,
                  ),
            Lottie.asset(
              'assets/splashweight.json',
            ),
            Spacer(),
            Image.asset(
              'assets/developer.png',
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
