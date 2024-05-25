import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecommerce_app/src/features/products_list/products_list_screen.dart';
import 'package:ecommerce_app/src/features/shopping_cart/shopping_cart_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductsListScreen(),
      routes: [
        GoRoute(
          path: 'cart',
          pageBuilder: (context, state) => const MaterialPage(
            fullscreenDialog: true,
            child: ShoppingCartScreen(),
          ),
        ),
      ],
    ),
  ],
);
