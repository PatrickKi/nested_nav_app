import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

const routeHome = '/';
const routeFirstPage = 'first';
const routeSecondPage = 'second';
const routeThirdPage = 'third';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  Color? randomColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 350,
                width: 250,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.amber[400],
                      child: Navigator(
                        key: _navigatorKey,
                        initialRoute: routeFirstPage,
                        onGenerateRoute: _onGenerateRoute,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Route? _onGenerateRoute(RouteSettings routeSettings) {
    late Widget page;
    if (routeSettings.name == routeHome || routeSettings.name == routeFirstPage) {
      page = FirstPage(
        onNext: () {
          _navigatorKey.currentState!.pushNamed(routeSecondPage);
        },
      );
    } else if (routeSettings.name == routeSecondPage) {
      page = SecondPage(
        onNext: () {
          _navigatorKey.currentState!.pushNamed(routeThirdPage);
        },
        onBack: () {
          _navigatorKey.currentState!.pop(true);
        },
        randomColor: randomColor,
        onRandomColor: () {
          setState(() {
            var rand = Random();
            randomColor = Color.fromARGB(
                255, rand.nextInt(100) + 100, rand.nextInt(100) + 100, rand.nextInt(100) + 100);
          });
        },
      );
    } else if (routeSettings.name == routeThirdPage) {
      page = ThirdPage(
        onBack: () {
          _navigatorKey.currentState!.pop(true);
        },
      );
    } else {
      throw Exception('Unknown route: ${routeSettings.name}');
    }
    return PageRouteBuilder(
        settings: routeSettings,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.ease;
          final tweenIn = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero);
          final tweenOut = Tween(begin: Offset.zero, end: const Offset(-1.0, 0.0));

          return SlideTransition(
              position: tweenIn.animate(CurvedAnimation(parent: animation, curve: curve)),
              child: SlideTransition(
                  position:
                      tweenOut.animate(CurvedAnimation(parent: secondaryAnimation, curve: curve)),
                  child: child));
        });
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key, this.onNext, this.onBack}) : super(key: key);

  final void Function()? onNext;
  final void Function()? onBack;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
            child: Container(
          color: Colors.blueGrey,
          child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: widget.onNext,
              child: const Text("Navigate to second page"),
            ),
            ElevatedButton(
              onPressed: widget.onBack,
              child: const Text("Navigate back"),
            ),
          ])),
        ))
      ],
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({
    Key? key,
    this.onNext,
    this.onBack,
    this.onRandomColor,
    this.randomColor,
  }) : super(key: key);

  final void Function()? onNext;
  final void Function()? onBack;
  final void Function()? onRandomColor;
  final Color? randomColor;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
            child: Container(
          color: widget.randomColor,
          child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: widget.onNext,
              child: const Text("Navigate to third page"),
            ),
            ElevatedButton(
              onPressed: widget.onBack,
              child: const Text("Navigate back"),
            ),
            ElevatedButton(
              onPressed: widget.onRandomColor,
              child: const Text("Change to random color"),
            ),
          ])),
        ))
      ],
    );
  }
}

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key, this.onNext, this.onBack}) : super(key: key);

  final void Function()? onNext;
  final void Function()? onBack;

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
            child: Container(
          color: Colors.green[200],
          child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: widget.onBack,
              child: const Text("Navigate back"),
            ),
          ])),
        ))
      ],
    );
  }
}
