
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';


class AuthPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AuthPage'),
      ),
      body: SafeArea(
        child: Text('AuthController'),
      ),
    );
  }
}
  