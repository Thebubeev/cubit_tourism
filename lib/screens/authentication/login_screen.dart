import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/bloc/cubit_bloc.dart';
import 'package:test_task/firebase_auth/firebase_auth.dart';
import 'package:test_task/screens/authentication/forget_screen.dart';
import 'package:test_task/screens/wrapper_screen.dart';
import 'package:test_task/widgets/widgets.dart';

import '../../widgets/loader_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth auth = Auth();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  String? _warning;
  bool _isLoading = false;

  @override
  void dispose() {
    if (!mounted) return;
    _emailController.dispose();
    _passController.dispose();
    _warning = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CubitBloc, CubitState>(
      listener: (context, state) async {
        if (state is CubitNavigatorState) {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => WrapperScreen()));
        }

        if (state is CubitLoginToastState) {
          setState(() {
            _isLoading = false;
            _warning = 'Пожалуйста, подтвердите вашу почту.';
          });
          try {
            await auth.sendVerificationEmail();
          } catch (e) {
            print(e);
          }
        }

        if (state is CubitErrorState) {
          if (state.warning ==
              '[firebase_auth/unknown] Given String is empty or null') {
            setState(() {
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
              _warning = state.warning;
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const LoaderWidget()
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.all(30),
                      children: [
                        iconBackButton(context),
                        ShowAlert(
                          warning: _warning,
                          function: () {
                            setState(() {
                              _warning = null;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'Войти',
                          style: TextStyle(
                              fontSize: 70,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormEmailField(emailController: _emailController),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormPassField(passController: _passController),
                        const SizedBox(
                          height: 30,
                        ),
                        enterButton(
                          _formKey,
                          _submitForm,
                          'Войти',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLoading = true;
                              });
                              BlocProvider.of<CubitBloc>(context)
                                  .add(CubitLoginWithGoogleEvent());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  color: Colors.white),
                              height: 70,
                              width: 300,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    const Text(
                                      'Войти с помощью Google',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Gilroy',
                                          fontSize: 17),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset(
                                      'assets/google.png',
                                      fit: BoxFit.cover,
                                      height: 30,
                                      width: 30,
                                    )
                                  ],
                                ),
                              )),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ForgetScreen()));
                            },
                            child: const Text(
                              'Восстановить пароль',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void _submitForm() async {
    setState(() => _isLoading = true);
    BlocProvider.of<CubitBloc>(context).add(CubitLoginEvent(
        login: _emailController.text.trim(),
        password: _passController.text.trim()));
  }
}
