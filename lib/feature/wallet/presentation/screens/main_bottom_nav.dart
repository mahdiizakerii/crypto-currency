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
      _controller.jumpToTab(0);
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
      child: PersistentTabView.custom(
        context,
        controller: _controller,
        screens: widget.screens
            .map((screen) => CustomNavBarScreen(screen: screen))
            .toList(),
        itemCount: _navigationItems.length,
        customWidget: _CompactBottomNavBar(
          controller: _controller,
          items: _navigationItems,
        ),
        backgroundColor: AppTheme.surface,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: false,
        confineToSafeArea: true,
        navBarHeight: 76,
      ),
    );
  }
}

const _navigationItems = [
  _MainNavItem(Icons.account_balance_wallet_outlined, 'Wallet'),
  _MainNavItem(Icons.show_chart_rounded, 'Chart'),
  _MainNavItem(Icons.article_outlined, 'News'),
  _MainNavItem(Icons.diamond_outlined, 'Collectibles'),
];

class _MainNavItem {
  const _MainNavItem(this.icon, this.title);

  final IconData icon;
  final String title;
}

class _CompactBottomNavBar extends StatelessWidget {
  const _CompactBottomNavBar({required this.controller, required this.items});

  final PersistentTabController controller;
  final List<_MainNavItem> items;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Material(
          color: AppTheme.surface,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                for (var index = 0; index < items.length; index++)
                  Expanded(child: _buildItem(items[index], index)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(_MainNavItem item, int index) {
    final isSelected = controller.index == index;
    final color = isSelected ? AppTheme.primary : AppTheme.textSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.title,
      child: InkWell(
        onTap: () => controller.jumpToTab(index),
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 22, color: color),
              const SizedBox(height: 4),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
