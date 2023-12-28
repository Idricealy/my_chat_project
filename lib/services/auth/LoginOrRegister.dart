import 'package:flutter/material.dart';
import 'package:my_chat_project/pages/login_page.dart';
import 'package:my_chat_project/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginOrRegisterState();
  }
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  
  //toogle between login and register page
  void tooglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(onTap: tooglePages);
    }
    else {
      return RegisterPage(onTap: tooglePages);
    }
  }

}