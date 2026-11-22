import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class KeyButton extends StatelessWidget {
  const KeyButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.child,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        shape: AppTheme.keyShape,
        child: InkWell(
          customBorder: AppTheme.keyShape,
          onTap: onPressed,
          child: Center(child: child),
        ),
      ),
    );
  }
}
