// ignore_for_file: must_be_immutable, invalid_annotation_target

import 'package:crypto_currency/feature/wallet/domain/entites/wallet_entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
sealed class WalletStatus extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class WalletLoading extends WalletStatus {}

class WalletError extends WalletStatus {
  final String message;
  WalletError(this.message);
  @override
  List<Object?> get props => [message];
}

class WalletLoaded extends WalletStatus {
  WalletEntities walletEntities;
  WalletLoaded(this.walletEntities);
  @override
  List<Object?> get props => [walletEntities];
}
