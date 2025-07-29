// lib/screens/solas_screen.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/models/sola.dart'; // Import the Sola model
import 'package:thematic_bible_study/screens/sola_detail_screen.dart'; // Import the SolaDetailScreen

class SolasScreen extends StatelessWidget {
  const SolasScreen({super.key});

  // This list holds all the Sola objects with their unique content
  final List<Sola> solas = const [
    Sola(
      title: 'Sola Scriptura',
      subtitle: 'Scripture Alone',
      meaning:
          "\"Sola Scriptura\" (Scripture Alone) is the formal principle of the Protestant Reformation. It asserts that the Bible is the sole infallible rule of faith and practice for the church and the Christian life. It holds that Scripture alone is the divinely inspired and authoritative Word of God, sufficient for all matters of Christian doctrine and life, and is perspicuous (clear) in its essential teachings. This means that traditions, councils, or human reason, while potentially helpful, do not hold the same authoritative weight as the Bible.",
      scriptures: [
        '2 Timothy 3:16-17 (All Scripture is God-breathed and is useful for teaching, rebuking, correcting and training in righteousness...)',
        '2 Peter 1:20-21 (Above all, you must understand that no prophecy of Scripture came about by the prophet’s own interpretation of things...)',
        'Isaiah 8:20 (To the Law and to the Testimony! If they do not speak according to this word, they have no light of dawn.)',
        'Deuteronomy 4:2 (Do not add to what I command you and do not subtract from it, but keep the commands of the Lord your God that I give you.)',
        'Psalm 19:7-11 (The law of the Lord is perfect, refreshing the soul...)',
      ],
      quotes: [ 
        {'text': 'Unless I am convinced by the testimony of the Scriptures or by clear reason, I am bound by the Scriptures I have quoted and my conscience is captive to the Word of God.', 'author': 'Martin Luther'},
        {'text': 'All things in Scripture are not alike plain in themselves, nor alike clear unto all; yet those things which are necessary to be known, believed, and observed, for salvation, are so clearly propounded and opened in some place of Scripture or other, that not only the learned, but the unlearned, in a due use of the ordinary means, may attain unto a sufficient understanding of them.', 'author': 'Westminster Confession of Faith'},
      ],
    ),
    Sola(
      title: 'Sola Fide',
      subtitle: 'Faith Alone',
      meaning:
          "\"Sola Fide\" (Faith Alone) means to be justified by faith alone, not by the works of man at all.",
      scriptures: [
        'Galatians 2:16 "Knowing that a man is not justified by the works of the law, but by the faith of Jesus Christ."',
        'Galatians 2:21 "I do not frustrate the grace of God. For if righteousness come by the law, then Christ is dead in vain."',
        'Hewbrews 11:33 "Who through faith subdued kingdoms, wrought righteousness, obtained promises, stopped the mouths of lions,"'
      ],
       quotes: [ 
        {'text': '"First have faith in Christ, and Christ will enable you to do and to live."', 'author': 'Martin Luther'},
        {'text': '"Faith is the divinity of works."', 'author': 'Martin Luther'},
      ],
    ),
    Sola(
      title: 'Sola Gratia',
      subtitle: 'Grace Alone',
      meaning:
          "\"Sola Gratia\" (Grace Alone) states that salvation is entirely by God's unmerited favor and love, not based on any human effort, merit, or inherent goodness. It emphasizes that God's grace is the sole cause of salvation, from initiation to completion. Humanity, being spiritually dead in sin, cannot contribute to its own redemption, making salvation purely a sovereign act of divine grace.",
      scriptures: [
        'Galatians 3:17 "And this I say, that the covenant, that was confirmed before of God in Christ, the law, which was four hundred and thirty years after, cannot disannul, that it should make the promise of none effect."',
        
      ],
       quotes: [ 
        {'text': 'Unless I am convinced by the testimony of the Scriptures or by clear reason, I am bound by the Scriptures I have quoted and my conscience is captive to the Word of God.', 'author': 'Martin Luther'},
        {'text': 'All things in Scripture are not alike plain in themselves, nor alike clear unto all; yet those things which are necessary to be known, believed, and observed, for salvation, are so clearly propounded and opened in some place of Scripture or other, that not only the learned, but the unlearned, in a due use of the ordinary means, may attain unto a sufficient understanding of them.', 'author': 'Westminster Confession of Faith'},
      ],
    ),
    Sola(
      title: 'Solus Christus',
      subtitle: 'Christ Alone',
      meaning:
          "\"Solus Christus\" (Christ Alone) affirms that salvation is accomplished through Jesus Christ alone. He is the sole mediator between God and humanity, and His atoning sacrifice on the cross is the only means by which sins are forgiven and reconciliation with God is achieved. No other person, prophet, ritual, or institution can provide salvation, nor is there any other name by which we must be saved.",
      scriptures: [
        'Galatians 3:13 "Christ hath redeemed us from the curse of the law, being made a curse for us: for it is written, Cursed is every one that hangeth on a tree:"',
        'Hebrews 8:6 "But now hath he obtained a more excellent ministry, inasmuch as he is also the mediator of a better covenant, which was established upon better promises."',
        'Hebrews 9:12 "Neither by the blood of goats and calves, but by his own blood he entered in once into the holy place, having obtained eternal redemption for us."',
        'Hebrews 10:10 "By the which will we are sanctified through the offering of the body of Jesus Christ once for all."',
      ],
       quotes: [ 
        {'text': 'Unless I am convinced by the testimony of the Scriptures or by clear reason, I am bound by the Scriptures I have quoted and my conscience is captive to the Word of God.', 'author': 'Martin Luther'},
        {'text': 'All things in Scripture are not alike plain in themselves, nor alike clear unto all; yet those things which are necessary to be known, believed, and observed, for salvation, are so clearly propounded and opened in some place of Scripture or other, that not only the learned, but the unlearned, in a due use of the ordinary means, may attain unto a sufficient understanding of them.', 'author': 'Westminster Confession of Faith'},
      ],
    ),
    Sola(
      title: 'Soli Deo Gloria',
      subtitle: 'Glory to God Alone',
      meaning:
          "\"Soli Deo Gloria\" (Glory to God Alone) asserts that all glory, honor, and worship belong to God alone. This principle holds that salvation, and indeed all of creation and every aspect of life, ministry, and worship, exist for God's glory. It stands against any human boast or self-exaltation, ensuring that God receives all credit for His gracious work of salvation and for His sovereign rule over all things.",
      scriptures: [
        'Romans 11:36 (For from him and through him and for him are all things. To him be the glory forever! Amen.)',
        '1 Corinthians 10:31 (So whether you eat or drink or whatever you do, do it all for the glory of God.)',
        'Psalm 115:1 (Not to us, Lord, not to us but to your name be the glory, because of your love and faithfulness.)',
        'Isaiah 42:8 (I am the Lord; that is my name! I will not yield my glory to another or my praise to idols.)',
      ],
       quotes: [ 
        {'text': 'Unless I am convinced by the testimony of the Scriptures or by clear reason, I am bound by the Scriptures I have quoted and my conscience is captive to the Word of God.', 'author': 'Martin Luther'},
        {'text': 'All things in Scripture are not alike plain in themselves, nor alike clear unto all; yet those things which are necessary to be known, believed, and observed, for salvation, are so clearly propounded and opened in some place of Scripture or other, that not only the learned, but the unlearned, in a due use of the ordinary means, may attain unto a sufficient understanding of them.', 'author': 'Westminster Confession of Faith'},
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Five Solas'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: solas.length,
        itemBuilder: (context, index) {
          final sola = solas[index]; // Get the specific Sola object for this card
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell( // Makes the card tappable with a ripple effect
              onTap: () {
                // Navigate to the SolaDetailScreen, passing the entire Sola object
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SolaDetailScreen(sola: sola),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sola.title, // Access title directly from the Sola object
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      sola.subtitle, // Access subtitle directly from the Sola object
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}