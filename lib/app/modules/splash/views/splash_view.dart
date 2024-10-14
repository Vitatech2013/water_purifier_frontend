import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_purifier/app/core/app_config/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
{
  String? userName;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userEmail = prefs.getString('userEmail');

    if (userEmail != null && userEmail.contains('@')) {
      userName = userEmail.split('@')[0];
    }

    setState(() {});
    Future.delayed(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
            children: <Widget>[
              Image.asset(AppAssets.logoGif,height: height/2,),
              userName != null
                  ? Positioned(
                top: width/7,
                left: width/5,
                child:Column(
                  children: [
                    Text(
                      'Hi, Welcome Back!',
                      style: TextStyle(
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800]),
                    ),
                    Text(
                      userName!,
                      style: TextStyle(
                        fontSize: width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              )
                  : const LimitedBox(),
            ],
          ),
        ),
    );
  }
}
