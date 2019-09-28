import 'package:flutter/material.dart';

import 'package:rest_router/parser.dart';
import 'package:rest_router/rest_navigator.dart';

/// Builder function with [parameters].
typedef Widget HandlerFunc(BuildContext context, Map<String, List<String>> parameters);

class Router {
  final _unknownRoute = "__UKNOWN_ROUTE__";

  /// Path with variables -> widget builders
  /// eg. {"days/:day": (BuildContext context, Map<String, List<String>> parameters) => Container()}
  final Map<String, HandlerFunc> pathHandlers;

  /// Builder for unknown route
  final HandlerFunc onUnknownRouteHandler;

  Router(this.pathHandlers, {@required this.onUnknownRouteHandler}) {
    pathHandlers[_unknownRoute] = onUnknownRouteHandler;
  }

  bool _matchPathHandler(List<String> parts, String handlerPath) {
    // Sections of handler URL separated by slashes
    final handlerParts = handlerPath.split("/");

    // Must have same number of parts
    if (parts.length != handlerParts.length) {
      return false;
    }

    // Lockstep
    for (int i = 0; i < parts.length; i++) {
      // Non-variable parts must match
      if (!handlerParts[i].startsWith(":") && parts[i] != handlerParts[i]) {
        return false;
      }
    }

    // Route found
    return true;
  }

  /// Generates routes based on [routeSettings].
  /// Used with [MaterialApp.onGenerateRoute] and normal [Navigator] operations.
  Route<dynamic> generator(RouteSettings routeSettings) {
    // Determines route transition based on navigator arguments
    // Defaults to no transition, may throw cast error
    final transitionType = routeSettings.arguments as TransitionType ?? TransitionType.none;

    // TODO: use arguments for completer??? - no other way to get equivalent to pop returns (complete it on didPop?!) (ensure only that one page gets it)

    // Sections of URL separated by slashes
    final parts = routeSettings.name.split("/");

    // Find corresponding path handler
    // Fails if multiple handlers found
    // Defaults to [onUnknownRouteHandler] if no handlers found
    final handlerPath = pathHandlers.keys.singleWhere((handlerPath) => _matchPathHandler(parts, handlerPath), orElse: () => _unknownRoute);

    // Parsed parameters and their values
    final parameters = parsePathParameters(handlerPath, routeSettings.name);

    // TODO: switch by transition type

    // Animation
    return MaterialPageRoute<dynamic>(
      settings: routeSettings,
      builder: (BuildContext context) => pathHandlers[handlerPath](context, parameters)
    );
  }
}