import 'package:equatable/equatable.dart';

class WalletEntities extends Equatable {
  final bool success;
  final WalletData data;

  const WalletEntities({required this.success, required this.data});

  @override
  List<Object?> get props => [success, data];
}

class WalletData extends Equatable {
  final num totalBalanceUsd;
  final String? walletAddress;
  final String? walletType;
  final bool isBiometricEnabled;
  final List<Object?> assets;

  const WalletData({
    required this.totalBalanceUsd,
    required this.walletAddress,
    required this.walletType,
    required this.isBiometricEnabled,
    required this.assets,
  });

  @override
  List<Object?> get props => [
    totalBalanceUsd,
    walletAddress,
    walletType,
    isBiometricEnabled,
    assets,
  ];
}
