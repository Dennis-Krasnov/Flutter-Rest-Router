# Rest Navigator

A simple flutter router that parses path parameters.

This package was inspired by [fluro](https://github.com/theyakka/fluro).

## Getting Started

The easiest way to get started is by looking at an example:

```dart
import 'package:flutter/material.dart';
import 'package:rest_router/parser.dart';
import 'package:rest_router/rest_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final router = Router({
    "/": (BuildContext context, Map<String, List<String>> parameters) => HomePage(),
    "/items": (BuildContext context, Map<String, List<String>> parameters) => SubPage("path is /items"),
    "/plus_two/:num": (BuildContext context, Map<String, List<String>> parameters) => SubPage("sum is ${int.parse(parameters["num"]?.first) + 2}"),
  }, onUnknownRouteHandler: (BuildContext context, Map<String, List<String>> parameters) => SubPage("${parameters[urlPathKey]?.first} is 404"));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rest navigator demo',
      initialRoute: "/",
      onGenerateRoute: router.generator,
    );
  }
}

/// Navigates to sub pages.
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("/")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Item list"),
              onPressed: () => Navigator.of(context).pushNamed("/items", arguments: TransitionType.native),
            ),
            RaisedButton(
              child: Text("Run /plus_two/40"),
              onPressed: () => Navigator.of(context).pushNamed("/plus_two/40", arguments: TransitionType.native),
            ),
            RaisedButton(
              child: Text("Invalid path"),
              onPressed: () => Navigator.of(context).pushNamed("/itemz"), // Defaults to instant transition
            ),
          ],
        ),
      ),
    );
  }
}

/// Scaffold with app bar title.
class SubPage extends StatelessWidget {
  final String title;

  SubPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
    );
  }
}
```


Note you have specify `arguments: TransitionType.native` to achieve native transitions. The rationale is that this is better for a deep-link powered app. Feel free to fork this project to make opiniated changes.

The [source code](https://github.com/Dennis-Krasnov/Flutter-Rest-Router) is available to fully understand what's going in under the hood, and PRs are always welcome.