import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'article_model.dart';
import 'news_provider.dart';

// ════════════════════════════════════════
//  APP ROOT
// ════════════════════════════════════════
class NewsReaderApp extends StatelessWidget {
  const NewsReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsProvider()..fetchArticles(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News Reader',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          fontFamily: 'Roboto',
        ),
        home: const NewsScreen(),
      ),
    );
  }
}

// ════════════════════════════════════════
//  NEWS SCREEN
// ════════════════════════════════════════
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('📰 News Reader'),
        centerTitle: true,
        actions: [
          // ── Favorites badge ──
          Consumer<NewsProvider>(
            builder: (_, p, __) => Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_rounded),
                  onPressed: () {},
                ),
                if (p.favoriteCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${p.favoriteCount}',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 6),
        ],
        // ── Search Bar ──
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: Consumer<NewsProvider>(
              builder: (_, p, __) => TextField(
                onChanged: p.search,
                decoration: InputDecoration(
                  hintText: 'Search articles by title...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<NewsProvider>(
        builder: (ctx, provider, _) {
          // ── Loading ──
          if (provider.state == LoadState.loading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading articles...'),
                ],
              ),
            );
          }

          // ── Error ──
          if (provider.state == LoadState.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.wifi_off_rounded,
                          size: 56, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    const Text('Failed to load articles',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(provider.errorMsg,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: provider.fetchArticles,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── Empty search result ──
          if (provider.articles.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No articles found',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          // ── Success: ListView ──
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
            itemCount: provider.articles.length,
            itemBuilder: (ctx, index) {
              final article = provider.articles[index];
              return _ArticleTile(article: article);
            },
          );
        },
      ),
    );
  }
}

// ════════════════════════════════════════
//  ARTICLE TILE
// ════════════════════════════════════════
class _ArticleTile extends StatelessWidget {
  final Article article;
  const _ArticleTile({required this.article});

  static const _colors = [
    Color(0xFF5C6BC0), Color(0xFF26A69A), Color(0xFFEF5350),
    Color(0xFFAB47BC), Color(0xFF42A5F5), Color(0xFFFF7043),
  ];

  @override
  Widget build(BuildContext context) {
    final accentColor = _colors[article.id % _colors.length];

    return Consumer<NewsProvider>(
      builder: (ctx, provider, _) {
        final fav = provider.isFavorite(article.id);

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: provider,
                  child: DetailScreen(article: article),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Avatar ──
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${article.id}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // ── Title + body ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  // ── Fav button ──
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        key: ValueKey(fav),
                        color: fav ? Colors.red : Colors.grey,
                        size: 22,
                      ),
                    ),
                    onPressed: () => provider.toggleFavorite(article.id),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════
//  DETAIL SCREEN
// ════════════════════════════════════════
class DetailScreen extends StatelessWidget {
  final Article article;
  const DetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (ctx, provider, _) {
        final fav = provider.isFavorite(article.id);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Article Detail'),
            actions: [
              IconButton(
                tooltip: fav ? 'Remove from favorites' : 'Add to favorites',
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    key: ValueKey(fav),
                    color: fav ? Colors.red : null,
                  ),
                ),
                onPressed: () => provider.toggleFavorite(article.id),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Post badge ──
                Row(
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Post #${article.id}',
                        style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'User ${article.userId}',
                        style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // ── Title ──
                Text(
                  article.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                // ── Body ──
                Text(
                  article.body,
                  style: const TextStyle(fontSize: 16, height: 1.7, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                // ── Fav action card ──
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: fav
                        ? Colors.red.withOpacity(0.07)
                        : Colors.grey.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: fav
                          ? Colors.red.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: fav ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        fav ? 'Saved to favorites' : 'Not in favorites',
                        style: TextStyle(
                          color: fav ? Colors.red : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => provider.toggleFavorite(article.id),
                        child: Text(fav ? 'Remove' : 'Save'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}