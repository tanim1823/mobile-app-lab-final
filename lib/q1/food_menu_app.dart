import 'package:flutter/material.dart';

// ════════════════════════════════════════
//  MODEL
// ════════════════════════════════════════
class Food {
  final String name;
  final String category;
  final double price;
  final double rating;
  final Color color;
  final IconData icon;

  const Food({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.color,
    required this.icon,
  });
}

const _foods = [
  Food(name: 'Beef Burger',      category: 'Fast Food', price: 5.99,  rating: 4.5, color: Color(0xFFFF6B35), icon: Icons.lunch_dining),
  Food(name: 'Margherita Pizza', category: 'Italian',   price: 8.99,  rating: 4.7, color: Color(0xFFE53935), icon: Icons.local_pizza),
  Food(name: 'Chicken Pasta',    category: 'Italian',   price: 7.49,  rating: 4.3, color: Color(0xFFFFA000), icon: Icons.ramen_dining),
  Food(name: 'Caesar Salad',     category: 'Healthy',   price: 4.99,  rating: 4.1, color: Color(0xFF43A047), icon: Icons.eco),
  Food(name: 'Sushi Platter',    category: 'Japanese',  price: 11.99, rating: 4.8, color: Color(0xFFEC407A), icon: Icons.set_meal),
  Food(name: 'Ice Cream',        category: 'Dessert',   price: 3.49,  rating: 4.6, color: Color(0xFF1E88E5), icon: Icons.icecream),
  Food(name: 'Fried Chicken',    category: 'Fast Food', price: 6.49,  rating: 4.4, color: Color(0xFFF57F17), icon: Icons.kebab_dining),
  Food(name: 'Cheesecake',       category: 'Dessert',   price: 4.49,  rating: 4.5, color: Color(0xFF8E24AA), icon: Icons.cake),
];

// ════════════════════════════════════════
//  THEME NOTIFIER
// ════════════════════════════════════════
class _ThemeNotifier extends ChangeNotifier {
  bool _dark = false;
  bool get dark => _dark;
  void toggle() {
    _dark = !_dark;
    notifyListeners();
  }
}

// ════════════════════════════════════════
//  APP ROOT
// ════════════════════════════════════════
class FoodMenuApp extends StatefulWidget {
  const FoodMenuApp({super.key});

  @override
  State<FoodMenuApp> createState() => _FoodMenuAppState();
}

class _FoodMenuAppState extends State<FoodMenuApp> {
  final _themeNotifier = _ThemeNotifier();

  ThemeData _buildTheme(bool dark) {
    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorSchemeSeed: Colors.deepOrange,
      scaffoldBackgroundColor:
      dark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        color: dark ? const Color(0xFF1E1E1E) : Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeNotifier,
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(false),
        darkTheme: _buildTheme(true),
        themeMode:
        _themeNotifier.dark ? ThemeMode.dark : ThemeMode.light,
        home: _FoodMenuScreen(themeNotifier: _themeNotifier),
      ),
    );
  }
}

// ════════════════════════════════════════
//  SCREEN
// ════════════════════════════════════════
class _FoodMenuScreen extends StatelessWidget {
  final _ThemeNotifier themeNotifier;
  const _FoodMenuScreen({required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Food Menu',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          AnimatedBuilder(
            animation: themeNotifier,
            builder: (_, __) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: themeNotifier.toggle,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white12
                        : Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    themeNotifier.dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          final isWide = constraints.maxWidth > 600;

          if (isWide) {
            final cols = constraints.maxWidth > 1000 ? 4 : 3;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                childAspectRatio: 0.75,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: _foods.length,
              itemBuilder: (_, i) =>
                  FoodCard(food: _foods[i], isGrid: true),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: _foods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) =>
                  FoodCard(food: _foods[i], isGrid: false),
            );
          }
        },
      ),
    );
  }
}

// ════════════════════════════════════════
//  FOOD CARD
// ════════════════════════════════════════
class FoodCard extends StatelessWidget {
  final Food food;
  final bool isGrid;
  const FoodCard({super.key, required this.food, required this.isGrid});

  @override
  Widget build(BuildContext context) {
    return isGrid ? _GridCard(food: food) : _ListCard(food: food);
  }
}

// ── Grid Card (Tablet) ──────────────────
class _GridCard extends StatelessWidget {
  final Food food;
  const _GridCard({required this.food});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Colored image section ──
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    food.color.withOpacity(0.15),
                    food.color.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18)),
              ),
              child: Stack(
                children: [
                  // Category badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: food.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: food.color.withOpacity(0.3)),
                      ),
                      child: Text(
                        food.category,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: food.color),
                      ),
                    ),
                  ),
                  // Icon
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: food.color.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(food.icon,
                          color: food.color, size: 32),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Details section ──
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              color: Colors.amber, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            food.rating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${(food.rating * 20).toInt()} reviews)',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${food.price.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: food.color),
                      ),
                      _AddButton(food: food),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── List Card (Phone) ───────────────────
class _ListCard extends StatelessWidget {
  final Food food;
  const _ListCard({required this.food});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // ── Icon box ──
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    food.color.withOpacity(0.15),
                    food.color.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(food.icon, color: food.color, size: 32),
            ),
            const SizedBox(width: 14),

            // ── Details ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          food.name,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${food.price.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: food.color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: food.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          food.category,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: food.color),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star_rounded,
                          color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        food.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _AddButton(food: food, fullWidth: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add Button ──────────────────────────
class _AddButton extends StatefulWidget {
  final Food food;
  final bool fullWidth;
  const _AddButton({required this.food, this.fullWidth = false});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    if (_count == 0) {
      return SizedBox(
        width: widget.fullWidth ? double.infinity : null,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: widget.food.color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            minimumSize: const Size(0, 36),
          ),
          onPressed: () => setState(() => _count = 1),
          child: const Text('Add to Cart',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: widget.food.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize:
        widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.white, size: 18),
            onPressed: () => setState(() {
              if (_count > 0) _count--;
            }),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
          ),
          Text(
            '$_count',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            onPressed: () => setState(() => _count++),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}