import 'package:attendance_app/src/views/screens/screens.dart';
import 'package:go_router/go_router.dart';

final GoRouter routes = GoRouter(
  routes: [
    GoRoute(
      path: "/login",
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: "/",
      builder: (context, state) => HomeStudent(),
    ),
  ],
);
