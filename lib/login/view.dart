import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refresh_network/route.dart';

import 'logic.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final logic = Get.put(LoginLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Text('Login Page'),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.home);
              },
              child: Text('Go to Home List'),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.home);
                },
                child: Text('Go to Home List'),
              ),
            ),
            Text('Login Page'),
            Text('Login Page'),
            Text('Login Page'),
            Text('Login Page'),
          ],
        ),
      )

    );
  }
}
