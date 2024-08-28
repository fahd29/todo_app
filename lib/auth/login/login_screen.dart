import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/custom_text_form_filed.dart';
import 'package:todo_app/auth/register/register_screen.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/provider/auth_user_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController =
      TextEditingController(text: 'fahd@route.com');

  TextEditingController passwordController =
      TextEditingController(text: '112345');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.backgroundLightColor,
          child: Image.asset(
            'assets/images/background_img.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Login"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Welcome Back!",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  CustomTextFormFiled(
                    label: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Email';
                      }
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
                      if (!emailValid) {
                        return 'Please Enter Valid Email.';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormFiled(
                    label: 'Password',
                    controller: passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.phone,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Password';
                      }
                      if (text.length < 6) {
                        return 'Password should be atleast 6 chars.';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: Text('login')),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                      child: Text("Or Create Account"))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context: context, message: 'Loading....');
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        var user = await FireBaseUtils.readUserFromFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          return;
        }
        var authProvider =
            Provider.of<AuthUserProvider>(context, listen: false);
        authProvider.updateUser(user);

        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context: context,
            message: "Login Sucessfully",
            title: 'Sucess',
            posAction: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
            posActionName: 'OK');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context: context,
              title: 'Error',
              posActionName: 'OK',
              message:
                  "The supplied auth credential is incorrect, malformed or has expired'");
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context: context,
            message: e.toString(),
            title: 'Error',
            posActionName: 'OK');
      }
    }
  }
}
