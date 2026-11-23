import 'dart:async';

import 'package:crypto_currency/config/services/biometric_preference_service.dart';
import 'package:crypto_currency/config/services/biometric_service.dart';
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_status.dart';
import 'package:crypto_currency/feature/wallet/presentation/screens/main_bottom_nav.dart';
import 'package:crypto_currency/feature/chart/presentation/screens/chart_page.dart';
import 'package:crypto_currency/feature/news/presentation/screens/news_page.dart';
import 'package:crypto_currency/feature/collectibles/presentation/screens/collectibles_page.dart';
import 'package:crypto_currency/feature/coinlist/domain/entities/market_coin.dart';
import 'package:crypto_currency/feature/coindetail/presentation/screens/coin_detail_page.dart';
import 'package:crypto_currency/feature/login/pressentation/widgets/bottom_sheet_biometric.dart';
import 'package:crypto_currency/feature/wallet/presentation/widgets/biometric_switch.dart';
import 'package:crypto_currency/feature/wallet/presentation/widgets/wallet_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key, this.biometricService});

  final BiometricService? biometricService;

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with WidgetsBindingObserver {
  late final BiometricService _biometricService;
  bool _isAuthenticated = true;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _biometricService = widget.biometricService ?? BiometricService();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      if (_isAuthenticated && !_isAuthenticating) {
        setState(() => _isAuthenticated = false);
      }
    } else if (state == AppLifecycleState.resumed && !_isAuthenticated) {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticated || _isAuthenticating) {
      return;
    }

    setState(() => _isAuthenticating = true);
    final isAuthenticated = await _biometricService.authenticate();
    if (!mounted) {
      return;
    }

    setState(() {
      _isAuthenticating = false;
      _isAuthenticated = isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeSemantics(
          excluding: !_isAuthenticated,
          child: IgnorePointer(
            ignoring: !_isAuthenticated,
            child: const MainBottomNav(
              screens: [
                _WalletDashboardPage(),
                ChartPage(),
                NewsPage(),
                CollectiblesPage(),
              ],
            ),
          ),
        ),
        if (!_isAuthenticated)
          ColoredBox(
            color: AppTheme.background,
            child: Center(
              child: _isAuthenticating
                  ? const CircularProgressIndicator(color: AppTheme.primary)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Wallet locked',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _authenticate,
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Unlock wallet'),
                        ),
                      ],
                    ),
            ),
          ),
      ],
    );
  }
}

class _WalletDashboardPage extends StatefulWidget {
  const _WalletDashboardPage();

  @override
  State<_WalletDashboardPage> createState() => _WalletDashboardPageState();
}

class _WalletDashboardPageState extends State<_WalletDashboardPage> {
  bool _biometricLoginEnabled = false;
  @override
  void initState() {
    super.initState();
    _loadBiometricPreference();
    context.read<WalletBloc>().add(FetchWalletData());
  }

  Future<void> _loadBiometricPreference() async {
    final enabled = await BiometricPreferenceService().isEnabled();

    if (!mounted) return;

    setState(() {
      _biometricLoginEnabled = enabled;
    });
  }

  Future<void> _handleBiometricChanged(bool value) async {
    if (value) {
      final available = await BiometricService().isAvailable();

      if (!mounted) return;

      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication is not available'),
          ),
        );
        return;
      }

      final authenticated = await FingerprintBottomSheet.show(context);

      if (!authenticated || !mounted) return;
    }

    await BiometricPreferenceService().setEnabled(value);

    if (!mounted) return;

    setState(() {
      _biometricLoginEnabled = value;
    });
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
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        appBar: const WalletAppBar(),
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  const SizedBox(height: 32),
                  _WalletBalance(wallet: wallet),
                  const SizedBox(height: 26),
                  const _QuickActions(),
                  const SizedBox(height: 28),
                  _SecurityCard(
                    isBiometricEnabled: _biometricLoginEnabled,
                    onBiometricChanged: _handleBiometricChanged,
                  ),
                  const SizedBox(height: 28),
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
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 34,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                address == null
                    ? 'Wallet address unavailable'
                    : 'Your address ${_shortAddress(address)}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
              if (walletType != null && walletType.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    walletType,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 10,
                    ),
                  ),
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
      children: [
        Expanded(
          child: _QuickAction(
            key: const ValueKey('send-action'),
            icon: Icons.north_east_rounded,
            label: 'Send',
          ),
        ),
        Expanded(
          child: _QuickAction(
            key: const ValueKey('receive-action'),
            icon: Icons.south_west_rounded,
            label: 'Receive',
          ),
        ),
        Expanded(
          child: _QuickAction(
            key: const ValueKey('scan-action'),
            icon: Icons.qr_code_scanner_rounded,
            label: 'Scan',
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          button: true,
          label: label,
          child: Material(
            color: AppTheme.surface,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap ?? () {},
              child: Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryBorder),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.surfaceRaised, AppTheme.surface],
                  ),
                ),
                child: Icon(icon, color: AppTheme.textPrimary, size: 24),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12),
        ),
      ],
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({
    required this.isBiometricEnabled,
    required this.onBiometricChanged,
  });

  final bool isBiometricEnabled;
  final ValueChanged<bool> onBiometricChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _SecurityRow(
            icon: Icons.fingerprint_rounded,
            iconColor: AppTheme.positive,
            iconBackgroundColor: AppTheme.positiveIconBackground,
            title: 'Use biometrics to log in',
            trailing: BiometricSwitch(
              value: this.isBiometricEnabled,
              onChanged: this.onBiometricChanged,
            ),
          ),
          Divider(height: 1, color: AppTheme.dividerColor),
          _SecurityRow(
            icon: Icons.key_rounded,
            iconColor: AppTheme.warning,
            iconBackgroundColor: AppTheme.warningIconBackground,
            title: 'Back up the wallet recovery phrase',
            trailing: const _LocalSwitch(),
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
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 11,
                  height: 1.25,
                ),
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _LocalSwitch extends StatefulWidget {
  const _LocalSwitch();

  @override
  State<_LocalSwitch> createState() => _LocalSwitchState();
}

class _LocalSwitchState extends State<_LocalSwitch> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Back up wallet recovery phrase ${_value ? 'on' : 'off'}',
      toggled: _value,
      child: Switch(
        value: _value,
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
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
        const Text(
          'Assets',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
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
      height: 120,
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
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Could not load wallet',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: AppTheme.textSecondary,
            size: 28,
          ),
          SizedBox(height: 10),
          Text(
            'Your wallet is empty',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Your assets will appear here once they are added.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
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
    final coinSymbol = symbol ?? title;
    final coin = MarketCoin(
      id: _stringValue(asset['id'] ?? asset['coinId']) ?? coinSymbol,
      name: title,
      symbol: coinSymbol,
      price: _numberValue(asset['current_price'] ?? asset['price']),
      change24h: _numberValue(asset['price_change_percentage_24h']),
      imageUrl: _stringValue(asset['image'] ?? asset['imageUrl']),
    );

    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => CoinDetailPage(coin: coin)),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceRaised,
                  shape: BoxShape.circle,
                ),
                child: _isEthereumAsset(symbol, title)
                    ? ClipOval(
                        child: Image.asset(
                          'assets/icons/ethereum.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.token_outlined,
                        color: AppTheme.textPrimary,
                        size: 20,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (symbol != null)
                      Text(
                        symbol,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              if (balance != null)
                Text(
                  balance,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                  ),
                ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _stringValue(Object? value) {
    if (value is String || value is num) {
      return value.toString();
    }
    return null;
  }

  num _numberValue(Object? value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  bool _isEthereumAsset(String? symbol, String title) {
    return symbol?.toUpperCase() == 'ETH' || title.toLowerCase() == 'ethereum';
  }
}
