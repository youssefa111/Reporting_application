import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/authentication_cubit/cubit/authentication_cubit.dart';
import '../../helper/constants/constants.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "E-mail",
                        labelStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(),
                      ),
                      validator: (valid) {
                        if (valid!.isEmpty) {
                          return 'Please Enter your E-mail';
                        } else if (!valid.contains("@")) {
                          return "Please Enter a right form for email";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(),
                      ),
                      validator: (valid) {
                        if (valid!.isEmpty) {
                          return 'Please Enter your password';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    builder: (context, state) {
                      return ConditionalBuilder(
                        condition: state is! LoginLoading,
                        builder: (context) => myTextButton(
                          text: 'Login',
                          context: context,
                          function: () {
                            if (formKey.currentState!.validate()) {
                              AuthenticationCubit.get(context).loginFun(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  context: context);
                            }
                          },
                        ),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        'Forgot Password ?',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => RegisterScreen(),
                        ),
                      ),
                      child: Text(
                        'Don\'t have an Account or SignUp ?',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
