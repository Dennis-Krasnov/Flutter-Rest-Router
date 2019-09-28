import 'package:flutter_test/flutter_test.dart';

import 'package:rest_router/parser.dart';

void main() {
  group("Successfuly parse valid URLs", () {
    test("Parse normal URL", () {
      expect(
        parsePathParameters("/settings/theme", "/settings/theme"),
        <String, List<String>>{
          handlerPathKey: ["/settings/theme"],
          urlPathKey: ["/settings/theme"],
        }
      );
    });

    test("Parse URL with path variables", () {
      expect(
        parsePathParameters("/user/:id", "/user/323"),
        <String, List<String>>{
          handlerPathKey: ["/user/:id"],
          urlPathKey: ["/user/323"],
          "id": ["323"],
        }
      );
    });

    test("Parse URL with repeating path variables", () {
      expect(
        parsePathParameters("user/:id/again/:id", "user/123/again/456"),
        <String, List<String>>{
          handlerPathKey: ["user/:id/again/:id"],
          urlPathKey: ["user/123/again/456"],
          "id": ["123", "456"],
        }
      );
    });

    // TODO: extract ?var=value&another=value2 variables as well!
  });

  group("Fail to parse malformed URLs", () {
    test("Mismatched parameter count", () {
      expect(
        () => parsePathParameters("/settings/theme", "settings"),
        throwsArgumentError
      );
    });

    test("Mismatched parameters", () {
      expect(
          () => parsePathParameters("/settings/theme", "/settings/themes"),
          throwsArgumentError
      );
    });
  });
}

// Map<String, List<String>> parsePathParameters(String handlerPath, String url) {