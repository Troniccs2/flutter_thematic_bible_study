import 'package:flutter/material.dart';

class ChurchHistoryScreen extends StatelessWidget {
  const ChurchHistoryScreen({super.key});

  // Data for each of the history cards
  final List<Map<String, dynamic>> _cardData = const [
    {
      'title': 'The Solas',
      'subtitle': 'Core Beliefs',
      'icon': Icons.article_outlined, // Using a scroll/article icon
    },
    {
      'title': 'Timeline',
      'subtitle': 'A Chronological Look',
      'icon': Icons.access_time, // Using a clock icon
    },
    {
      'title': 'Key Figures',
      'subtitle': 'Influential Leaders',
      'icon': Icons.person, // Using a person icon
    },
    {
      'title': 'Major Events',
      'subtitle': 'Defining Moments',
      'icon': Icons.flag, // Using a flag icon
    },
    {
      'title': 'Primary Docs',
      'subtitle': 'Original Writings',
      'icon': Icons.book, // Using a book icon
    },
    {
      'title': 'Glossary',
      'subtitle': 'Key Terms Explained',
      'icon': Icons.translate, // Using a translate/dictionary icon
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Church History'),
        backgroundColor: Theme.of(context).primaryColor, // Consistent app bar color
        elevation: 0, // Remove shadow under app bar for seamless look with header
      ),
      body: SingleChildScrollView( // Allows the content to scroll if it overflows
        child: Column(
          children: [
            // --- Header Section ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              // Decoration for the top background, you can add images here later
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.8), // A slightly transparent primary color
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CHURCH HISTORY',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [ // Adds a subtle shadow to the text for better contrast
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'The Story of Faith & Reform',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Spacing between header and grid

            // --- Grid of Cards Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true, // Important: allows GridView to take only necessary space inside SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Important: GridView itself won't scroll, outer SingleChildScrollView handles it
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 16.0, // Horizontal spacing between cards
                  mainAxisSpacing: 16.0, // Vertical spacing between cards
                  childAspectRatio: 0.9, // Adjust card height (e.g., 1.0 for square, <1.0 for wider, >1.0 for taller)
                ),
                itemCount: _cardData.length,
                itemBuilder: (context, index) {
                  final card = _cardData[index];
                  return _buildHistoryCard(
                    context,
                    card['title']!,
                    card['subtitle']!,
                    card['icon']!,
                  );
                },
              ),
            ),
            const SizedBox(height: 20), // Spacing at the bottom of the screen
          ],
        ),
      ),
    );
  }

  // Helper method to build each history card
  Widget _buildHistoryCard(BuildContext context, String title, String subtitle, IconData icon) {
    return Card(
      elevation: 4, // Adds a shadow effect
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded corners
      child: InkWell( // Makes the entire card tappable with a ripple effect
        onTap: () {
          // TODO: Implement navigation to specific history sections based on the tapped card
          // For now, it just shows a snackbar message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You tapped on: $title')),
          );
        },
        borderRadius: BorderRadius.circular(15), // Ensures ripple effect matches card shape
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor), // Large icon with app's primary color
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}