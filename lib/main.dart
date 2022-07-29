import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pgi_mobile/screens/SignIn/signin.dart';

void main() async {
  runApp(const PgiMobile());
}

class PgiMobile extends StatelessWidget {
  const PgiMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const SignIn(),
      theme: ThemeData(fontFamily: 'DMSans'),
      debugShowCheckedModeBanner: false,
    );
  }
}
