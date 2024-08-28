import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/custom_text_form_filed.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/provider/auth_user_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController(text: 'fahd');

  TextEditingController emailController =
      TextEditingController(text: 'fahd@route.com');

  TextEditingController passwordController =
      TextEditingController(text: '222222');

  TextEditingController confirmPasswordController =
      TextEditingController(text: '222222');

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
            title: Text("Create Account"),
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
                  CustomTextFormFiled(
                    label: 'User Name',
                    controller: nameController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter User Name';
                      }
                      return null;
                    },
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
                  CustomTextFormFiled(
                    label: 'Confirm Password',
                    controller: confirmPasswordController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Confirm Password';
                      }
                      if (text != passwordController.text) {
                        return 'Confirm Password not match password';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          register();
                        },
                        child: Text('CreateAccount')),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context: context, message: 'Loading....');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text);
        var authProvider =
            Provider.of<AuthUserProvider>(context, listen: false);
        authProvider.updateUser(myUser);

        await FireBaseUtils.addUserToFireStore(myUser);

        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context: context,
            message: "Register Scucessfully",
            title: 'success',
            posActionName: 'OK',
            posAction: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context: context,
              message: "The password provided is too weak",
              title: 'Error',
              posActionName: 'OK');
        } else if (e.code == 'network-request-failed') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context: context,
              message:
                  "A network error (such as timeout,interrupted connection or unreachable host)has occurred",
              title: 'Error',
              posActionName: 'OK');
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
