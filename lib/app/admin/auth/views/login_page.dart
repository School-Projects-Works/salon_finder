import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import '../../../../generated/assets.dart';
import '../../../ui/global_widgets/custom_button.dart';
import '../../../ui/global_widgets/custom_input.dart';
import '../../core/custom_dialog.dart';
import '../../core/styles.dart';
import '../../router/router.dart';
import '../../router/router_items.dart';


class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            style.isMobile
                ? _buildForm()
                : Container(
                    width:
                        style.isDesktop ? style.width * .6 : style.width * .7,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      children: [
                        Container(
                          height: 450,
                          width: style.width * .3,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Image.asset(
                            Assets.imagesLogoBlack,
                          ),
                        ),
                        Expanded(child: _buildForm())
                      ],
                    ),
                  ),
          ],
        )),
      ),
    );
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget _buildForm() {
    var style = Styles(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (style.isMobile)
              Image.asset(
                Assets.imagesIconBlack,
                width: 200,
                height: 200,
              ),
            if (style.isMobile) const SizedBox(height: 12),
            Text('ADMIN LOGIN',
                style: style.title(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: style.isDesktop
                        ? 35
                        : style.isTablet
                            ? 30
                            : 20)),
            const Divider(
              height: 22,
              thickness: 3,
            ),
            const SizedBox(height: 15),
            CustomTextFields(
              label: 'Username',
              prefixIcon: Icons.person,
              hintText: 'Enter your username',
              controller: _emailController,
            ),
            const SizedBox(height: 22),
            CustomTextFields(
              label: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock,
              controller: _passwordController,
              obscureText: _isObscure,
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
            const SizedBox(height: 22),
            CustomButton(
                text: 'Login',
                onPressed: () {
                  login();
                }),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }

  void login() {
    var name = _emailController.text;
    var password = _passwordController.text;
    CustomAdminDialog.showLoading(message: 'Login in .....');
    // delay for 5 seconds
    

    if (name.toLowerCase() == 'admin' && password == '123456') {
      CustomAdminDialog.dismiss();
      MyRouter(context: context, ref: ref)
          .navigateToRoute(RouterItem.dashboardRoute);
    } else {
      CustomAdminDialog.dismiss();
      CustomAdminDialog.showToast(message: 'Invalid admin name or password');
    }
  }
}
