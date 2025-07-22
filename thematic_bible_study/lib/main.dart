// lib/main.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/screens/bible_reader_screen.dart'; 
import 'package:thematic_bible_study/screens/thematic_study_screen.dart'; 
import 'package:thematic_bible_study/screens/home_page_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thematic Bible Study App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainAppWrapper(), // Changed home to a new wrapper widget
    );
  }
}

// NEW WIDGET: MainAppWrapper to handle BottomNavigationBar
class MainAppWrapper extends StatefulWidget {
  const MainAppWrapper({super.key});
  
  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  int _selectedIndex = 0; // Index of the selected tab

  // List of screens to display in the BottomNavigationBar
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BibleReaderScreen(),
    ThematicStudyScreen(),
    
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Display the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book), // Bible icon
            label: 'Read Bible',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.topic), // Topic/theme icon
            label: 'Themes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

