import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: const [
        _WalletDashboardPage(),
        _ComingSoonPage(title: 'Chart'),
        _ComingSoonPage(title: 'News'),
        _ComingSoonPage(title: 'Collectibles'),
      ],
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
      hideNavigationBarWhenKeyboardAppears: true,
      confineToSafeArea: true,
      navBarHeight: AppTheme.navBarHeight,
      navBarStyle: NavBarStyle.style6,
    );
  }

  PersistentBottomNavBarItem _navigationItem(IconData icon, String title) {
    return PersistentBottomNavBarItem(
      icon: Icon(icon, size: AppTheme.navIconSize),
      title: title,
      activeColorPrimary: AppTheme.primary,
      inactiveColorPrimary: AppTheme.textSecondary,
    );
  }
}

class _WalletDashboardPage extends StatefulWidget {
  const _WalletDashboardPage();

  @override
  State<_WalletDashboardPage> createState() => _WalletDashboardPageState();
}

class _WalletDashboardPageState extends State<_WalletDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(FetchWalletData());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppTheme.background,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.surface,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              final status = state.walletStatus;
              final wallet = status is WalletLoaded
                  ? status.walletEntities.data
                  : null;
              final isLoading = status is WalletLoading;
              final errorMessage = status is WalletError
                  ? status.message
                  : null;

              return ListView(
                padding: AppTheme.walletPagePadding,
                children: [
                  const _WalletHeader(),
                  const SizedBox(height: AppTheme.space32),
                  _WalletBalance(wallet: wallet),
                  const SizedBox(height: AppTheme.space26),
                  const _QuickActions(),
                  const SizedBox(height: AppTheme.space28),
                  _SecurityCard(
                    isBiometricEnabled: wallet?.isBiometricEnabled ?? false,
                  ),
                  const SizedBox(height: AppTheme.space28),
                  _AssetsSection(
                    assets: wallet?.assets ?? const [],
                    isLoading: isLoading,
                    errorMessage: errorMessage,
                    onRetry: () {
                      context.read<WalletBloc>().add(FetchWalletData());
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WalletHeader extends StatelessWidget {
  const _WalletHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: AppTheme.walletHeaderPadding,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: AppTheme.walletHeaderRadius,
          ),
          child: const Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: AppTheme.walletHeaderIconSize,
                color: AppTheme.textPrimary,
              ),
              SizedBox(width: AppTheme.space8),
              Text('Wallet', style: AppTheme.walletHeaderTextStyle),
              SizedBox(width: AppTheme.space3),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: AppTheme.walletHeaderIconSize,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
        const Spacer(),
        _HeaderIconButton(
          icon: Icons.notifications_none_rounded,
          label: 'Notifications',
        ),
        const SizedBox(width: AppTheme.space10),
        _HeaderIconButton(icon: Icons.apps_rounded, label: 'More'),
      ],
    );
  }
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
        fixedSize: AppTheme.headerButtonSize,
      ),
      icon: Icon(icon, size: AppTheme.headerButtonIconSize),
    );
  }
}

class _WalletBalance extends StatelessWidget {
  const _WalletBalance({required this.wallet});

  final WalletData? wallet;

  @override
  Widget build(BuildContext context) {
    final address = wallet?.walletAddress;
    final walletType = wallet?.walletType;

    return Column(
      children: [
        Text(
          wallet == null ? '—' : _formatUsd(wallet!.totalBalanceUsd),
          style: AppTheme.balanceTextStyle,
        ),
        const SizedBox(height: AppTheme.space12),
        Container(
          padding: AppTheme.addressPadding,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: AppTheme.addressRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                address == null
                    ? 'Wallet address unavailable'
                    : 'Your address ${_shortAddress(address)}',
                style: AppTheme.addressTextStyle,
              ),
              if (walletType != null && walletType.isNotEmpty) ...[
                const SizedBox(width: AppTheme.space8),
                Container(
                  padding: AppTheme.walletTypePadding,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: AppTheme.walletTypeRadius,
                  ),
                  child: Text(walletType, style: AppTheme.walletTypeTextStyle),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _shortAddress(String address) {
    if (address.length <= 18) {
      return address;
    }
    return '${address.substring(0, 7)}...${address.substring(address.length - 5)}';
  }

  String _formatUsd(num value) {
    final parts = value.toStringAsFixed(2).split('.');
    final whole = parts.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return '\$$whole.${parts.last}';
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _QuickAction(
            key: ValueKey('send-action'),
            icon: Icons.north_east_rounded,
            label: 'Send',
          ),
        ),
        Expanded(
          child: _QuickAction(
            key: ValueKey('receive-action'),
            icon: Icons.south_west_rounded,
            label: 'Receive',
          ),
        ),
        Expanded(
          child: _QuickAction(
            key: ValueKey('scan-action'),
            icon: Icons.qr_code_scanner_rounded,
            label: 'Scan',
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          button: true,
          label: label,
          child: Material(
            color: AppTheme.surface,
            shape: AppTheme.keyShape,
            child: InkWell(
              customBorder: AppTheme.keyShape,
              onTap: () {},
              child: Container(
                width: AppTheme.actionButtonSize,
                height: AppTheme.actionButtonSize,
                decoration: BoxDecoration(
                  shape: AppTheme.circleShape,
                  border: Border.all(color: AppTheme.primaryBorder),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.surfaceRaised, AppTheme.surface],
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.textPrimary,
                  size: AppTheme.actionIconSize,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.space8),
        Text(label, style: AppTheme.actionTextStyle),
      ],
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({required this.isBiometricEnabled});

  final bool isBiometricEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.securityCardPadding,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.actionRadius,
      ),
      child: Column(
        children: [
          _SecurityRow(
            icon: Icons.fingerprint_rounded,
            iconColor: AppTheme.positive,
            iconBackgroundColor: AppTheme.positiveIconBackground,
            title: 'Use biometrics to approve transaction',
            trailing: _StaticSwitch(value: isBiometricEnabled),
          ),
          Divider(height: AppTheme.dividerHeight, color: AppTheme.dividerColor),
          const _SecurityRow(
            icon: Icons.key_rounded,
            iconColor: AppTheme.warning,
            iconBackgroundColor: AppTheme.warningIconBackground,
            title: 'Back up the wallet recovery phrase',
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityRow extends StatelessWidget {
  const _SecurityRow({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppTheme.securityRowPadding,
      child: Row(
        children: [
          Container(
            width: AppTheme.securityIconSize,
            height: AppTheme.securityIconSize,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: AppTheme.circleShape,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: AppTheme.securityIconGlyphSize,
            ),
          ),
          const SizedBox(width: AppTheme.space10),
          Expanded(child: Text(title, style: AppTheme.securityTextStyle)),
          const SizedBox(width: AppTheme.space8),
          trailing,
        ],
      ),
    );
  }
}

class _StaticSwitch extends StatelessWidget {
  const _StaticSwitch({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Biometrics ${value ? 'on' : 'off'}',
      child: Container(
        width: AppTheme.switchWidth,
        height: AppTheme.switchHeight,
        padding: AppTheme.switchPadding,
        decoration: BoxDecoration(
          color: value ? AppTheme.primary : AppTheme.surfaceRaised,
          borderRadius: AppTheme.switchRadius,
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: AppTheme.switchThumbSize,
            height: AppTheme.switchThumbSize,
            decoration: BoxDecoration(
              color: AppTheme.textPrimary,
              shape: AppTheme.circleShape,
            ),
          ),
        ),
      ),
    );
  }
}

class _AssetsSection extends StatelessWidget {
  const _AssetsSection({
    required this.assets,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  final List<Object?> assets;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Assets', style: AppTheme.assetsTitleTextStyle),
        const SizedBox(height: AppTheme.space12),
        if (errorMessage != null)
          _WalletError(message: errorMessage!, onRetry: onRetry)
        else if (isLoading)
          const _LoadingAssets()
        else if (assets.isEmpty)
          const _EmptyAssets()
        else
          for (var index = 0; index < assets.length; index++)
            _AssetTile(index: index, value: assets[index]),
      ],
    );
  }
}

class _LoadingAssets extends StatelessWidget {
  const _LoadingAssets();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppTheme.loadingHeight,
      child: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
    );
  }
}

class _WalletError extends StatelessWidget {
  const _WalletError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.fullWidth,
      padding: AppTheme.errorCardPadding,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.actionRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Could not load wallet',
            style: AppTheme.errorTitleTextStyle,
          ),
          const SizedBox(height: AppTheme.space6),
          Text(message, style: AppTheme.secondaryTextStyle),
          const SizedBox(height: AppTheme.space12),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh_rounded,
              size: AppTheme.errorIconSize,
            ),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _EmptyAssets extends StatelessWidget {
  const _EmptyAssets();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.fullWidth,
      padding: AppTheme.emptyAssetsPadding,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.actionRadius,
      ),
      child: const Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: AppTheme.textSecondary,
            size: AppTheme.emptyIconSize,
          ),
          SizedBox(height: AppTheme.space10),
          Text('Your wallet is empty', style: AppTheme.emptyTitleTextStyle),
          SizedBox(height: AppTheme.space5),
          Text(
            'Your assets will appear here once they are added.',
            textAlign: TextAlign.center,
            style: AppTheme.secondaryTextStyle,
          ),
        ],
      ),
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({required this.index, required this.value});

  final int index;
  final Object? value;

  @override
  Widget build(BuildContext context) {
    final asset = value is Map ? value as Map : const <Object?, Object?>{};
    final title =
        _stringValue(asset['name']) ??
        _stringValue(asset['symbol']) ??
        'Asset ${index + 1}';
    final symbol = _stringValue(asset['symbol']);
    final balance = _stringValue(asset['balance'] ?? asset['amount']);

    return Container(
      margin: AppTheme.assetTileMargin,
      padding: AppTheme.assetTilePadding,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.assetTileRadius,
      ),
      child: Row(
        children: [
          Container(
            width: AppTheme.assetIconSize,
            height: AppTheme.assetIconSize,
            decoration: BoxDecoration(
              color: AppTheme.surfaceRaised,
              shape: AppTheme.circleShape,
            ),
            child: const Icon(
              Icons.token_outlined,
              color: AppTheme.textPrimary,
              size: AppTheme.assetIconGlyphSize,
            ),
          ),
          const SizedBox(width: AppTheme.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.assetTitleTextStyle),
                if (symbol != null)
                  Text(symbol, style: AppTheme.assetSymbolTextStyle),
              ],
            ),
          ),
          if (balance != null)
            Text(balance, style: AppTheme.assetBalanceTextStyle),
        ],
      ),
    );
  }

  String? _stringValue(Object? value) {
    if (value is String || value is num) {
      return value.toString();
    }
    return null;
  }
}

class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$title is coming soon',
          style: AppTheme.comingSoonTextStyle,
        ),
      ),
    );
  }
}
