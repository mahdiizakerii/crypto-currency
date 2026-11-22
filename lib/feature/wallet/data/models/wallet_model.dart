import 'package:tonkeeper/feature/wallet/domain/entites/wallet_entities.dart';

class WalletModel extends WalletEntities {
  const WalletModel({required super.success, required super.data});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final success = json['success'];
    final data = json['data'];

    if (success is! bool) {
      throw const FormatException('Wallet response success must be a bool.');
    }
    if (!success) {
      final error = json['error'];
      throw FormatException(
        error is String && error.isNotEmpty
            ? error
            : 'Wallet request was not successful.',
      );
    }
    if (data is! Map) {
      throw const FormatException('Wallet response data must be an object.');
    }

    return WalletModel(
      success: success,
      data: WalletDataModel.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': {
      'totalBalanceUsd': data.totalBalanceUsd,
      'walletAddress': data.walletAddress,
      'walletType': data.walletType,
      'isBiometricEnabled': data.isBiometricEnabled,
      'assets': data.assets,
    },
  };
}

class WalletDataModel extends WalletData {
  const WalletDataModel({
    required super.totalBalanceUsd,
    required super.walletAddress,
    required super.walletType,
    required super.isBiometricEnabled,
    required super.assets,
  });

  factory WalletDataModel.fromJson(Map<String, dynamic> json) {
    final totalBalanceUsd = json['totalBalanceUsd'];
    final walletAddress = json['walletAddress'];
    final walletType = json['walletType'];
    final isBiometricEnabled = json['isBiometricEnabled'];
    final assets = json['assets'];

    if (totalBalanceUsd is! num) {
      throw const FormatException('totalBalanceUsd must be a number.');
    }
    if (walletAddress != null && walletAddress is! String) {
      throw const FormatException('walletAddress must be a string or null.');
    }
    if (walletType != null && walletType is! String) {
      throw const FormatException('walletType must be a string or null.');
    }
    if (isBiometricEnabled is! bool) {
      throw const FormatException('isBiometricEnabled must be a bool.');
    }
    if (assets is! List) {
      throw const FormatException('assets must be a list.');
    }

    return WalletDataModel(
      totalBalanceUsd: totalBalanceUsd,
      walletAddress: walletAddress as String?,
      walletType: walletType as String?,
      isBiometricEnabled: isBiometricEnabled,
      assets: List<Object?>.unmodifiable(assets),
    );
  }
}
