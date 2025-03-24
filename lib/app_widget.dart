import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uex_app/config/routes/routes.dart';
import 'package:uex_app/config/themes/dark_theme.dart';
import 'package:uex_app/config/themes/light_theme.dart';
import 'package:uex_app/core/infra/http_client.dart';
import 'package:uex_app/features/address/core/address_provider.dart';
import 'package:uex_app/features/contacts/core/contacts_provider.dart';

class AppWidget extends StatelessWidget {
  final SharedPreferences preferences;
  const AppWidget({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          Provider(
            create: (_) => HttpClient(),
          ),
          Provider<SharedPreferences>(
            create: (context) => preferences,
          ),
          Provider(
            create: (context) => AuthenticatedClient(
              sharedPreferences: context.read<SharedPreferences>(),
            ),
          ),
          ...ContactsInject.providers,
          ...AddressInject.providers,
          
        ],
        child: MaterialApp.router(
          title: 'UEX App',
          debugShowCheckedModeBanner: false,
          routerConfig: router(preferences),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
        ));
  }
}
