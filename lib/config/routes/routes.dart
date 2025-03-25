import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uex_app/features/contacts/core/contacts_routes.dart';
import 'package:uex_app/features/login/presentation/pages/login_page.dart';

GoRouter router(SharedPreferences preferences) {
  return GoRouter(
    initialLocation: LoginPage.routeName,
    routes: [
      GoRoute(
        path: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      ...ContactsRoutes.routes,
    ],
  );
}
