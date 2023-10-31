import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mattbarber_app/components/my_button.dart';
import 'package:mattbarber_app/components/my_textfield.dart';
import 'package:mattbarber_app/components/square_tile.dart';
import 'package:mattbarber_app/main.dart';
import 'package:mattbarber_app/pages/auth_page.dart';
import 'package:mattbarber_app/pages/test_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  // sign user up  method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Check password is the same as the confirm password
      if (passwordController.text == confirmPasswordController.text) {
        // Create the user with email and password
        final authResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Get the current user
        final user = authResult.user;

        // Add additional data to the "Account" table
        await FirebaseFirestore.instance
            .collection('Account')
            .doc(user!.uid)
            .set({
          'role': 'customer',
          'isEmployed': false,
        });
      } else {
        // Show error message
        showErrorMessage("Password doesn't match!");
      }

      // Pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Pop loading circle
      Navigator.pop(context);
      // Show error message
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String Message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Center(
              child: Text(
                Message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 30),

            //logo
            const Icon(
              Icons.lock,
              size: 50,
            ),

            const SizedBox(height: 50),

            Text(
              'Let\'s Create An Account For You',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            const SizedBox(height: 25),
            //email textfield
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(height: 15),

            //password text textfield
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 10),

            //cconfirm password text textfield
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),

            const SizedBox(height: 25),

            ///sign in button
            MyButton(
              text: "Sign Up",
              onTap: signUserUp,
              /*() async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                          //const
                          TestPage()
                      //MyHomePage(title: "Homepage")
                      ));
                } catch (e) {
                  //ubah sini kalau nak tunjuk invalid login message

                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));

                  print(e);
                }
              }, */
            ),

            const SizedBox(height: 35),

            //continue with
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // google + apple sign in button
            Row(
              //use row because  if want to put picture side by side
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                //google
                SquareTile(
                  imagePath: 'images/google_logo.png',
                ),

                SizedBox(width: 25),

                //apple
                SquareTile(imagePath: 'images/apple_logo.png'),
              ],
            ),

            const SizedBox(height: 30),

            // Donts have An Account? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have An Account?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Login now',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
