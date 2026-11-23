import 'package:equatable/equatable.dart';

class Collectible extends Equatable {
  const Collectible({
    required this.id,
    required this.name,
    required this.artist,
    required this.bid,
    required this.currency,
    required this.category,
    required this.description,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String artist;
  final String bid;
  final String currency;
  final String category;
  final String description;
  final String? imageUrl;

  @override
  List<Object?> get props => [
    id,
    name,
    artist,
    bid,
    currency,
    category,
    description,
    imageUrl,
  ];
}
