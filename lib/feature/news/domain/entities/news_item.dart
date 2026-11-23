import 'package:equatable/equatable.dart';

class NewsItem extends Equatable {
  const NewsItem({
    required this.id,
    required this.title,
    required this.source,
    required this.timeAgo,
    required this.category,
    required this.summary,
    this.imageUrl,
    this.isHot = false,
  });

  final String id;
  final String title;
  final String source;
  final String timeAgo;
  final String category;
  final String summary;
  final String? imageUrl;
  final bool isHot;

  @override
  List<Object?> get props => [
    id,
    title,
    source,
    timeAgo,
    category,
    summary,
    imageUrl,
    isHot,
  ];
}
