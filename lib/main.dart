import 'package:flutter/material.dart';
import 'package:recipe/ui/main_screen.dart';

void main() {
  // TODO: Call _setupLogging()
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RecipeFinder());
}

// TODO: Add _setupLogging()

class RecipeFinder extends StatelessWidget {
  const RecipeFinder({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
    );
  }
}
