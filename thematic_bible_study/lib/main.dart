// lib/main.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/screens/bible_reader_screen.dart'; // Ensure correct import
import 'package:thematic_bible_study/screens/thematic_study_screen.dart'; // NEW IMPORT

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
    BibleReaderScreen(),
    ThematicStudyScreen(),
    // You can add more screens here later (e.g., Search, Favorites)
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

// Your existing BibleReaderScreen (moved to its own file)
// You need to move the BibleReaderScreen code from main.dart to lib/screens/bible_reader_screen.dart
// I will provide the content for bible_reader_screen.dart below.