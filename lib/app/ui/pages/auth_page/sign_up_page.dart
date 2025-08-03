import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/ui/pages/auth_page/login_page.dart';
import 'package:salon_finder/app/ui/utils/email_validation.dart';

import '../../../../generated/assets.dart';
import '../../../provider/signup_provider.dart';
import '../../global_widgets/custom_button.dart';
import '../../global_widgets/custom_input.dart';
import '../../theme/text_styles.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
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
                    'Create Your Account,',
                    style: AppTextStyles.title(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Join Us and Discover Your Style.',
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
                    initialValue: 'john@example.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (validateEmail(value) == false) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        ref.read(signUpProvider.notifier).setEmail(value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  //user name
                  CustomTextFields(
                    hintText: 'Username',
                    prefixIcon: Icons.person,
                    initialValue: 'john_doe',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        ref.read(signUpProvider.notifier).setName(value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  //phone number
                  CustomTextFields(
                    hintText: 'Phone Number',
                    prefixIcon: Icons.phone,
                    initialValue: '1234567890',
                    isPhoneInput: true,
                    isDigitOnly: true,
                    max: 10,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length != 10) {
                        return 'Phone number must be exactly 10 digits';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        ref.read(signUpProvider.notifier).setPhoneNumber(value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFields(
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: obscurePassword,
                    initialValue:'123456',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        ref.read(signUpProvider.notifier).setPassword(value);
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
                  const SizedBox(height: 20),

                  CustomButton(
                    text: 'Register',
                    
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ref.read(signUpProvider.notifier).register(context: context);
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
                        'Already have an account?',
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
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
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
