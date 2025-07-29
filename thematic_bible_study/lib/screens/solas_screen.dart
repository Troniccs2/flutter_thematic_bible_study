// lib/screens/solas_screen.dart
import 'package:flutter/material.dart';
import 'package:thematic_bible_study/models/sola.dart';
import 'package:thematic_bible_study/screens/sola_detail_screen.dart';

class SolasScreen extends StatelessWidget {
  const SolasScreen({super.key});

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
          "\"Sola Fide\" (Faith Alone) is the material principle of the Protestant Reformation. It declares that justification (being declared righteous before God) is by faith alone, apart from works. This means salvation is a gift received through trusting in Jesus Christ and His finished work on the cross, not earned by human merit, good deeds, or adherence to religious rituals. Faith is the instrument through which God's grace is apprehended.",
      scriptures: [
        'Romans 3:28 (For we maintain that a person is justified by faith apart from the works of the law.)',
        'Ephesians 2:8-9 (For it is by grace you have been saved, through faith—and this is not from yourselves, it is the gift of God—not by works, so that no one can boast.)',
        'Galatians 2:16 (know that a person is not justified by the works of the law, but by faith in Jesus Christ.)',
        'Philippians 3:9 (and be found in him, not having a righteousness of my own that comes from the law, but that which is through faith in Christ—the righteousness that comes from God on the basis of faith.)',
      ],
      quotes: [
        {'text': 'Faith is a living, bold trust in God\'s grace, so certain of God\'s favor that it would risk death a thousand times for it.', 'author': 'Martin Luther'},
        {'text': 'It is pure grace, because faith is a gift of God, and because our works, if they have any value, are a result of this faith.', 'author': 'John Calvin'},
      ],
    ),
    Sola(
      title: 'Sola Gratia',
      subtitle: 'Grace Alone',
      meaning:
          "\"Sola Gratia\" (Grace Alone) states that salvation is entirely by God's unmerited favor and love, not based on any human effort, merit, or inherent goodness. It emphasizes that God's grace is the sole cause of salvation, from initiation to completion. Humanity, being spiritually dead in sin, cannot contribute to its own redemption, making salvation purely a sovereign act of divine grace.",
      scriptures: [
        'Ephesians 2:8 (For it is by grace you have been saved, through faith—and this is not from yourselves, it is the gift of God—)',
        'Romans 11:6 (And if by grace, then it cannot be based on works; if it were, grace would no longer be grace.)',
        'Titus 3:5 (he saved us, not because of righteous things we had done, but because of his mercy.)',
        'John 6:44 (No one can come to me unless the Father who sent me draws them, and I will raise them up at the last day.)',
      ],
      quotes: [
        {'text': 'Free grace, for Christ\'s sake, through faith alone, is the grand message of the gospel.', 'author': 'Charles Spurgeon'},
        {'text': 'There is nothing in man that merits grace.', 'author': 'Augustine of Hippo'},
      ],
    ),
    Sola(
      title: 'Solus Christus',
      subtitle: 'Christ Alone',
      meaning:
          "\"Solus Christus\" (Christ Alone) affirms that salvation is accomplished through Jesus Christ alone. He is the sole mediator between God and humanity, and His atoning sacrifice on the cross is the only means by which sins are forgiven and reconciliation with God is achieved. No other person, prophet, ritual, or institution can provide salvation, nor is there any other name by which we must be saved.",
      scriptures: [
        'Acts 4:12 (Salvation is found in no one else, for there is no other name under heaven given to mankind by which we must be saved.)',
        'John 14:6 (Jesus answered, “I am the way and the truth and the life. No one comes to the Father except through me.)',
        '1 Timothy 2:5 (For there is one God and one mediator between God and mankind, the man Christ Jesus,)',
        'Hebrews 9:15 (For this reason Christ is the mediator of a new covenant, that those who are called may receive the promised eternal inheritance—now that he has died as a ransom to set them free from the sins committed under the first covenant.)',
      ],
      quotes: [
        {'text': 'Christ alone is the head of the church...', 'author': 'Westminster Confession of Faith'},
        {'text': 'We are saved not by what we do...', 'author': 'R.C. Sproul'},
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
        {'text': 'The chief end of man is to glorify God and to enjoy him forever.', 'author': 'Westminster Shorter Catechism'},
        {'text': 'All for His glory alone. This is the ultimate goal of all things.', 'author': 'R.C. Sproul'},
      ],
    ),
  ];

  String? _getSolaButtonImagePath(String solaTitle) {
    switch (solaTitle) {
      case 'Sola Scriptura':
        return 'assets/images/sola_Scriptura.png';
      case 'Sola Fide':
        return 'assets/images/sola_Fide.png';
      case 'Sola Gratia':
        return 'assets/images/sola_Gratia.png';
      case 'Solus Christus':
        return 'assets/images/sola_Christus.png';
      case 'Soli Deo Gloria':
        return 'assets/images/sola_Deo_Gloria.png';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Five Solas'),
      ),
      body: Stack(
        children: [
          // This is the background for the entire screen, now in full color
          Positioned.fill(
            child: Opacity( // Retain Opacity for "lighter" effect
              opacity: 0.8, // Adjust opacity as needed
              child: Image.asset(
                'assets/images/reformation_background.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: solas.length,
            itemBuilder: (context, index) {
              final sola = solas.elementAt(index);
              final String? buttonImagePath = _getSolaButtonImagePath(sola.title);

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SolaDetailScreen(sola: sola),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12.0),
                  child: Stack(
                    children: [
                      if (buttonImagePath != null)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Opacity( // Retain Opacity for "lighter" effect on cards
                              opacity: 0.5, // Adjust opacity for "lighter" effect on card
                              child: Image.asset(
                                buttonImagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sola.title,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Changed to black
                                shadows: [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.white70, // Shadow for black text
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              sola.subtitle,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black87, // Changed to black87
                                shadows: [
                                  Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Colors.white70, // Shadow for black text
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(Icons.arrow_forward_ios, color: Colors.black54), // Changed to black54
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}