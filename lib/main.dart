import 'package:flutter/material.dart';
import 'views/views.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Tasks Counter',
      home: Scaffold(
        body: TaskCounterScreen(),
      ),
    );
  }
}

void main() => runApp(App());
