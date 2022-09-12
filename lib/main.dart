import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:recipe/data/memory_repository.dart';
import 'package:recipe/mock_service/mock_service.dart';
import 'package:recipe/ui/main_screen.dart';

void main() {
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
        ChangeNotifierProvider<MemoryRepository>(
          lazy: false,
          create: (_) => MemoryRepository(),
        ),
        Provider(
          create: (_) => MockService()..create(),
          lazy: false,
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
