import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/core/handlers/error_handler.dart';
import 'package:mb/core/utils/validators/auth_validator.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/features/auth/widgets/auth_button.dart';
import 'package:mb/features/auth/widgets/auth_text_field.dart';
import 'package:mb/features/auth/widgets/password_visibility_toggle.dart';

class AuthScreen extends ConsumerStatefulWidget {
  AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _Auth2ScreenState();
}

class _Auth2ScreenState extends ConsumerState<AuthScreen> {
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
      } catch (error) {
        ErrorHandler.showError(context, error.toString(), useDialog: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Lottie.asset(
                  'assets/animations/stare_cat.json',
                  fit: BoxFit.contain,
                ),
              ),
              Stack(children: [
                Card(
                  margin:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthTextField(
                            label: "Email",
                            validator: AuthValidator.validateEmail,
                            onSaved: (value) => _enteredEmail = value!,
                            prefixIcon: const Icon(Icons.email),
                          ),
                          AuthTextField(
                            label: "Password",
                            obscureText: _obscureText,
                            validator: AuthValidator.validatePassword,
                            onSaved: (value) => _enteredPassword = value!,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: PasswordVisibilityToggle(
                              isVisible: _obscureText,
                              onToggle: () => setState(() {
                                _obscureText = !_obscureText;
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              AuthButton(
                  onPressed: _submit,
                  textButton: "Login",
                  isLoading: isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
