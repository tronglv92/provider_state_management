import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider_state_management/generated/l10n.dart';
import 'package:provider_state_management/pages/counter/counter_page.dart';
import 'package:provider_state_management/pages/home/home_page.dart';
import 'package:provider_state_management/pages/home/home_provider.dart';
import 'package:provider_state_management/pages/login/login_provider.dart';
import 'package:provider_state_management/services/app/app_loading.dart';
import 'package:provider_state_management/services/app/auth_provider.dart';
import 'package:provider_state_management/services/app/locale_provider.dart';
import 'package:provider_state_management/services/cache/cache.dart';
import 'package:provider_state_management/services/cache/cache_preferences.dart';
import 'package:provider_state_management/services/cache/credential.dart';
import 'package:provider_state_management/services/rest_api/api_user.dart';
import 'package:provider_state_management/utils/app_config.dart';
import 'package:provider_state_management/utils/app_log.dart';
import 'package:provider_state_management/utils/app_route.dart';
import 'package:provider_state_management/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Mock navigator observer class by mockito
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // Mock navigator to verify navigation
  final MockNavigatorObserver navigatorObserver = MockNavigatorObserver();

  // Widget to test
  Widget appWidget;
  AppRoute appRoute;
  /// Setup for test
  setUp(() {
    AppConfig(env: Env.dev());

    // Testing in flutter gives error MediaQuery.of() called
    // with a context that does not contain a MediaQuery
    appWidget = MediaQuery(
      data: const MediaQueryData(),
      child: MultiProvider(
        providers: <SingleChildWidget>[
          Provider<AppRoute>(create: (_) => AppRoute()),
          Provider<Cache>(create: (_) => CachePreferences()),
          ChangeNotifierProvider<Credential>(
              create: (BuildContext context) => Credential(
                context.read<Cache>(),
              )),
          ProxyProvider<Credential, ApiUser>(
              create: (_) => ApiUser(),
              update: (_, Credential credential, ApiUser userApi) {
                return userApi..token = credential.token;
              }),
          Provider<AppLoading>(create: (_) => AppLoading()),
          ChangeNotifierProvider<LocaleProvider>(
              create: (_) => LocaleProvider()),
          ChangeNotifierProvider<AppThemeProvider>(
              create: (_) => AppThemeProvider()),
          ChangeNotifierProvider<AuthProvider>(
              create: (BuildContext context) => AuthProvider(
                context.read<ApiUser>(),
                context.read<Credential>(),
              )),
          ChangeNotifierProvider<HomeProvider>(
              create: (BuildContext context) => HomeProvider(
                context.read<ApiUser>(),
              )),
          ChangeNotifierProvider<LoginProvider>(
              create: (BuildContext context) => LoginProvider()),
        ],
        child: Builder(
          builder: (BuildContext context) {
            // Save provider ref here

            appRoute = Provider.of(context, listen: false);

            // Mock navigator Observer
            when(navigatorObserver.didPush(any, any))
                .thenAnswer((Invocation invocation) {
              logger.d('didPush ${invocation.positionalArguments}');
            });



            // Get providers
            final LocaleProvider localeProvider =
            context.watch<LocaleProvider>();

            // Build Material app
            return ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: () =>  MaterialApp(
                navigatorKey: appRoute.navigatorKey,
                locale: localeProvider.locale,
                supportedLocales: S.delegate.supportedLocales,
                localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],

                home: (appRoute.generateRoute(
                    const RouteSettings(name: AppRoute.routeHome))
                as MaterialPageRoute<dynamic>)
                    .builder(context),
                onGenerateRoute: appRoute.generateRoute,
                navigatorObservers: <NavigatorObserver>[navigatorObserver],
              ),
            );
          },
        ),
      ),
    );
  });

  /// Test case:
  /// - Tap on Counter Page button
  /// - App navigate from HomePage to CounterPage
  testWidgets('Navigate from HomePage to CounterPage',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    // Build a MaterialApp with MediaQuery.
    await tester.pumpWidget(appWidget);
    // Wait the widget state updated until the LocalizationsDelegate initialized.
    await tester.pumpAndSettle();

    // Verify that HomePage displayed
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);

    // Verify that RaisedButton on screen
    final Finder counterPageFinder =
        find.byKey(const Key(AppRoute.routeCounter));
    expect(counterPageFinder, findsOneWidget);

    // Tap on RaisedButton
    await tester.tap(counterPageFinder);

    // Wait the widget state updated until the dismiss animation ends.
    await tester.pumpAndSettle();

    // Verify that a push event happened
    verify(navigatorObserver.didPush(any, any));

    // Verify that CounterPage opened
    expect(find.byType(CounterPage), findsOneWidget);
  });
}
