import 'package:crypto_currency/config/services/biometric_preference_service.dart';
import 'package:crypto_currency/config/services/biometric_service.dart';
import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:crypto_currency/feature/wallet/presentation/bloc/wallet_status.dart';
import 'package:crypto_currency/feature/wallet/presentation/screens/main_bottom_nav.dart';
import 'package:crypto_currency/feature/chart/presentation/screens/chart_page.dart';
import 'package:crypto_currency/feature/news/presentation/screens/news_page.dart';
import 'package:crypto_currency/feature/login/pressentation/widgets/bottom_sheet_biometric.dart';
import 'package:crypto_currency/feature/wallet/presentation/widgets/biometric_switch.dart';
import 'package:crypto_currency/feature/wallet/presentation/widgets/wallet_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainBottomNav(
      screens: [
        _WalletDashboardPage(),
        ChartPage(),
        NewsPage(),
        _ComingSoonPage(title: 'Collectibles'),
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
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {},
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
              value: isBiometricEnabled,
              onChanged: onBiometricChanged,
            ),
          ),
          Divider(height: 1, color: AppTheme.dividerColor),
          _SecurityRow(
            icon: Icons.key_rounded,
            iconColor: AppTheme.warning,
            iconBackgroundColor: AppTheme.warningIconBackground,
            title: 'Back up the wallet recovery phrase',
            trailing: _StaticSwitch(value: false),
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
        width: 34,
        height: 20,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? AppTheme.primary : AppTheme.surfaceRaised,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: AppTheme.textPrimary,
              shape: BoxShape.circle,
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppTheme.surfaceRaised,
              shape: BoxShape.circle,
            ),
            child: const Icon(
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
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12),
            ),
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
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
      ),
    );
  }
}
