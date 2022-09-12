import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:recipe/data/memory_repository.dart';
import 'package:recipe/data/repository.dart';
import 'package:recipe/network/recipe_service.dart';
import 'package:recipe/network/service_interface.dart';
import 'package:recipe/ui/main_screen.dart';

Future<void> main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RecipeFinder());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('Response ${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class RecipeFinder extends StatelessWidget {
  const RecipeFinder({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Repository>(
          lazy: false,
          create: (_) => MemoryRepository(),
        ),
        Provider<ServiceInterface>(
          create: (_) => RecipeService.create(),
        ),
      ],
      child: MaterialApp(
        title: 'Recipes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
