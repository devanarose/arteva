
import 'package:erp_demo/providers/auth_provider.dart';
import 'package:erp_demo/screens/wishlist.dart';
import 'package:erp_demo/widget/categories.dart';
import 'package:erp_demo/widget/banner_slider.dart';
import 'package:erp_demo/widget/new_arrivals.dart';
import 'package:erp_demo/widget/products.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/account.dart';
import '../widget/bottom_navbar.dart';
import '../widget/categorygrid_widget.dart';

import '../widget/web_header.dart';
import 'cart_page.dart';


class HomeScreen extends StatefulWidget {
  static final String route = '/homescreen';
  var index;

  HomeScreen({this.index = 0,super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _currentRoute = '/homescreen';

  final Map<String, int> routeToIndex = {
    '/homescreen': 0,
    '/wishlist': 1,
    '/cartpage': 2,
    '/categories': 3,
    '/account': 4,
  };

  final Map<int, String> indexToRoute = {
    0: '/homescreen',
    1: '/wishlist',
    2: '/cartpage',
    3: '/categories',
    4: '/account',
  };

  @override
  void initState() {
    _currentIndex = widget.index;
    _currentRoute = indexToRoute[widget.index]??'';
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;

    final List<Widget> pages = [
      _buildMainContent(paddingTop),
      Wishlist(),
      CartPage(),
      _buildCategoriesPage(),
      const AccountPage(),
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
        body: Column(
          children: [
            if (kIsWeb && _currentRoute != '/homescreen0')
              WebHeader(
                currentRoute: _currentRoute,
                onNavigate: _webTabSelected,
              ),
            Expanded(
              child: Stack(
                children: [
                  pages[_currentIndex],
                  if (!kIsWeb)
                    BottomNavBar(
                      currentIndex: _currentIndex,
                      onTabSelected: (index) {
                        setState(() {
                          _currentIndex = index;
                          _currentRoute = indexToRoute[index]!;
                          print('$index');
                        });
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _webTabSelected(String route) {
    // if(kIsWeb){
      updateBrowserUrl(route);
      // Navigator.pushNamed(context, route);
      Navigator.of(context).push(_noAnimation(route));
      setState(() {
        _currentRoute = route;
        _currentIndex = routeToIndex[route] ?? 0;
        print('route : $route');
      });
    // }else{
    // }
  }
  void updateBrowserUrl(String route) {
    // if(kIsWeb){
    //   history.pushState(null, null, '?arg1=1');
    // }
    // final uri = Uri.base.replace(path: route);
    // web.window.history.pushState(null, '', uri.toString());
  }

  Widget _buildMainContent(double paddingTop) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        if (!kIsWeb) {
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
                                      hintText: 'Search Products',
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
        }else {
          return <Widget>[];
        }
        },
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: const [
          Categories(),
          BannerSlider(),
          Products(),
          NewArrivals()
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

  Route _noAnimation(String routeName) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      pageBuilder: (context, animation, secondaryAnimation) {
        return HomeScreen(index: routeToIndex[routeName] ?? 0);
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

}
