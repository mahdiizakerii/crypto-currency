import 'package:flutter/material.dart';

class BiometricSwitch extends StatelessWidget {
  const BiometricSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Biometrics ${value ? 'on' : 'off'}',
      toggled: value,
      child: Switch(
        key: const ValueKey('biometric-switch'),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
