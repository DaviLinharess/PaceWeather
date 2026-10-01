import 'package:flutter/material.dart';

/// Observer personalizado para monitorar e registrar no console todas
/// as operações da pilha de rotas do Flutter (push, pop, replace).
/// Atende ao requisito do print de console com logs de `debugPrint`.
class AppNavigatorObserver extends NavigatorObserver {
  final String scope;

  AppNavigatorObserver({this.scope = 'Global'});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final routeName = route.settings.name ?? route.runtimeType.toString();
    final prevName = previousRoute?.settings.name ?? previousRoute?.runtimeType.toString() ?? 'Nenhuma';
    debugPrint('🚀 [NAVIGATOR PUSH] [$scope] Empilhou: "$routeName" (Rota anterior: "$prevName")');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final routeName = route.settings.name ?? route.runtimeType.toString();
    final prevName = previousRoute?.settings.name ?? previousRoute?.runtimeType.toString() ?? 'Raiz';
    debugPrint('⬅️ [NAVIGATOR POP] [$scope] Desempilhou: "$routeName" (Retornou para: "$prevName")');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final newName = newRoute?.settings.name ?? newRoute?.runtimeType.toString();
    final oldName = oldRoute?.settings.name ?? oldRoute?.runtimeType.toString();
    debugPrint('🔄 [NAVIGATOR PUSH_REPLACEMENT] [$scope] Substituiu: "$oldName" por: "$newName"');
  }
}
