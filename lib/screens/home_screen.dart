import 'package:erp_demo/providers/auth_provider.dart';
import 'package:erp_demo/screens/welcome_screen.dart';
import 'package:erp_demo/screens/wishlist.dart';
import 'package:erp_demo/widget/categories.dart';
import 'package:erp_demo/widget/banner_slider.dart';
import 'package:erp_demo/widget/new_arrivals.dart';
import 'package:erp_demo/widget/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bottom_navbar_design.dart';
import '../providers/cart_provider.dart';

import '../widget/categorygrid_widget.dart';

import 'add_category.dart';
import 'add_product.dart';
import 'cart_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;

    final List<Widget> pages = [
      _buildMainContent(paddingTop),
      Wishlist(),
      CartPage(),
      _buildCategoriesPage(),
      _buildAccountPage(context),
    ];

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            pages[_currentIndex],
            Positioned(
              left: -5,
              right: -5,
              bottom: -7,
              child: SizedBox(
                height: 90,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Container(color: Colors.transparent),
                    ),

                    ClipPath(
                      clipper: BottomNavBarClipper(),
                      child: Container(
                        height: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, -2),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.home_filled,
                                  color: _currentIndex == 0
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey),
                              onPressed: () => setState(() => _currentIndex = 0),
                            ),
                            Transform.translate(
                              offset: Offset(-30, 0),
                              child: IconButton(
                                icon: Icon(Icons.favorite,
                                    color: _currentIndex == 1 ? Theme.of(context).primaryColor : Colors.grey),
                                onPressed: () => setState(() => _currentIndex = 1),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(30, 0),
                              child: IconButton(
                                icon: Icon(Icons.category_sharp,
                                    color: _currentIndex == 3 ? Theme.of(context).primaryColor : Colors.grey),
                                onPressed: () => setState(() => _currentIndex = 3),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.person_2_rounded,
                                  color: _currentIndex == 4 ? Theme.of(context).primaryColor : Colors.grey),
                              onPressed: () => setState(() => _currentIndex = 4),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Cart
                    Positioned(
                      top: -30,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()),);
                        },
                        child: Opacity(
                          opacity: _currentIndex == 2 ? 0.0 : 1.0, 
                          child: Container(
                            height: 100,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Consumer<CartProvider>(
                              builder: (context, cartProvider, _) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Center(
                                      child: Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                                    ),
                                    if (cartProvider.uniqueItemCount > 0 && _currentIndex != 2)
                                      Positioned(
                                        right: 1,
                                        top: 15,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                          child: Text(
                                            '${cartProvider.uniqueItemCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(double paddingTop) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final double maxHeight = 200;
                final double minHeight = kToolbarHeight + paddingTop;
                final double currentHeight = constraints.biggest.height;
                final double collapsePercent = (currentHeight - minHeight) / (maxHeight - minHeight);

                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: paddingTop + 8,
                        left: 20,
                        child: Row(
                          children: [
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, _) {
                                final imageUrl = authProvider.user?['image'];
                                return imageUrl != null
                                    ? CircleAvatar(
                                  backgroundImage: NetworkImage(imageUrl),
                                  radius: 18,
                                )
                                    : const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person, color: Colors.black),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'ArtEva',
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                          ],
                        ),
                      ),

                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          final username = authProvider.user?['firstName'] ?? '';
                          return Positioned(
                            top: paddingTop + 60 - (20 * (1.0 - collapsePercent)),
                            left: 65,
                            child: Opacity(
                              opacity: collapsePercent.clamp(0.0, 1.0),
                              child: Text(
                                'Hi $username!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),


                      if (collapsePercent > 0.2)
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: Opacity(
                            opacity: collapsePercent.clamp(0.0, 1.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                height: 48,
                                color: Colors.white,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search events',
                                    prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ];
      },
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: const [
          Categories(),
          BannerSlider(),
          Products(),
          NewArrivals()
          // BannerSlider(),
        ],
      ),
    );
  }

  Widget _buildCategoriesPage(){
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 40, 19, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'All Categories',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CategoriesGrid(),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  // Account tab content
  Widget _buildAccountPage(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final username = authProvider.user?['firstName'] ?? 'Guest';
        return Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_outline, size: 80, color: Colors.black),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome, $username!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await authProvider.logout();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => WelcomeScreen()), (route) => false,);
                    },
                    child: const Text('Logout', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AddProducts()),);
                    },
                    child: const Text('Add product', style: TextStyle(color: Colors.white)),
                  ),ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AddCategoryPage()),);
                    },
                    child: const Text('Add category', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }
}
