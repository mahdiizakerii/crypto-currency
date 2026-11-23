import 'package:crypto_currency/core/utils/app_theme.dart';
import 'package:crypto_currency/feature/news/presentation/bloc/news_bloc.dart';
import 'package:crypto_currency/feature/news/presentation/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(NewsRequested());
  }

  Future<void> _refresh() async {
    final bloc = context.read<NewsBloc>();
    final loaded = bloc.stream.firstWhere((state) => !state.isLoading);
    bloc.add(NewsRequested());
    await loaded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: AppTheme.background,
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _refresh,
            color: AppTheme.primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const Text(
                  'Stay in the know',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The latest stories from the crypto world',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 18),
                if (state.isLoading && state.items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(color: AppTheme.primary),
                    ),
                  )
                else if (state.error != null && state.items.isEmpty)
                  _NewsError(message: state.error!, onRetry: _refresh)
                else if (state.items.isEmpty)
                  const _EmptyNews()
                else
                  for (var index = 0; index < state.items.length; index++)
                    NewsCard(item: state.items[index], featured: index == 0),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NewsError extends StatelessWidget {
  const _NewsError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.cloud_off_rounded, color: AppTheme.textSecondary),
        const SizedBox(height: 8),
        Text(message, style: const TextStyle(color: AppTheme.textSecondary)),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}

class _EmptyNews extends StatelessWidget {
  const _EmptyNews();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(30),
      child: Text(
        'There are no news stories right now.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppTheme.textSecondary),
      ),
    );
  }
}
