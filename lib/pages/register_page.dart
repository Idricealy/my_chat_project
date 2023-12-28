import 'package:flutter/material.dart';
import 'package:my_chat_project/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {

  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPaswwordController = TextEditingController();

  void signUp() async{
   if(passwordController.text != confirmPaswwordController.text) {
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
           content: Text("Password do not match !")
       ),
     );
     return;
   }
   final authService = Provider.of<AuthService>(context, listen: false);

   try {
     await authService.signUpWithEmailAndPassword(emailController.text, passwordController.text);

   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
   }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //create account message
                const Text(
                  "Let's create an account !",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                //email texfield
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false
                ),

                const SizedBox(height: 10),

                //password texfield

                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true
                ),

                const SizedBox(height: 10),

                MyTextField(
                    controller:confirmPaswwordController,
                    hintText: 'Confirm Password',
                    obscureText: true
                ),

                const SizedBox(height: 25),

                //sign in button
                MyButton(onTap: signUp, text: "Sign Up"),

                const SizedBox(height: 25),

                //not a member ? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member ?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Log now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),

          ),
        ),
      ),
    );
  }
}