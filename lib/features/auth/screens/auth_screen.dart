import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/core/handlers/error_handler.dart';
import 'package:mb/core/mappers/auth_error_mapper.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/features/auth/validators/auth_validator.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/features/auth/controller/auth_animation_controller.dart';
import 'package:mb/features/auth/screens/register_screen.dart';
import 'package:mb/features/auth/widgets/auth_footer.dart';
import 'package:mb/features/auth/widgets/auth_text_field.dart';
import 'package:mb/features/auth/widgets/auth_button.dart';
import 'package:mb/features/auth/widgets/password_visibility_toggle.dart';

class AuthScreen extends ConsumerStatefulWidget {
  AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AuthAnimatedOpacityController _anim;
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  bool _obscureText = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await ref
            .read(authProvider.notifier)
            .signIn(_enteredEmail, _enteredPassword);
      } on FirebaseAuthException catch (e) {
        ErrorHandler.showError(context, AuthErrorMapper.map(e),
            useDialog: false);
      } catch (e) {
        ErrorHandler.showError(context, "An unexpected error occurred.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _anim = AuthAnimatedOpacityController(vsync: this);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider);
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: AnimatedBuilder(
          animation: _anim.controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.primary.withOpacity(_anim.opacityAnim.value),
                    color.primary.withOpacity(_anim.lowOpacityAnim.value),
                  ],
                ),
              ),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 40),
                                      Image.asset(
                                        'assets/images/logo.png',
                                        width: 150,
                                        height: 150,
                                        color: AppColors.white70,
                                      ),
                                      const SizedBox(height: 50),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            AuthTextField(
                                              label: "Email",
                                              validator:
                                                  AuthValidator.validateEmail,
                                              onSaved: (value) =>
                                                  _enteredEmail = value!,
                                              prefixIcon: const Icon(
                                                  Icons.email,
                                                  color: AppColors.white70),
                                              textInputType:
                                                  TextInputType.emailAddress,
                                            ),
                                            AuthTextField(
                                              label: "Password",
                                              obscureText: _obscureText,
                                              validator: AuthValidator
                                                  .validatePassword,
                                              onSaved: (value) =>
                                                  _enteredPassword = value!,
                                              prefixIcon: const Icon(Icons.lock,
                                                  color: AppColors.white70),
                                              suffixIcon:
                                                  PasswordVisibilityToggle(
                                                isVisible: _obscureText,
                                                onToggle: () => setState(() {
                                                  _obscureText = !_obscureText;
                                                }),
                                              ),
                                              textInputType:
                                                  TextInputType.visiblePassword,
                                            ),
                                            const SizedBox(height: 50),
                                            AuthButton(
                                              isLoading: isLoading,
                                              onPressed: _submit,
                                              text: "Login",
                                            ),
                                            const SizedBox(height: 6),
                                            TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                'Forgot Your Password?',
                                                style: TextStyle(
                                                  color: AppColors.white54,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AuthFooter(
                                onRegister: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
