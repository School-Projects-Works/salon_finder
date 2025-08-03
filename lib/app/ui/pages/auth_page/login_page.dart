import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_button.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_input.dart';
import 'package:salon_finder/app/ui/theme/text_styles.dart';
import 'package:salon_finder/app/ui/utils/email_validation.dart';
import 'package:salon_finder/generated/assets.dart';

import '../../../provider/login_provider.dart';
import 'sign_up_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(Assets.imagesIconBlack, height: 100, width: 100),

                  Text(
                    'Welcome Back,',
                    style: AppTextStyles.title(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Your Style, Just a Tap Away.',
                    style: AppTextStyles.body(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFields(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    initialValue: 'teck.koda@gmail.com',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (validateEmail(value) == false) {
                        return 'Please enter a valid email address';
                      }
                      // Add more validation if needed
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        ref.read(loginProvider.notifier).setEmail(value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFields(
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: obscurePassword,
                    initialValue: '123456',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Add more validation if needed
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        ref.read(loginProvider.notifier).setPassword(value);
                      }
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  //forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password page
                        // Navigator.pushNamed(context, '/forgot-password');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.body(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        ref
                            .read(loginProvider.notifier)
                            .login(context: context);
                      }
                    },
                    radius: 5,
                  ),
                  const SizedBox(height: 10),
                  //already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: AppTextStyles.body(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.body(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Add your login form here
                  // For example, TextFormField for email and password
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
