// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState()),
        ChangeNotifierProvider(create: (context) => KeyboardState()),
      ],
      //create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedPlayIndex = 0;

  void updatePlayIndex(int index) {
    selectedPlayIndex = index;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const TitlePage();
        break;
      case 1:
        page = const PlayPage();
        break;
      case 2:
        page = const LeaderboardPage();
        break;
      case 3:
        page = const OptionsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 1000,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.sports_esports),
                    label: Text('Play'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.star_rounded),
                    label: Text('Highscores'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                    appState.updatePlayIndex(0);
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome! Let's get practicing!",
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
          ),
          const SizedBox(height: 30),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: 'MODES',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Typing Practice',
            style: TextStyle(fontSize: 30),
          ),
          const Text(
            'Just keep typing, just keep typing~',
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            '100 Word Dash',
            style: TextStyle(fontSize: 30),
          ),
          const Text(
            'Type 100 words as fast as you can!',
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Minute to Win It',
            style: TextStyle(fontSize: 30),
          ),
          const Text(
            'Put your skills to the test! Can you type 100 words in 1 minute?',
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    Widget page = const DifficultySelectPage();
    var appState = context.watch<MyAppState>();
    switch (appState.selectedPlayIndex) {
      case 0:
        page = const DifficultySelectPage();
        break;
      case 1:
        page = const TypingPracticePage();
        break;
      case 2:
        page = const MinuteToWinPage();
        break;
      case 3:
        page = const HundredWordDashPage();
        break;
      default:
        throw UnimplementedError('no widget');
    }

    return Container(
      child: page,
    );
  }
}

class DifficultySelectPage extends StatelessWidget {
  const DifficultySelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var keyboardState = context.watch<KeyboardState>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'SELECT MODE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                height: 300,
                width: 300,
                child: FilledButton(
                  onPressed: () {
                    keyboardState.resetWords();
                    keyboardState.addWords(15);
                    appState.updatePlayIndex(1);
                  },
                  child: const Text(
                    'Typing Practice',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: SizedBox(
                height: 300,
                width: 300,
                child: FilledButton(
                  onPressed: () {
                    keyboardState.resetWords();
                    keyboardState.addWords(100);
                    appState.updatePlayIndex(2);
                  },
                  child: const Text(
                    'Minute to Win it',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: SizedBox(
                height: 300,
                width: 300,
                child: FilledButton(
                  onPressed: () {
                    keyboardState.resetWords();
                    keyboardState.addWords(100);
                    appState.updatePlayIndex(3);
                  },
                  child: const Text(
                    'Hundred Word Dash',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeyboardState extends ChangeNotifier {
  KeyboardState() {
    loadWords().then((value) {
      wordBank = value.split("\r\n"); // \n new line, \r\n carriage return
    });
  }

  var wordBank = <String>[];
  var wordWidgets = <Widget>[];
  var currentWords = <String>[];
  int charInWidgetsCount = 0;
  int wordCount = 0;
  int charInWordCount = 0;

  Color correctColor = Colors.green;
  Color incorrectColor = Colors.red;
  Color defaultColor = Colors.black;

  Future<String> loadWords() async {
    final String response = await rootBundle.loadString('assets/words.txt');
    return response;
  }

  void resetWords() {
    wordWidgets.clear();
    currentWords.clear();
    charInWidgetsCount = 0;
    wordCount = 0;
    charInWordCount = 0;
  }

  void addWords(int numberOfWords) {
    int startPoint = currentWords.length;
    int wordBankSize = wordBank.length;
    for (int i = 0; i < numberOfWords; i++) {
      int nextPosition = Random().nextInt(wordBankSize);
      //print(wordBank[nextPosition]);
      //print('Word added to bank: ' + wordBank[nextPosition]);
      currentWords.add(wordBank[nextPosition]);
    }

    for (var i = startPoint; i < currentWords.length; i++) {
      //print('Word added to widget: ' + currentWords[i]);
      for (var j = 0; j < currentWords[i].length; j++) {
        wordWidgets.add(Text(
          currentWords[i][j],
          style: const TextStyle(color: Colors.black),
        ));
      }
      wordWidgets.add(const Text(
        ' ',
        style: TextStyle(color: Colors.black),
      ));
    }
    //print(currentWords[wordCount]);
    notifyListeners();
  }

  void replaceChar(Color color, String key, pos) {
    Text newText = Text(key, style: TextStyle(color: color));
    wordWidgets[pos] = newText;
    notifyListeners();
  }

  String currentCharacter() {
    String result = '';
    if (currentWords[wordCount].length > charInWordCount) {
      result = currentWords[wordCount][charInWordCount];
    }
    return result;
  }

  bool excessTyping() {
    return currentWords[wordCount].length <= charInWordCount;
  }

  void addChild(String char, Color color, int pos) {
    wordWidgets.insert(
        pos,
        Text(
          char,
          style: TextStyle(color: color),
        ));
    notifyListeners();
  }

  void moveToNextWord() {
    if (charInWordCount < currentWords[wordCount].length) {
      int missingChars = currentWords[wordCount].length - charInWordCount;
      for (int i = 0; i < missingChars; i++) {
        replaceChar(
          incorrectColor, 
          currentWords[wordCount][charInWordCount + i], 
          charInWidgetsCount + i
        );
      }
      charInWidgetsCount += missingChars + 1;
      charInWordCount = 0;
      wordCount++;
    } else {
      charInWidgetsCount++;
      charInWordCount = 0;
      wordCount++;
    }

    // print("space");
  }

  void correctCharTyped(String keyInput) {
    replaceChar(correctColor, keyInput, charInWidgetsCount);
    charInWordCount++;
    charInWidgetsCount++;
    // print("correct");
  }

  void incorrectCharTyped() {
    replaceChar(
      incorrectColor, 
      currentWords[wordCount][charInWordCount], 
      charInWidgetsCount
    );
    charInWordCount++;
    charInWidgetsCount++;
    // print('wrong');
  }

  void addIncorrectChar(String char) {
    addChild(char, incorrectColor, charInWidgetsCount);
    charInWordCount++;
    charInWidgetsCount++;
    // print("overflow");
  }

  void deleteChar() {
    if (charInWordCount > 0) {
      if (charInWordCount <= currentWords[wordCount].length) {
        charInWidgetsCount--;
        charInWordCount--;
        // print("delete in limit");
        replaceChar(
          defaultColor, 
          currentWords[wordCount][charInWordCount],
          charInWidgetsCount
        );
      } else {
        charInWidgetsCount--;
        Widget w = wordWidgets.removeAt(charInWidgetsCount);
        // print(w);
        charInWordCount--;
        // print("delete over limit");
        notifyListeners();
      }
    }
  }
}

class TypingPracticePage extends StatelessWidget {
  const TypingPracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    var keyboardState = context.watch<KeyboardState>();
    Row wordsRow = Row(children: keyboardState.wordWidgets);

    return RawKeyboardListener(
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            keyboardState.moveToNextWord();
          } else if (event.character == keyboardState.currentCharacter()) {
            keyboardState.correctCharTyped(event.character.toString());
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            keyboardState.deleteChar();
          } else if (keyboardState.excessTyping()) {
            keyboardState.addIncorrectChar(event.character.toString());
          } else if (event.character != keyboardState.currentCharacter()) {
            keyboardState.incorrectCharTyped();
          }
        }
      },
      focusNode: FocusNode(),
      autofocus: true,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: wordsRow,
        ),
      ),
    );
  }
}

class MinuteToWinPage extends StatelessWidget {
  const MinuteToWinPage({super.key});

  @override
  Widget build(BuildContext context) {
    var keyboardState = context.watch<KeyboardState>();

    Wrap wordsRow = Wrap(children: keyboardState.wordWidgets);

    return RawKeyboardListener(
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            keyboardState.moveToNextWord();
          } else if (event.character == keyboardState.currentCharacter()) {
            keyboardState.correctCharTyped(event.character.toString());
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            keyboardState.deleteChar();
          } else if (keyboardState.excessTyping()) {
            keyboardState.addIncorrectChar(event.character.toString());
          } else if (event.character != keyboardState.currentCharacter()) {
            keyboardState.incorrectCharTyped();
          }
        }
      },
      focusNode: FocusNode(),
      autofocus: true,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: wordsRow,
        ),
      ),
    );
  }
}

class HundredWordDashPage extends StatelessWidget {
  const HundredWordDashPage({super.key});

  @override
  Widget build(BuildContext context) {
    var keyboardState = context.watch<KeyboardState>();

    Wrap wordsRow = Wrap(children: keyboardState.wordWidgets);

    return RawKeyboardListener(
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            keyboardState.moveToNextWord();
          } else if (event.character == keyboardState.currentCharacter()) {
            keyboardState.correctCharTyped(event.character.toString());
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            keyboardState.deleteChar();
          } else if (keyboardState.excessTyping()) {
            keyboardState.addIncorrectChar(event.character.toString());
          } else if (event.character != keyboardState.currentCharacter()) {
            keyboardState.incorrectCharTyped();
          }
        }
      },
      focusNode: FocusNode(),
      autofocus: true,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: wordsRow,
        ),
      ),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('LEADERBOARD'),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('OPTIONS'),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
