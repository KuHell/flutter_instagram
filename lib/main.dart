import 'package:flutter/material.dart';
import 'style.dart';

void main() {
  runApp(
    MaterialApp(
      theme: theme,
      home: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        title: Text('Instagram'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: (){},
            iconSize: 30,
          ),
        ],
      ),
      body: Text('안녕'),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵'),
        ],
      ),
    );
  }
}
