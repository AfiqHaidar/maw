import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String textButton;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.onPressed,
    required this.textButton,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(105, 40),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        disabledBackgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.6),
        disabledForegroundColor:
            Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
      ),
      child: isLoading
          ? Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const FaIcon(FontAwesomeIcons.cat, size: 8),
              ],
            )
          : Text(textButton),
    );
  }
}
