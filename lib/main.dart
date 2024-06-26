import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:warranty_tracker/constants/api_key.dart';
import 'package:warranty_tracker/firebase_options.dart';
import 'package:warranty_tracker/routes/routes.dart';
import 'package:warranty_tracker/routes/routes_names.dart';
import 'package:warranty_tracker/service/notification_service.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';
import 'package:warranty_tracker/theme/color_sceme.dart';
import 'package:warranty_tracker/theme/cubit/theme_cubit.dart';
import 'package:warranty_tracker/theme/theme_manager.dart';
import 'package:warranty_tracker/views/screens/Language/cubit/select_language_cubit.dart';
import 'package:warranty_tracker/views/screens/add_product/bloc/product_bloc.dart';
import 'package:warranty_tracker/views/screens/auth/bloc/auth_bloc.dart';
import 'package:warranty_tracker/views/screens/fetch_image_data/bloc/fetch_image_data_bloc.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initializing firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppPref.init();
  //initializing firebase messaging for notification

  await NotificationService.requestNotificationPermission();
  await NotificationService.initLocalNotification();
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseBackgroundMessageNotification,
  );
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      //print('Background message tapped');
      navigatorKey.currentState!
          .pushNamed(RoutesName.aboutMe, arguments: message);
    }
  });

  //to handle Foreground notifications

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final payloadData = jsonEncode(message.data);
    // print('Got a foreground message');
    if (message.notification != null) {
      NotificationService.showSimpleNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: payloadData,
      );
    }
  });
  //to handle terminated message
  await NotificationService.firebaseTerminatedMessageNotification();
  //Initializing Gemini
  Gemini.init(apiKey: geminiApiKey);
  // print('here I am');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ProductBloc>(
          create: (context) =>
              ProductBloc()..add(GetAllProductEvent(filterValue: '1')),
        ),
        BlocProvider<SelectLanguageCubit>.value(
          value: SelectLanguageCubit(),
        ),
        BlocProvider<ThemeCubit>.value(
          value: ThemeCubit(),
        ),
        BlocProvider(create: (context) => FetchImageDataBloc()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, themeSate) {
          // print('From theme state');
          return BlocBuilder<SelectLanguageCubit, String>(
            builder: (context, state) {
              // print('From language state');
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'Warranty Tracker App',
                themeMode: themeSate ? ThemeMode.dark : ThemeMode.light,
                theme: appTheme(
                  context,
                  colorScheme: lightColorScheme,
                  systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                ),
                darkTheme: appTheme(
                  context,
                  colorScheme: darkColorScheme,
                  systemUiOverlayStyle: SystemUiOverlayStyle.light,
                ),
                initialRoute: RoutesName.splashScreen,
                onGenerateRoute: Routes.generateRoute,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('hi')],
                locale: Locale(state),
              );
            },
          );
        },
      ),
    );
  }
}
