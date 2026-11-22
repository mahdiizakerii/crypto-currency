import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';

class WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WalletAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 52,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.background,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 18,
                  color: AppTheme.textPrimary,
                ),
                SizedBox(width: 8),
                Text(
                  'Wallet',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 3),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
          const Spacer(),
          const _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            label: 'Notifications',
          ),
          const SizedBox(width: 10),
          const _HeaderIconButton(icon: Icons.apps_rounded, label: 'More'),
        ],
      ),
      actions: const [SizedBox(width: 20)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52);
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: () {},
      style: IconButton.styleFrom(
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.textPrimary,
        fixedSize: const Size(40, 40),
      ),
      icon: Icon(icon, size: 20),
    );
  }
}
