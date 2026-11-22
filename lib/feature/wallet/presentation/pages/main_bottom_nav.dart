import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key, required this.screens});

  final List<Widget> screens;

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_controller.index != 0) {
      setState(() {
        _controller.index = 0;
      });
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: widget.screens,
        items: [
          _navigationItem(Icons.account_balance_wallet_outlined, 'Wallet'),
          _navigationItem(Icons.show_chart_rounded, 'Chart'),
          _navigationItem(Icons.article_outlined, 'News'),
          _navigationItem(Icons.diamond_outlined, 'Collectibles'),
        ],
        backgroundColor: AppTheme.surface,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: false,
        confineToSafeArea: true,
        navBarHeight: 68,
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }

  PersistentBottomNavBarItem _navigationItem(IconData icon, String title) {
    return PersistentBottomNavBarItem(
      icon: Icon(icon),
      title: title,
      activeColorPrimary: AppTheme.primary,
      inactiveColorPrimary: AppTheme.textSecondary,
    );
  }
}
