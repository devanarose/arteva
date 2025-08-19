import 'package:flutter/material.dart';

class MyNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> stack = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    stack.add(route);
    printStack();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    stack.remove(route);
    printStack();
  }

  void printStack() {
    print('Current navigation stack:');
    for (var i = 0; i < stack.length; i++) {
      final name = stack[i].settings.name ?? stack[i].toString();
      print('  $i: $name');
    }
  }
}
