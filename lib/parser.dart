// TODO: rename something more descriptive, place under router?
import 'package:rest_router/rest_navigator.dart';

final handlerPathKey = "__HANDLER_PATH__";
final urlPathKey = "__PATH__";

/// Extracts path variables from a [url] given the [handlerPath].
/// After creating this, I realized https://github.com/peterzagoranski/flutter_router implemented this better.
Map<String, List<String>> parsePathParameters(String handlerPath, String url) {
  // Don't parse unknown routes
  if (handlerPath == Router.unknownRoute) {
    return <String, List<String>>{
      handlerPathKey: [handlerPath],
      urlPathKey: [url]
    };
  }

  // Sections of handler URL separated by slashes
  final handlerParts = handlerPath.split("/");

  // Sections of URL separated by slashes
  final parts = url.split("/");

  if (parts.length != handlerParts.length) {
    throw ArgumentError("Part count didn't match");
  }

  // Path variables
  var parameters = <String, List<String>>{
    handlerPathKey: [handlerPath],
    urlPathKey: [url]
  };

  // Lockstep
  for(int i = 0; i < handlerParts.length; i++) {
    // Variables only
    if (handlerParts[i].startsWith(":")) {
      // Variable name
      final key = handlerParts[i].substring(1);

      // Defensively create list for key
      if (!parameters.containsKey(key)) {
        parameters[key] = [];
      }

      // Add variable value to list
      parameters[key].add(parts[i]);
    }
    else if (parts[i] != handlerParts[i]) {
      throw ArgumentError("Parts didn't match");
    }
  }

  return parameters;
}