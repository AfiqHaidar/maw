import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/core/handlers/error_handler.dart';
import 'package:mb/core/mappers/auth_error_mapper.dart';
import 'package:mb/core/mappers/firestore_error_mapper.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/core/utils/validators/auth_validator.dart';
import 'package:mb/data/models/user_model.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/features/auth/controller/auth_animation_controller.dart';
import 'package:mb/features/auth/widgets/auth_text_field.dart';
import 'package:mb/features/auth/widgets/auth_button.dart';
import 'package:mb/features/auth/widgets/password_visibility_toggle.dart';
import 'package:mb/features/auth/widgets/profile_picture_picker.dart';
import 'package:mb/features/auth/widgets/username_info_icon.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AuthAnimatedOpacityController _anim;

  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredName = '';
  var _enteredUsername = '';
  var _selectedProfilePictureAsset = 'assets/animations/hanging_cat.json';
  bool _obscureTextPassword = true;
  // bool _obscureTextPasswordConfirmed = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final userCredential = await ref
            .read(authProvider.notifier)
            .register(_enteredEmail, _enteredPassword);

        final firebaseUser = userCredential.user;
        if (firebaseUser == null) {
          throw FirebaseAuthException(
            code: 'unknown',
            message: 'Registration failed. User could not be created.',
          );
        }

        final newUser = UserModel(
          id: firebaseUser.uid,
          email: _enteredEmail,
          name: _enteredName,
          username: _enteredUsername,
          profilePicture: _selectedProfilePictureAsset,
        );

        await ref.read(userProvider.notifier).upsertUser(newUser);
      } on FirebaseAuthException catch (e) {
        ErrorHandler.showError(
          context,
          AuthErrorMapper.map(e),
          useDialog: false,
        );
      } on FirebaseException catch (e) {
        ErrorHandler.showError(
          context,
          FirestoreErrorMapper.map(e),
          useDialog: false,
        );
      } catch (e) {
        print(e);
        ErrorHandler.showError(
          context,
          "An unexpected error occurred.",
        );
      } finally {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
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
    final isAuthLoading = ref.watch(authProvider);
    final usernamesAsync = ref.watch(usernamesStreamProvider);
    final isLoading = isAuthLoading ||
        usernamesAsync.isLoading ||
        usernamesAsync.maybeWhen(
            data: (list) => list.isEmpty, orElse: () => true);

    final color = Theme.of(context).colorScheme;
    print(usernamesAsync);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.white,
      ),
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
                                    ProfilePicturePicker(
                                      onChanged: (selectedAsset) {
                                        setState(() {
                                          _selectedProfilePictureAsset =
                                              selectedAsset;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 50),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          AuthTextField(
                                            label: "Username",
                                            validator: (value) {
                                              final usernames =
                                                  usernamesAsync.maybeWhen(
                                                data: (list) => list.toSet(),
                                                orElse: () => <String>{},
                                              );
                                              return AuthValidator
                                                  .validateUsername(
                                                      value, usernames);
                                            },
                                            onSaved: (value) =>
                                                _enteredUsername = value!,
                                            prefixIcon: const Icon(
                                              Icons.alternate_email,
                                              color: AppColors.white70,
                                            ),
                                            suffixIcon:
                                                const UsernameInfoIcon(),
                                            textInputType: TextInputType.name,
                                          ),
                                          AuthTextField(
                                            label: "Name",
                                            validator:
                                                AuthValidator.validateName,
                                            onSaved: (value) =>
                                                _enteredName = value!,
                                            prefixIcon: const Icon(
                                              Icons.person,
                                              color: AppColors.white70,
                                            ),
                                            textInputType: TextInputType.name,
                                          ),
                                          AuthTextField(
                                            label: "Email",
                                            validator:
                                                AuthValidator.validateEmail,
                                            onSaved: (value) =>
                                                _enteredEmail = value!,
                                            prefixIcon: const Icon(
                                              Icons.email,
                                              color: AppColors.white70,
                                            ),
                                            textInputType:
                                                TextInputType.emailAddress,
                                          ),
                                          AuthTextField(
                                            label: "Password",
                                            obscureText: _obscureTextPassword,
                                            validator:
                                                AuthValidator.validatePassword,
                                            onSaved: (value) =>
                                                _enteredPassword = value!,
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                              color: AppColors.white70,
                                            ),
                                            suffixIcon:
                                                PasswordVisibilityToggle(
                                              isVisible: _obscureTextPassword,
                                              onToggle: () => setState(() {
                                                _obscureTextPassword =
                                                    !_obscureTextPassword;
                                              }),
                                            ),
                                            textInputType:
                                                TextInputType.visiblePassword,
                                          ),
                                          // AuthTextField(
                                          //   label: "Confirm Password",
                                          //   obscureText:
                                          //       _obscureTextPasswordConfirmed,
                                          //   validator: (value) => AuthValidator
                                          //       .validateConfirmedPassword(
                                          //           value, _enteredPassword),
                                          //   onSaved: (value) => () {},
                                          //   prefixIcon: const Icon(
                                          //     Icons.lock_outline,
                                          //     color: AppColors.white70,
                                          //   ),
                                          //   suffixIcon:
                                          //       PasswordVisibilityToggle(
                                          //     isVisible:
                                          //         _obscureTextPasswordConfirmed,
                                          //     onToggle: () => setState(() {
                                          //       _obscureTextPasswordConfirmed =
                                          //           !_obscureTextPasswordConfirmed;
                                          //     }),
                                          //   ),
                                          //   textInputType: TextInputType.text,
                                          // ),
                                          const SizedBox(height: 50),
                                          AuthButton(
                                            isLoading: isLoading,
                                            onPressed: _submit,
                                            text: "Register",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        },
      ),
    );
  }
}
