import 'package:audioplayers/audioplayers.dart';
import 'package:entregga_courier/application/bloc/app_bloc.dart';
import 'package:entregga_courier/application/presentation/views/adresses_screen/adresses_screen.dart';
import 'package:entregga_courier/application/presentation/views/login_screen/login_screen.dart';
import 'package:entregga_courier/domain/user_auth/auth.dart';
import 'package:entregga_courier/firebase_options.dart';
import 'package:entregga_courier/global_key.dart';
import 'package:entregga_courier/l10n/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Auth().checkUserSigned();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return BlocProvider(
      create: (context) => AppBloc(),
      child: MaterialApp(
        navigatorKey: MyGlobalKey.globalKey,
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.black,
            dividerColor: Colors.black.withOpacity(0.3),
            colorScheme: const ColorScheme.light(primary: Colors.green)),
        home: Builder(builder: (context) {
          if (userLogged == true) {
            context.read<AppBloc>().add(AppEventGetData(
                storeID: userLoggedStoreID!, courierID: userLoggedCourierID!));
          }
          return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
            if (state is AppStateLoggedIn && userLogged == true) {
              return const AdressesScreen();
            }
            if (state is AppStateLoggedOut ||
                state is AppStateLoginError && userLogged == false) {
              return const LoginScreen();
            } else {
              return const SizedBox.shrink();
            }
          });
        }),
      ),
    );
  }
}
