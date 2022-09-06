import 'package:flutter/material.dart';
import 'package:recipe/ui/recipes/recipe_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> pageList = <Widget>[];
  // TODO: Add index key

  @override
  void initState() {
    pageList.add(const RecipeList());
    // TODO: Call getCurrentIndex
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
