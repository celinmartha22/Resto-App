import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resto_app/common/styles.dart';
import 'package:resto_app/ui/home_page.dart';

class SplashScreenPage extends StatelessWidget {
  static const routeName = '/';
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          )),
    );

    return Container(
      color: primaryColor,
      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height/5, 0, MediaQuery.of(context).size.height/5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/chef-hat.png',
                height: MediaQuery.of(context).size.height/4,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Valerie Food",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
