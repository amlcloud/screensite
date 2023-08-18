import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:screensite/search/search_page.dart';

import 'cases/case_page.dart';
import 'cases/cases_page.dart';
import 'lists/lists_page.dart';
import 'login_page.dart';

final _key = GlobalKey<NavigatorState>();

final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final AsyncValue<User?> authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _key,
    debugLogDiagnostics: true,
    initialLocation: SearchPage.routeLocation,
    routes: [
      GoRoute(
        path: SearchPage.routeLocation,
        name: SearchPage.routeName,
        builder: (context, state) {
          return SearchPage();
        },
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: SearchPage(),
        ),
      ),
      GoRoute(
        path: ListsPage.routeLocation,
        name: ListsPage.routeName,
        builder: (context, state) {
          return ListsPage();
        },
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: ListsPage(),
        ),
      ),
      GoRoute(
          path: CasesPage.routeLocation,
          name: CasesPage.routeName,
          builder: (context, state) {
            return CasesPage();
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: CasesPage(),
              ),
          routes: [
            GoRoute(
              path: ':caseId', //CasePage.routeName,
              name: CasePage.routeName,
              builder: (context, state) {
                print(
                    "state: ${(state.extra as Map<String, dynamic>)['caseId']}");
                // get id from state
                // final id = state.queryParameters['caseId'] ?? "";
                return CasePage(
                    (state.extra as Map<String, dynamic>)['caseId']);
              },
              pageBuilder: (context, state) {
                // final id = state.queryParameters['caseId'] ?? "";

                return buildPageWithDefaultTransition<void>(
                    context: context,
                    state: state,
                    child: CasePage(
                        (state.extra as Map<String, dynamic>)['caseId']));
              },
            ),
          ]),
      GoRoute(
        path: LoginPageWidget.routeLocation,
        name: LoginPageWidget.routeName,
        builder: (context, state) {
          return const LoginPageWidget();
        },
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: LoginPageWidget(),
        ),
      ),
    ],
    redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
      if (authState.isLoading || authState.hasError) return null;

      // Here we guarantee that hasData == true, i.e. we have a readable value

      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = authState.valueOrNull != null;

      if (!isAuth) {
        return LoginPageWidget.routeLocation;
      }

      final isLoggingIn = state.location == LoginPageWidget.routeLocation;
      if (isLoggingIn) return isAuth ? SearchPage.routeLocation : null;

      return isAuth ? null : SearchPage.routeLocation;
    },
  );
});
